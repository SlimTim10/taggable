module Web
  ( runServer
  ) where

import Web.Scotty

import Control.Monad.IO.Class (liftIO)
import Database.SQLite.Simple (Connection)

import Queries
  ( findAllFiles
  )

runServer :: Connection -> IO ()
runServer dbConn = scotty 3000 $ do
  get "/files" $ showFiles dbConn
  get "/:word" showTest

showTest :: ActionM ()
showTest = do
  beam <- param "word"
  html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

showFiles :: Connection -> ActionM ()
showFiles dbConn = do
  fs <- liftIO $ findAllFiles dbConn
  json fs
