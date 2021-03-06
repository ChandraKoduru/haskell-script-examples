# Haskell scripting examples #

After you've gone and done that haskell beginners course and learned to think
functionally you go to work with giant ideas of writing perfect functional code
and building a better world. Then the suit from accounting turns up and needs a
script to put a csv in a database and they need it right now, so you betray your
bright new ideas and reach for ruby/perl/python/bash/go to do it fast because
you know how to do such things in that language fast.

In this talk we'll be doing a code review of some simple haskell scripts that do
common scripty tasks like taking input, reading things, printing things, calling
webservices, reading csvs, and querying databases. Armed with these examples you
should be prepared to introduce haskell to your workplace via dodgy scripts.

# Reading order #
  1. [echo.hs](src/echo.hs) 
    - basic cli args
    - basic printing
  2. [cat.hs](src/cat.hs)
    - reading a file
  3. [head.hs](src/head.hs) 
    - complex cli args
  4. [tee.hs](src/tee.hs) 
    - IO handles
    - writing files
  5. [curl.hs](src/curl.hs) 
    - making http requests 
  6. [redditcrawler.hs](src/redditcrawler.hs) 
    - reading json webservices
    - writing csvs
  7. [dataimporter.hs](src/dataimporter.hs)
    - reading csvs
    - running db queries

