{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Index where

import Import
import Text.Julius
import Text.Lucius
import Text.Cassius


getIndexR :: Handler Html
getIndexR = do
    defaultLayout $ do
        addStylesheet $ (StaticR css_creative_scss)
        toWidget $ $(juliusFile "templates/javascriptus.julius")
        toWidget $ $(juliusFile "templates/javascriptus2.julius")
        $(whamletFile "templates/pghead.hamlet")
        $(whamletFile "templates/pg1.hamlet")
