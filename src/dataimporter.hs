{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
module Main where

import qualified Data.ByteString.Lazy       as BSL
import qualified Data.Csv                   as Csv
import           Data.Int                   (Int64)
import           Data.Text                  (Text)
import qualified Data.Text                  as T
import           Data.Vector                (Vector)
import qualified Database.PostgreSQL.Simple as Psql
import           GHC.Generics
import           System.Console.CmdArgs
import           System.Exit                (exitFailure, exitSuccess)
import System.IO (hSetEcho, hFlush, stdout, stdin)

-- data importer
main :: IO ()
main = do
  opts <- cmdArgs options
  fileContents <- BSL.readFile $ inputFilename opts
  dbpass <- getPassword
  let csvContents = Csv.decodeByName fileContents :: Either String (Csv.Header, Vector SaleRecord)
  case csvContents of Left e -> do
                        putStrLn e
                        exitFailure
                      Right (_, saleRecords) -> do
                        conn <- Psql.connectPostgreSQL ""
                        _ <- insertSaleRecords conn saleRecords
                        exitSuccess

getPassword :: IO String
getPassword = do
  _ <- putStr "password: "
  _ <- hFlush stdout
  _ <- hSetEcho stdin False
  dbPass <- getLine
  _ <- hSetEcho stdin True
  _ <- putStrLn ""
  return dbPass

data SaleRecord = SaleRecord
  { item     :: Text
  , quantity :: Int
  , price    :: Double
  } deriving (Show, Generic)

instance Csv.ToNamedRecord SaleRecord
instance Csv.FromNamedRecord SaleRecord
instance Csv.DefaultOrdered SaleRecord

insertSaleRecords :: Psql.Connection -> Vector SaleRecord -> IO (Vector Int64)
insertSaleRecords conn srs = do
  _ <- Psql.begin conn
  rets <- mapM (insertSaleRecord conn) srs
  _ <- Psql.commit conn
  return rets

insertSaleRecord :: Psql.Connection -> SaleRecord -> IO Int64
insertSaleRecord conn sr =
  Psql.execute conn "insert into sales (item, quantity, price) values (?, ?, ?)"
    [item sr, T.pack . show $ quantity sr, T.pack . show $ price sr]

data Options = Options
  { inputFilename :: String
  , dbHost :: String
  , dbPort :: Int
  , dbName :: String
  , dbUser :: String
  } deriving (Data, Typeable)

options :: Options
options = Options
  { inputFilename = def
                 &= argPos 0
                 &= typFile
  , dbHost = def
          &= help "The hostname of the database"
  , dbPort = def
          &= help "The port of the database"
  , dbName = def
          &= help "The name of the database"
  , dbUser = def
          &= help "The user of the database"
           
  }
  &= summary "Dirty csv data importer"
  &= program "dataimporter"
