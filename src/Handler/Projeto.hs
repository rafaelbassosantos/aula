{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Projeto where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postProjetoR :: Handler Value
postProjetoR = do 
    projeto <- requireJsonBody :: Handler Projeto
    pid <- runDB $ insert projeto
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey pid)])
    
getProjetoR :: Handler Value
getProjetoR = do
    todosProjetos <- runDB $ selectList [] [Asc ProjetoNome]
    sendStatusJSON ok200 (object ["resp" .= (toJSON todosProjetos)])
    
getPmpR :: ClienteId -> Handler Value
getPmpR cid = do
    todosProjetos <- runDB $ selectList [ProjetoPmp ==. cid] []
    sendStatusJSON ok200 (object ["resp" .= (toJSON todosProjetos)])

