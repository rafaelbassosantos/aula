{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkMessage "App" "messages" "pt-BR"

mkYesodData "App" $(parseRoutesFile "config/routes")

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance Yesod App where
    makeLogger = return . appLogger

instance YesodBreadcrumbs App where
    breadcrumb HomeR = return ("Home", Nothing)
    breadcrumb (ENG ENPessoaR) = return ("EN", Just PessoaR)
    breadcrumb (UKR UKPessoaR) = return ("UK", Just PessoaR)
    breadcrumb (BRR BRPessoaR) = return ("BR", Just PessoaR)

myLayout :: Widget -> Handler Html
myLayout widget = do
    (title, parents) <- breadcrumbs
    pc <- widgetToPageContent widget
    withUrlRenderer [hamlet|$newline never
        $doctype 5
        <html>
            <head>
                <title>#{pageTitle pc}
                <meta charset=utf-8>
                <style>
                    body {
                        font-family: sans-serif;
                    }
                    #breadcrumbs {
                        font-size: small;
                    }
                    #breadcrumbs span {
                        margin: 0 .5em 0 0;
                    }
                ^{pageHead pc}
            <body>
                <nav #breadcrumbs>
                    <span>
                        You are here:#
                    $forall bc <- parents
                        <span>
                            <a href=@{fst bc}>
                                #{snd bc}
                            \ &gt;
                    <span>
                        #{title}
                <article>
                    ^{pageBody pc}
    |]

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager

