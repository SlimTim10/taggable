module LibSpec (spec) where

import Test.Hspec

import Lib

spec :: Spec
spec = do
  describe "anotherFunc" $ do
    it "adds two numbers" $ do
      anotherFunc 2 3 `shouldBe` 5
