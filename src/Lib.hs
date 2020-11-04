module Lib
    ( someFunc
    , anotherFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

anotherFunc :: Integer -> Integer -> Integer
anotherFunc a b = a + b
