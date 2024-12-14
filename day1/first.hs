module Main where

import Control.Monad (join)
import Data.Bifunctor (bimap)

main :: IO ()
split :: String -> Char -> [String]
qsort :: (Ord a) => [a] -> [a]
minus :: (Num a) => [a] -> [a] -> [a]
main = do
  input <- readFile "input.txt"
  let lines = map (\x -> split x ' ') (split input '\n')
      horizonNumStr = filter (("", "") /=) $ map (\x -> (head x, last x)) lines
      horizonNum = map (join bimap (\a -> read a :: Int)) horizonNumStr
  let (l1, l2) = unzip horizonNum
  let l3 = minus (qsort l1) (qsort l2)
  print $ foldl (+) 0 l3

split str delim = case break (== delim) str of
  (a, _ : b) -> a : split b delim
  (a, _) -> [a]

qsort [] = []
qsort (x : xs) = qsort (filter (< x) xs) ++ [x] ++ qsort (filter (>= x) xs)

minus [] _ = []
minus _ [] = []
minus (x : xs) (y : ys) = (abs $ x - y) : (minus xs ys)
