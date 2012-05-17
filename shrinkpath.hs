import System.Environment
import Data.List
import Data.List.Split

shrink :: [String] -> [String]
shrink (x:xs) = shrink' x xs
    where
        shrink' x [x'] = take 2 x : [x']
        shrink' x xs = take 2 x : shrink xs
shrink x = x

shrinkpath :: String -> String
shrinkpath = intercalate "/" . shrink . splitOn "/"

main = do
    args <- getArgs
    putStr $ shrinkpath $ head args
