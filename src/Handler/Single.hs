{-# LANGUAGE QuasiQuotes
           , TypeFamilies
           , MultiParamTypeClasses
           , TemplateHaskell
           , OverloadedStrings #-}

module Handler.Single where
import Foundation
import Yesod
{-
getPessoaR :: Handler Html
getPessoaR = myLayout [whamlet|$newline never
<h1>Homepage
<p>
    Quick links: #
    <a href=@{ENG ENPessoaR}>
        EN subsite
    \, #
    <a href=@{UKR UKPessoaR}>
        UK subsite
    \ and #
    <a href=@{BRR BRPessoaR}>
        admin pages
    \.
|]
-}
getBRPessoaR :: Handler Html
getBRPessoaR = do
    myLayout $ do
        [whamlet|$newline never
            <h1>Admin
        |]

getENPessoaR :: Handler Html
getENPessoaR = do
    myLayout $ do
        [whamlet|$newline never
            <h1>EN
    |]

getUKPessoaR :: Handler Html
getUKPessoaR = do
    myLayout $ do
        [whamlet|$newline never
            <h1>UK
        |]

