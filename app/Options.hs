module Options
  ( options
  , Options(..)
  ) where

import Options.Applicative

data Options = Options
  { workingDir :: FilePath
  }

parseOptions :: Parser Options
parseOptions = Options
  <$> strOption
  ( long "directory"
    <> short 'd'
    <> metavar "DIRECTORY"
    <> showDefault
    <> value "."
    <> help "Working directory"
  )

options :: ParserInfo Options
options = info (parseOptions <**> helper)
  $ fullDesc
  <> progDesc "Run taggable"
  <> header "taggable"
