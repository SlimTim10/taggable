module Types
  ( File(..)
  , Tag(..)
  , TagText
  , FileTag(..)
  ) where

import Database.SQLite.Simple
  ( FromRow(..)
  , ToRow(..)
  , field
  )

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
