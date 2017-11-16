{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Pagina where

import Import
import Text.Julius
import Text.Lucius
import Text.Cassius

-- PARA VC TER HTML NO HASKELL
-- USA-SE OS SHAKESPEAREAN TEMPLATES
-- hamlet -> HTML
-- lucius ou cassius -> CSS
-- julius -> Javascript
-- CASO ESTIVERMOS USANDO O SHAKESPEAREAN TEMPLATES
-- TODO HTML/CSS/JAVASCRIPT IRA PARA DENTRO DO EXECUTAVEL
getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_css)
        toWidgetHead $ $(juliusFile "templates/home.julius")
        toWidget $ $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/home.hamlet")

soma :: Int -> Int -> Int
soma x y = x+y

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:[]) = Nothing
safeHead (x:xs) = Just x

getHeadR :: String -> Handler Html
getHeadR palavra = do 
    palsafe <- return $ safeHead palavra -- Handler (Maybe [a])
    defaultLayout $ do
        [whamlet|
            $maybe pal <- palsafe
                <h1> #{pal}
            $nothing
                <h1> ERRO
        |]

getAddR :: Int -> Int -> Handler Html
getAddR x y = do 
    defaultLayout $ do 
        [whamlet|
            <h1> A SOMA EH: #{soma x y}
        |]

getListarR :: Handler Html
getListarR = do 
    lista <- return ["Santos","Palmeiras","Grêmio","Cruzeiro","Botafogo","Flamengo"] :: Handler [String]
    defaultLayout $ do 
        [whamlet|
            <ul>
                $forall time <- lista
                    <li> #{time}
        |]

exemploWidget :: Widget -> Widget
exemploWidget parametro = [whamlet|
    <div class="container">
        ^{parametro}
|]

wid1 :: Widget
wid1 = [whamlet|
    <h1> PAGINA 1
    <a href=@{HomeR}> Voltar
|]

getPag1R :: Handler Html
getPag1R = do 
    defaultLayout $ exemploWidget wid1

getPag2R :: Handler Html
getPag2R = do 
    defaultLayout $ do 
        addStylesheet $ (StaticR css_pag1_css)
        addStylesheet $ (StaticR css_bootstrap_css)
        [whamlet|
            <div class="container">
                <h1> PAGINA 2
                <a href=@{HomeR}> Voltar
        |]

getPag3R :: Handler Html
getPag3R = do 
    defaultLayout $ do 
        [whamlet|
            <h1> PAGINA 3
            <img src=@{StaticR img_haskell_jpg}>
            <a href=@{HomeR}> Voltar
        |]