module Queries
  ( insertFile
  , insertTag
  , insertFileTag
  , findFileByPath
  , findTagByText
  , findFilesWithTag
  , findFilesWithTagsConjunction
  , findAllFiles
  , findAllTags
  , addTagToFile
  ) where

import Database.SQLite.Simple
  ( Connection
  , NamedParam(..)
  , Only(..)
  , Query(..)
  , query_
  , queryNamed
  , execute
  )
import qualified Data.Text as T
import Data.List (intercalate)

import Types
  ( File(..)
  , Tag(..)
  , TagText
  )

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

returnFirst :: [a] -> Maybe a
returnFirst [] = Nothing
returnFirst (x : _) = Just x

findFileByPath :: Connection -> FilePath -> IO (Maybe File)
findFileByPath conn filePath = returnFirst <$> rows
  where
    rows = queryNamed conn "SELECT * FROM files WHERE path = :path" [":path" := filePath]

findTagByText :: Connection -> String -> IO (Maybe Tag)
findTagByText conn tagText = returnFirst <$> rows
  where
    rows = queryNamed conn "SELECT * FROM tags WHERE text = :text" [":text" := tagText]

findFilesWithTag :: Connection -> String -> IO [File]
findFilesWithTag conn tagText = queryNamed conn "SELECT f.* FROM files AS f INNER JOIN file_tags AS ft ON ft.file_id = f.id INNER JOIN tags AS t ON ft.tag_id = t.id WHERE t.text = :text" [":text" := tagText]

-- SQLite.Simple does not support list parameters (like use with "IN")
findFilesWithTagsConjunction :: Connection -> [String] -> IO [File]
findFilesWithTagsConjunction conn tags = query_ conn q
  where
    tagsFormat = intercalate "," . map (\t -> "'" ++ t ++ "'") $ tags
    q = Query $ T.pack $ "SELECT f.* FROM files AS f INNER JOIN file_tags AS ft ON ft.file_id = f.id INNER JOIN tags AS t ON ft.tag_id = t.id WHERE t.text IN (" ++ tagsFormat ++ ") GROUP BY f.id HAVING COUNT(DISTINCT t.text) = (SELECT COUNT(*) FROM tags WHERE text IN (" ++ tagsFormat ++ "))"

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
