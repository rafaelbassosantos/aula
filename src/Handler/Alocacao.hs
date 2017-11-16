{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Alocacao where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postAlocacaoR :: ClienteId -> ProjetoId -> Handler Value
postAlocacaoR cid pid = do
    _ <- runDB $ get404 cid
    _ <- runDB $ get404 pid
    alocid <- runDB $ insert (Alocacao cid pid)
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey alocid)])

third :: (a,b,c) -> c
third (_,_,c) = c

-- Entity Cliente == Entity ClienteId Cliente
getListarCliR :: ProjetoId -> Handler Value
getListarCliR pid = do 
    lista <- runDB $ rawSql
        ("SELECT ??, ??, ?? \
        \FROM projeto INNER JOIN alocacao \
        \ON projeto.id=alocacao.projid INNER JOIN cliente \
        \ON alocacao.cliid = cliente.id WHERE projeto.id = " <> (pack $ show $ fromSqlKey pid))
        [] :: Handler [(Entity Projeto, Entity Alocacao, Entity Cliente)]
    entityClientes <- return $ fmap third lista -- Handler [Entity Cliente]
    clientes <- return $ fmap (\(Entity _ cli) -> cli) entityClientes -- Handler [Cliente]
    sendStatusJSON ok200 (object ["resp" .= (toJSON clientes)])

getListarClifR :: ProjetoId -> Handler Value
getListarClifR pid = do 
    alocacoes' <- runDB $ selectList [AlocacaoProjid ==. pid] [] -- Handler [Alocacao]
    alocacoes <- return $ fmap (\(Entity _ alo) -> alo) alocacoes'
    clids <- return $ fmap alocacaoCliid alocacoes -- Handler [ClientId]
    clientes <- sequence $ fmap (\clid -> runDB $ get404 clid) clids -- Handler [Cliente]
    sendStatusJSON ok200 (object ["resp" .= (toJSON clientes)])