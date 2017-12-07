{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Julius
import Text.Lucius
import Text.Cassius
import Database.Persist.Postgresql


formLogin :: Form (Text,Text)
formLogin = renderDivs $ (,) 
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing


autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Pessoa))
autenticar email senha = runDB $ selectFirst [PessoaEmail ==. email
                                             ,PessoaSenha ==. senha] []

getLoginR :: Handler Html
getLoginR = do 
    (widget,enctype) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe mensa <- msg 
                <h1> Usuario Invalido
            <form action=@{LoginR} method=post>
                ^{widget}
                <input type="submit" value="Login">  
        |]

postLoginR :: Handler Html
postLoginR = do
    ((res,_),_) <- runFormPost formLogin
    case res of 
        FormSuccess (email,senha) -> do 
            talvezLogin <- autenticar email senha 
            case talvezLogin of 
                Nothing -> do 
                    setMessage $ 
                        [shamlet| Usuario ou senha invalido |]
                    redirect LoginR 
                Just (Entity _ usur) -> do 
                    setSession "_NOME" (pessoaUsuario usur)
                    redirect HomeR
            redirect LoginR
        _ -> redirect IndexR
                

postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_NOME"
    redirect IndexR
    