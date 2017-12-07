{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.AlteraDados where

import Import
import Text.Julius
import Text.Lucius
import Text.Cassius

getAlteraDadosR :: Handler Html
getAlteraDadosR = do
    defaultLayout $ do 
        addStylesheet $ (StaticR css_creative_css)
        $(whamletFile "templates/home.julius")