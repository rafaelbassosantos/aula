{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Index where

import Import
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    pessoalogado <- lookupSession "_ID"
    myLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            $maybe people <- pessoalogado
                <h1> _{MsgBemvindo} - #{pessoaNome}
            $nothing
                <h1> _{MsgBemvindo} - _{MsgVisita}
            <ul>
                <li> <a href=@{PessoaR}> Cadastro de Usuario
                $maybe people <- pessoalogado
                    <li> 

                $nothing
                    <li> <a href=@{LogonR}> Logon
                    
        |]