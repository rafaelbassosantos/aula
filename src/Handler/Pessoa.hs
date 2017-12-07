{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Pessoa where

import Import
import Database.Persist.Postgresql

formPessoa :: Form Pessoa
formPessoa = renderDivs $ Pessoa 
    <$> areq textField "Nome: " Nothing
    <*> areq dayField "Data de Nascimento: " Nothing
    <*> areq textField "Usuario: " Nothing
    <*> areq textField "Telefone: " Nothing
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

getPessoaR :: Handler Html
getPessoaR = do 
    (widget,enctype) <- generateFormPost formPessoa
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{PessoaR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postPessoaR :: Handler Html
postPessoaR = do 
    ((resultado,_),_) <- runFormPost formPessoa
    case resultado of 
        FormSuccess usr -> do 
            _ <- runDB $ insert usr
            setMessage [shamlet|
                <div> 
                    Pessoa com sucesso!
            |]
            redirect PessoaR
        _ -> redirect HomeR