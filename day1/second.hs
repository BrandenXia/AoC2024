module Main where

import Control.Monad (join)
import Data.Bifunctor (bimap)

main :: IO ()
split :: String -> Char -> [String]
appearanceCount :: (Eq a) => a -> [a] -> Int
similarityScore :: Int -> [Int] -> Int
main = do
  input <- readFile "input.txt"
  let lines = map (\x -> split x ' ') (split input '\n')
      horizonNumStr = filter (("", "") /=) $ map (\x -> (head x, last x)) lines
      horizonNum = map (join bimap (\a -> read a :: Int)) horizonNumStr
  let (l1, l2) = unzip horizonNum
  let scores = map (\x -> similarityScore x l2) l1
  print $ foldl (+) 0 scores

split str delim = case break (== delim) str of
  (a, _ : b) -> a : split b delim
  (a, _) -> [a]

appearanceCount a = length . filter (== a)
similarityScore a l = a * (appearanceCount a l)
