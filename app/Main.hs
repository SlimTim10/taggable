module Main where

import Database.SQLite.Simple
  ( Connection
  , open
  , close
  )
import System.Directory (createDirectoryIfMissing, listDirectory)
import Options.Applicative (execParser)

import Options
  ( options
  , Options(..)
  )
import Schema (buildSchema)
import Queries
  ( insertFile
  , insertTag
  , findFilesWithTag
  , findAllFiles
  , findAllTags
  , addTagToFile
  )
import Web (runServer)
  
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

  runServer conn
  
  close conn
  where
    taggableDir = workingDir ++ "/" ++ taggableDirName
    dbPath = taggableDir ++ "/taggable.db"

populateFiles :: Connection -> FilePath -> IO ()
populateFiles conn dir = do
  allFiles <- listDirectory dir
  let files = filter (/= taggableDirName) allFiles
  mapM_ (insertFile conn) files
