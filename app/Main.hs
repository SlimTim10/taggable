module Main where

import Database.SQLite.Simple -- ()
import System.Directory (createDirectoryIfMissing, listDirectory)
import Options.Applicative (execParser)

import Options
  ( options
  , Options(..)
  )
import Schema (buildSchema)

data File =
  File
  { fileID :: Int
  , filePath :: String
  } deriving (Eq, Read, Show)
instance FromRow File where
  fromRow = File <$> field <*> field

data Tag =
  Tag
  { tagID :: Int
  , tagText :: String
  } deriving (Eq, Read, Show)
instance FromRow Tag where
  fromRow = Tag <$> field <*> field

type TagText = String

data FileTag = FileTag
  { fileTagID :: Int
  , ftFileID :: Int
  , ftTagID :: Int
  } deriving (Show)
instance FromRow FileTag where
  fromRow = FileTag <$> field <*> field <*> field
instance ToRow FileTag where
  toRow (FileTag _ftID ftFileID ftTagID) = toRow (ftFileID, ftTagID)

taggableDirName :: String
taggableDirName = ".taggable"

main :: IO ()
main = run =<< execParser options

run :: Options -> IO ()
run (Options workingDir) = do
  createDirectoryIfMissing False taggableDir
  conn <- open dbPath
  buildSchema conn
  populateFiles conn workingDir
  
  -- Tag seeds
  let sampleTags = ["pets", "cat", "birthday", "tricks"] :: [String]
  mapM_ (insertTag conn) sampleTags
  
  putStrLn "Files:"
  mapM_ print =<< findAllFiles conn
  putStrLn "Tags:"
  mapM_ print =<< findAllTags conn

  -- File tag seeds
  addTagToFile conn "cat1.txt" "pets"
  addTagToFile conn "cat2.txt" "pets"
  addTagToFile conn "cat1.txt" "cat"
  addTagToFile conn "cat2.txt" "cat"
  addTagToFile conn "cat1.txt" "birthday"
  addTagToFile conn "cat2.txt" "tricks"

  putStrLn "Files with tag: pets"
  pets <- findFilesWithTag conn "pets"
  mapM_ print pets
  putStrLn "Files with tag: cat"
  cats <- findFilesWithTag conn "cat"
  mapM_ print cats
  putStrLn "Files with tag: birthday"
  birthdays <- findFilesWithTag conn "birthday"
  mapM_ print birthdays
  putStrLn "Files with tag: tricks"
  tricks <- findFilesWithTag conn "tricks"
  mapM_ print tricks
  
  close conn
  where
    taggableDir = workingDir ++ "/" ++ taggableDirName
    dbPath = taggableDir ++ "/taggable.db"

-- Refactor all to ActionM (see Scotty)

insertFile :: Connection -> FilePath -> IO ()
insertFile conn filePath = do
  execute conn "INSERT OR IGNORE INTO files (path) VALUES (?)"
    (Only filePath)

insertTag :: Connection -> TagText -> IO ()
insertTag conn text = do
  execute conn "INSERT OR IGNORE INTO tags (text) VALUES (?)"
    (Only text)

insertFileTag :: Connection -> Int -> Int -> IO ()
insertFileTag conn fileID tagID = do
  execute conn "INSERT OR IGNORE INTO file_tags (file_id, tag_id) VALUES (?, ?)"
    (fileID, tagID)

populateFiles :: Connection -> FilePath -> IO ()
populateFiles conn dir = do
  allFiles <- listDirectory dir
  let files = filter (/= taggableDirName) allFiles
  mapM_ (insertFile conn) files

returnFirst :: [a] -> Maybe a
returnFirst [] = Nothing
returnFirst (x : _) = Just x

findFileByPath :: Connection -> FilePath -> IO (Maybe File)
findFileByPath conn filePath = returnFirst <$> rows
  where
    rows = queryNamed conn "SELECT * FROM files WHERE path = :path" [":path" := filePath] :: IO [File]

findTagByText :: Connection -> String -> IO (Maybe Tag)
findTagByText conn tagText = returnFirst <$> rows
  where
    rows = queryNamed conn "SELECT * FROM tags WHERE text = :text" [":text" := tagText] :: IO [Tag]

findFilesWithTag :: Connection -> String -> IO [File]
findFilesWithTag conn tagText = queryNamed conn "SELECT f.* FROM files AS f INNER JOIN file_tags AS ft ON ft.file_id = f.id INNER JOIN tags AS t ON ft.tag_id = t.id WHERE t.text = :text" [":text" := tagText] :: IO [File]

findAllFiles :: Connection -> IO [File]
findAllFiles conn = query_ conn "SELECT * from files"

findAllTags :: Connection -> IO [Tag]
findAllTags conn = query_ conn "SELECT * from tags"

addTagToFile :: Connection -> FilePath -> TagText -> IO ()
addTagToFile conn filePath tagText = do
  mFile <- findFileByPath conn filePath
  mTag <- findTagByText conn tagText
  case (mFile, mTag) of
    (Just file, Just tag) -> insertFileTag conn (fileID file) (tagID tag)
    _ -> return ()
