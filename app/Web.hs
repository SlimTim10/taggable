module Web
  ( runServer
  ) where

import Web.Scotty

import Control.Monad.IO.Class (liftIO)
import Database.SQLite.Simple (Connection)
import qualified Data.Text.Lazy as T
import Data.List.Split (splitOn)

import Queries
  ( findAllFiles
  , findFilesWithTagsConjunction
  , findAllTags
  )

runServer :: Connection -> IO ()
runServer dbConn = scotty 3000 $ do
  get "/files" $ getFiles dbConn
  get "/tags" $ getTags dbConn

getFiles :: Connection -> ActionM ()
getFiles dbConn = do
  tagsParam <- param "tags" `rescue` const getAllFiles
  let tags = splitOn "," . T.unpack $ tagsParam
  liftIO $ putStrLn $ "find tags: " ++ show tags
  fs <- liftIO $ findFilesWithTagsConjunction dbConn tags
  json fs
  where
    getAllFiles = do
      fs <- liftIO $ findAllFiles dbConn
      json fs
      finish

getTags :: Connection -> ActionM ()
getTags dbConn = do
  -- matchParam <- param "match" `rescue` const getAllTags
  getAllTags
  where
    getAllTags = do
      ts <- liftIO $ findAllTags dbConn
      json ts
      finish
