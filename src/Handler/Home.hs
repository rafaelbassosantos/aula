{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    pessoalogado <- lookupSession "_NOME"
    myLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
                }
            
            |]
        [whamlet|
            $maybe people <- pessoalogado
                <h1>
            $nothing
                <h1>
            <ul>
                <li> <a href=@{PessoaR}> Cadastro de Usuario
                $maybe people <- pessoalogado
                    <li> 

                $nothing
                    <li> <a href=@{LoginR}> Login
                    
        |]


formTexto :: Form Texto 
formTexto = renderDivs $ Texto 
    <$> areq textField "Texto: " Nothing
    
formVideo :: Form Video 
formVideo = renderDivs $ Video 
    <$> areq textField "URL: " Nothing
    
formArquivo :: Form FileInfo
formArquivo = renderDivs $ areq fileField 
                           FieldSettings{fsId=Just "hident1",
                                         fsLabel="Arquivo: ",
                                         fsTooltip= "Somente arquivos tipo PNG.",
                                         fsName= Nothing,
                                         fsAttrs=[("accept","image/jpeg")]} 
                           Nothing

        
receberTextoId :: TextoId -> TextoId
receberTextoId tid = tid

getTextoR :: TextoId -> Handler Html
getTextoR tid = do
    (widget,enctype) <- generateFormPost formTexto
    defaultLayout $ do 
        [whamlet|
            <form action=@{TextoId} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]
    redirect IndexR
    
postTextoR :: Handler Html
postTextoR = do
    redirect IndexR

getTextoBuscaR :: TextoId -> Handler Html
getTextoBuscaR tid = do
    redirect IndexR

getVideoR :: Handler Html
getVideoR = do
    redirect IndexR
    
postVideoR :: Handler Html
postVideoR = do
    redirect IndexR

getBuscaVideoR :: VideoId -> Handler Html
getBuscaVideoR vid = do
    redirect IndexR

getFotosR :: Handler Html
getFotosR = do
    redirect IndexR
    
postFotosR :: Handler Html
postFotosR = do
    redirect IndexR

getBuscaFotosR :: FotosId -> Handler Html
getBuscaFotosR fid = do
    redirect IndexR

{-

module Handler.Pagina where

import Import
import Text.Julius

-- getPag1R :: Handler Html
-- getPag1R = do
--     defaultLayout $ do
--         toWidget $ [lucius|
--             h1 {
--                 color: pink;
--             }
--         |]
--         [whamlet|
--             <h1> Pagina 1
--             <a href=@{HomeR}> Voltar
--         |]

-- getPag2R :: Handler Html
-- getPag2R = do
--     defaultLayout $ do
--         toWidget $ [lucius|
--             h1 {
--                 color: #4e4e4e;
--             }
--         |]
--         [whamlet|
--             <h1> Pagina 2
--             <a href=@{HomeR}> Voltar
--         |]

-- getPag3R :: Handler Html
-- getPag3R = do
--     defaultLayout $ do
--         toWidget $ [lucius|
--             h1 {
--                 color: purple;
--             }
--         |]
--         [whamlet|
--             <h1> Pagina 3
--             <a href=@{HomeR}> Voltar
--         |]

-- soma :: Int -> Int -> Int
-- soma x y = x + y

-- getAddR :: Int -> Int -> Handler Html
-- getAddR x y = do 
--     defaultLayout $ do
--         [whamlet|
--             <h1> A SOMA EH: #{soma x y}
--         |]

-- getHomeR :: Handler Html
-- getHomeR = do
--     defaultLayout $ do 
--         toWidgetHead $ $(juliusFile "templates/home.julius")
--         addStylesheet $ (StaticR css_home_css)
--         addStylesheet $ (StaticR css_bootstrap_css)
--         $(whamletFile "templates/home.hamlet")
        
-- paginaDentro :: Widget
-- paginaDentro = do 
--     toWidget $ [cassius|
--         h1
--             color:orange;
--     |]
--     [whamlet|
--         <h1> Ola mundo
--     |]

-- safeTail :: [a] -> Maybe [a]
-- safeTail [] = Nothing
-- safeTail (x:[]) = Nothing
-- safeTail (_:xs) = Just xs

-- getTailR :: Text -> Handler Html
-- getTailR palavra = do
--     palstring <- return $ unpack palavra
--     t <- return $ safeTail palstring -- Handler (Maybe [a])
--     defaultLayout $ do 
--         [whamlet|
--             $maybe jt <- t
--                 <h1> O TAIL EH: #{jt}
--             $nothing
--                 <h1> ERRO
--         |]

-- -- $maybe -> Handler (Maybe a)
-- -- $forall -> Handler ([a])

-- getListR :: Handler Html
-- getListR = do
--     lista <- return $ ["Santos","Gremio","Palmeiras","Cruzeiro","Botafogo","Flamengo"] :: Handler [String]
--     defaultLayout $ do 
--         [whamlet|
--             <ul>
--                 $forall time <- lista
--                     <li> #{ time }
--         |]

-- getExemploR :: Handler Html
-- getExemploR = do 
--     defaultLayout $ do 
--         addStylesheet $ (StaticR css_bootstrap_css)
--         [whamlet|
--             <div class="container">
--                 ^{paginaDentro}
--         |]

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    addStylesheet $ StaticR css_bootstrap_css
    toWidgetHead $ [hamlet|
      <meta charset="UTF-8">
      <meta name="description" content="Site da Terapia Holística feito na framework Yesod">
      <meta name="keywords" content="Terapia, Holistica, Tratamento, Agendar">
    |]
    
    $(whamletFile "templates/header.hamlet")
    $(whamletFile "templates/conteudoindex.hamlet")
    $(whamletFile "templates/footer.hamlet")

getAgendarR :: Handler Html
getAgendarR = undefined
getContatoR :: Handler Html
getContatoR = undefined
getSobreR :: Handler Html
getSobreR = undefined
-}