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
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)

data File =
  File
  { id :: Int
  , path :: String
  } deriving (Eq, Read, Show, Generic)

instance FromRow File where
  fromRow = File <$> field <*> field

instance FromJSON File
instance ToJSON File

data Tag =
  Tag
  { id :: Int
  , text :: String
  } deriving (Eq, Read, Show, Generic)

instance FromRow Tag where
  fromRow = Tag <$> field <*> field

instance FromJSON Tag
instance ToJSON Tag

type TagText = String

data FileTag = FileTag
  { id :: Int
  , fileID :: Int
  , tagID :: Int
  } deriving (Eq, Read, Show, Generic)

instance FromRow FileTag where
  fromRow = FileTag <$> field <*> field <*> field

instance ToRow FileTag where
  toRow (FileTag _ftID fileID tagID) = toRow (fileID, tagID)

instance FromJSON FileTag
instance ToJSON FileTag
