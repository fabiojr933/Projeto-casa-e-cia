select
PAR.EMPRESA,
PAR.CLIENTE,
sum(PAR.VALORPENDENTE) as VALORPENDENTE,
CLG.NOME as NOMECLIENTE,
--'6699539490' as FONE,
CLG.FONE,
EMP.NOMEFANTASIA as NOMEEMPRESA
from TRECPARCELA PAR
left outer join TRECDOCUMENTO DCT on (DCT.EMPRESA = PAR.EMPRESA and DCT.CLIENTE = PAR.CLIENTE and DCT.TIPO = PAR.TIPO and DCT.DOCUMENTO = PAR.DOCUMENTO)
left outer join TRECTIPODOCUMENTO TIP on (TIP.CODIGO = DCT.TIPO)
left outer join TRECBAIXA BXA on (BXA.EMPRESA = PAR.EMPRESA and BXA.CLIENTE = PAR.CLIENTE and BXA.TIPO = PAR.TIPO and BXA.DOCUMENTO = PAR.DOCUMENTO and BXA.PARCELA = PAR.PARCELA)
left outer join TVENPEDIDO PED on (PED.EMPRESA = PAR.EMPRESA and PED.CODIGO = PAR.DOCUMENTO and PED.CLIENTE = PAR.CLIENTE)
left outer join TRECPORTADOR POR on (POR.CODIGO = PAR.PORTADOR)
left outer join TESTNATUREZA NAT on (NAT.CODIGO = PED.TIPOOPERACAO)
left outer join TRECCLIENTE CLI on (CLI.EMPRESA = DCT.EMPRESA and CLI.CODIGO = DCT.CLIENTE)
left outer join TRECCLIENTEGERAL CLG on (CLG.CODIGO = DCT.CLIENTE)
left outer join TRECTIPOCLIENTE TCL on (TCL.COD_TIPO = CLG.TIPOCLIENTE)
left outer join TGERCIDADE CID on (CID.CODIGO = CLG.CIDADE)
left outer join TGERESTADO EST on (EST.ESTADO = CID.ESTADO)
left outer join TGERVALORINDICE IND1 on (IND1.INDICE = DCT.INDICE and IND1.DATA = current_date)
left outer join TGERVALORINDICE IND2 on (IND2.INDICE = DCT.INDICE and IND2.DATA = PAR.VENCIMENTO)
left outer join TESTCONDPAGVENDA CON on (CON.CODIGO = PED.CONDICAOPAGTO and CON.EMPRESA = PED.EMPRESA)
left outer join TGEREMPRESA EMP on (EMP.CODIGO = PAR.EMPRESA)
inner join TRECREGIAO REC on (REC.CODIGO = CLG.REGIAO)
where PAR.IDRENEGOCIACAO is null and
      PAR.SITUACAO <> 'A' and
      PAR.DATABAIXA is null and
      PAR.VENCIMENTO between :DATAINICIAL and :DATAFINAL and
      not exists(select distinct TESTCONDPAGVENDA.ADMINISTRADORA
                 from TESTCONDPAGVENDA
                 where TESTCONDPAGVENDA.FORMA = 'AD' and
                       TESTCONDPAGVENDA.ADMINISTRADORA = CLI.CODIGO) and
      CLI.ATIVO = 'S' and
      PAR.EMPRESA = :EMPRESA and
      PAR.IDDESCONTO is null
      AND   CLG.FONE > '1' and
      substring(CLG.FONE from 1 for 3) IN ('669', '668') and
      char_length(CLG.FONE) = '10'

      group by 1,2,4,5,6
/*

Os telefones da Vivo, por exemplo, eram iniciados pelos n??meros 99, 98, 97, 96, 95, etc. Os n??meros da Claro eram iniciados em 94, 92, 93, 91, e os da Oi em 89, 88, 87, 86, 85 e 84.
*/


