{-# LANGUAGE QuasiQuotes #-}

module Schema
  ( buildSchema
  ) where

import Text.RawString.QQ
import Database.SQLite.Simple
  ( Connection
  , Query
  , fromQuery
  , connectionHandle
  )
import qualified Database.SQLite3 as Sqlite3

rawSchema :: Query
rawSchema = [r|
CREATE TABLE IF NOT EXISTS files (
  id INTEGER PRIMARY KEY,
  path TEXT NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS tags (
  id INTEGER PRIMARY KEY,
  text TEXT NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS file_tags (
  id INTEGER PRIMARY KEY,
  file_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  FOREIGN KEY(file_id) REFERENCES files(id),
  FOREIGN KEY(tag_id) REFERENCES tags(id)
);
|]

buildSchema :: Connection -> IO ()
buildSchema conn = execRawQuery conn rawSchema

execRawQuery :: Connection -> Query -> IO ()
execRawQuery conn query = Sqlite3.exec (connectionHandle conn) (fromQuery query)
