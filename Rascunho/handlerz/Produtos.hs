{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.Produto where

import Import
import Database.Persist.Postgresql

formProd :: Form Produto 
formProd = renderDivs $ Produto 
    <$> areq textField "Nome: " Nothing
    <*> areq doubleField "Preco: " Nothing 
    <*> areq intField "Estoque: " Nothing
    <*> areq (selectField catsLista) "Categoria: " Nothing

--    <$> areq textField "Nome: " Nothing
--    <*> areq emailField "Email: " Nothing
--    <*> areq passwordField "Senha: " Nothing
--    <*> areq dayField      "Data de Nasc: " Nothing

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

catsLista = do
       entidades <- runDB $ selectList [] [Asc CategoriaNome] 
       optionsPairs $ fmap (\ent -> (categoriaNome $ entityVal ent, entityKey ent)) entidades

    
getProdutoR :: Handler Html
getProdutoR = do 
    (widget,enctype) <- generateFormPost formProd
    defaultLayout $ do 
        [whamlet|
            <form action=@{ProdutoR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postProdutoR :: Handler Html 
postProdutoR = do 
    ((resultado,_),_) <- runFormPost formProd
    case resultado of 
        FormSuccess produto -> do 
            pid <- runDB $ insert produto
            redirect (PerfilProdR pid)
        _ -> redirect HomeR

catbyId :: CategoriaId -> Widget
catbyId cid = do 
    categoria <- handlerToWidget $ runDB $ get404 cid
    [whamlet|
        #{categoriaNome categoria}
    |]

getListaProdutoR :: Handler Html
getListaProdutoR = do 
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do 
        [whamlet|
            <table>
                <thead>
                    <tr>
                        <td> 
                            Nome
                        <td>
                            Preco
                        <td>
                            Estoque
                        <td>
                            Categoria
                        <td>
                            
                <tbody>
                    $forall (Entity pid produto) <- produtos
                        <tr>
                            <td> 
                                <a href=@{PerfilProdR pid}> 
                                    #{produtoNome produto}
                            <td>
                                #{produtoPreco produto}
                            <td>
                                #{produtoEstoque produto}
                            <td>
                                ^{catbyId $ produtoCatid produto}
                            <td>
                                <form action=@{ApagarProdR pid} method=post>
                                    <input type="submit" value="Apagar">
                        
                        
        |]

getPerfilProdR :: ProdutoId -> Handler Html
getPerfilProdR pid = do
    produto <- runDB $ get404 pid
    defaultLayout $ do 
        [whamlet|
            <h1> Produto #{produtoNome produto}
            <h2> Estoque #{produtoEstoque produto}
            <h2> Preco #{produtoPreco produto}
            <h2>
                ^{catbyId $ produtoCatid produto}
        |]
        
postApagarProdR :: ProdutoId -> Handler Html
postApagarProdR pid = do 
    _ <- runDB $ get404 pid
    runDB $ delete pid 
    redirect ListaProdutoR