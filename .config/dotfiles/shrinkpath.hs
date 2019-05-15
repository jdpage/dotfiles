import Data.Char
import System.Environment
import System.FilePath

shrinkname (x:y:xs)
    | isLower x && isLower y   = shrinkname (x:xs)
    | otherwise                = x:shrinkname (y:xs)
shrinkname xs = xs

shrinkpath path
    | path == "~"   = "~"
    | otherwise     = let (d, f) = splitFileName path in shrinkname d </> f

main = do
    args <- getArgs
    putStr $ shrinkpath $ head args
