select 
	I.codigo_cie, I.codigo_inep, I.nome_escola, I.nome_municipio, COO.DS_LATITUDE, COO.DS_LONGITUDE
	------ Desempenho IDESP -------
	, nullif(I.anos_iniciais, 0) as IDESP_AI_18
	, nullif(I.anos_finais, 0) AS IDESP_AF_18
	, nullif(I.ensino_medio, 0) AS IDESP_EM_18
	------ SARESP  -------
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '3º Ano EF' and E.ds_comp = 'MATEMÁTICA') as saresp3EF_Mat
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '3º Ano EF' and E.ds_comp = 'LÍNGUA PORTUGUESA') as saresp3EF_LP
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '5º Ano EF' and E.ds_comp = 'MATEMÁTICA') as saresp5EF_Mat
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '5º Ano EF' and E.ds_comp = 'LÍNGUA PORTUGUESA') as saresp5EF_LP
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '9º Ano EF' and E.ds_comp = 'MATEMÁTICA') as saresp9EF_Mat
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = '9º Ano EF' and E.ds_comp = 'LÍNGUA PORTUGUESA') as saresp9EF_LP
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = 'EM-3ª série' and E.ds_comp = 'MATEMÁTICA') as saresp3EM_Mat
	, (select E.medprof from SARESP_escolas_2018 e where e.CODESC = I.CODIGO_CIE and E.SERIE_ANO = 'EM-3ª série' and E.ds_comp = 'LÍNGUA PORTUGUESA') as saresp3EM_LP
	--------- Nivel ESCOLA -------------
	, ATU.NO_CATEGORIA, ATU.NO_DEPENDENCIA -- Aluno Turma
	, nullif(ATU.FUN_AI_CAT_0, 0) AS MEDIA_ALUNOS_TURMA_AI
	, nullif(ATU.FUN_AF_CAT_0, 0) AS MEDIA_ALUNOS_TURMA_AF
	, nullif(ATU.MED_CAT_0, 0) AS MEDIA_ALUNOS_TURMA_EM
	, INSE.[NIVEL SOCIOECONOMICO DOS ALUNOS] AS INSE
	-- Complexidade escolar
	, ICG.[Nivel de complexidade de gestao da escola] AS COMPLEXIDADE_ESCOLAR
	, IRD.IRD AS REGULARIDADE_DOCENTE -- Regularidade corpo docente
	-- Esforço docente
	, IED.FUN_AI_CAT_1, IED.FUN_AI_CAT_2, IED.FUN_AI_CAT_3, IED.FUN_AI_CAT_4, IED.FUN_AI_CAT_5, IED.FUN_AI_CAT_6
	, IED.FUN_AF_CAT_1, IED.FUN_AF_CAT_2, IED.FUN_AF_CAT_3, IED.FUN_AF_CAT_4, IED.FUN_AF_CAT_5, IED.FUN_AF_CAT_6
	, IED.MED_CAT_1, IED.MED_CAT_2, IED.MED_CAT_3, IED.MED_CAT_4, IED.MED_CAT_5, IED.MED_CAT_6 
	--, TDI. -- Taxa Distorcao Idade-serie
	-- *
	--------- Nivel DIRETOR -------------
	-- Questionario SAEB Diretor
	, count(DIR.cd_escola) AS NUM_Diretores_2014a2019
	, case TD.TX_RESP_Q001 when 'A' then 'Masculino' else 'Feminino' end as Sexo_Diretor
	, case VWD.[TX_RESP_Q002] when 'A' then 'Ate24' when 'B' then 'De25a29' when 'C' then 'De30a29' when 'D' then 'De40a49' when 'E' then 'De50a54' when 'F' then '55mais' end as Faixa_Etaria_Diretor
	, VWD.[TX_RESP_Q004], VWD.[TX_RESP_Q006], VWD.[TX_RESP_Q008], VWD.[TX_RESP_Q010]
	, VWD.[TX_RESP_Q014], VWD.[TX_RESP_Q015], VWD.[TX_RESP_Q016], VWD.[TX_RESP_Q017], VWD.[TX_RESP_Q018], VWD.[TX_RESP_Q019]
	, VWD.[TX_RESP_Q026], VWD.[TX_RESP_Q027], VWD.[TX_RESP_Q028], VWD.[TX_RESP_Q032], VWD.[TX_RESP_Q037], VWD.[TX_RESP_Q038]
	, VWD.[TX_RESP_Q039], VWD.[TX_RESP_Q040], VWD.[TX_RESP_Q041], VWD.[TX_RESP_Q042], VWD.[TX_RESP_Q043], VWD.[TX_RESP_Q044]
	, VWD.[TX_RESP_Q045], VWD.[TX_RESP_Q046], VWD.[TX_RESP_Q047], VWD.[TX_RESP_Q048], VWD.[TX_RESP_Q049], VWD.[TX_RESP_Q050]
	, VWD.[TX_RESP_Q051], VWD.[TX_RESP_Q052], VWD.[TX_RESP_Q053], VWD.[TX_RESP_Q054], VWD.[TX_RESP_Q055]
	, VWD.[TX_RESP_Q077], VWD.[TX_RESP_Q078], VWD.[TX_RESP_Q079], VWD.[TX_RESP_Q080], VWD.[TX_RESP_Q086]
	, GE.TEM_GRÊMIO AS 'TEM_GREMIO'
	, iif(PEI.ANO is not null, 'Sim', 'Não') AS 'PEI'
	, iif(ETI.ANO is not null, 'Sim', 'Não') AS 'ETI'
	, VWD.[TX_RESP_Q067], VWD.[TX_RESP_Q068], VWD.[TX_RESP_Q069], VWD.[TX_RESP_Q070], VWD.[TX_RESP_Q071], VWD.[TX_RESP_Q072], VWD.[TX_RESP_Q073], VWD.[TX_RESP_Q074], VWD.[TX_RESP_Q075], VWD.[TX_RESP_Q076]
	, VWD.[TX_RESP_Q081], VWD.[TX_RESP_Q082], VWD.[TX_RESP_Q083], VWD.[TX_RESP_Q084], VWD.[TX_RESP_Q085]
	, VWD.[TX_RESP_Q090], VWD.[TX_RESP_Q091], VWD.[TX_RESP_Q092], VWD.[TX_RESP_Q093], VWD.[TX_RESP_Q094]
	, VWD.[TX_RESP_Q095], VWD.[TX_RESP_Q096], VWD.[TX_RESP_Q097], VWD.[TX_RESP_Q098], VWD.[TX_RESP_Q099]
	, VWD.[TX_RESP_Q100], VWD.[TX_RESP_Q101], VWD.[TX_RESP_Q102], VWD.[TX_RESP_Q103], VWD.[TX_RESP_Q104]
	, VWD.[TX_RESP_Q105], VWD.[TX_RESP_Q106], VWD.[TX_RESP_Q107], VWD.[TX_RESP_Q108]
from
	-- [dbo].[SARESP_escolas_2018] S
	[dbo].[IDESP] I -- codigo_cie + codigo_inep
	left join [dbo].[INSE_Geral] INSE on I.codigo_cie = INSE.codesc
	left join [dbo].[ATU_ESCOLAS_2019] ATU on ATU.co_entidade = I.CODIGO_INEP
	left join [dbo].[ICG_2019_ESCOLAS] ICG on ICG.[Codigo da Escola] = I.CODIGO_INEP
	left join [dbo].[IED_ESCOLAS_2019] IED on IED.co_entidade = I.CODIGO_INEP
	left join [dbo].[IRD_ESCOLAS_2019] IRD on IRD.[Codigo da Escola] = I.CODIGO_INEP
	left join [dbo].[TDI_ESCOLAS_2019] TDI on TDI.co_entidade = I.CODIGO_INEP
	left join [dbo].[Escolas_Coordenadas] COO on COO.COD_ESC = I.CODIGO_CIE
	left join [dbo].[DIRETORES DE ESCOLA] DIR on DIR.CD_ESCOLA = I.CODIGO_CIE
	left join [dbo].[TS_DIRETOR] TD on TD.ID_ESCOLA = I.CODIGO_INEP
	left join [dbo].[vw_Diretor] VWD on VWD.ID_ESCOLA = I.CODIGO_INEP
	left join [dbo].[SARESP_escolas_2018] ESC on ESC.CODESC = I.CODIGO_CIE
	left join [dbo].[Gremios_Estudantis] GE on GE.CD_ESCOLA = I.CODIGO_CIE
	left join [dbo].PEI on PEI.COD_ESC = I.CODIGO_CIE
	left join [dbo].ETI on ETI.COD_ESC = I.CODIGO_CIE
where
	VWD.[TX_RESP_Q001] is not null
group by
	DIR.cd_escola, I.CODIGO_CIE, I.CODIGO_INEP
	, TD.ID_ESCOLA, TD.TX_RESP_Q001
	, I.nome_escola, I.nome_municipio, COO.DS_LATITUDE, COO.DS_LONGITUDE
	, I.anos_iniciais, I.anos_finais, I.ensino_medio
	, ATU.NO_CATEGORIA, ATU.NO_DEPENDENCIA -- Aluno Turma
	, ATU.FUN_AI_CAT_0, ATU.FUN_AF_CAT_0, ATU.MED_CAT_0
	, INSE.[NIVEL SOCIOECONOMICO DOS ALUNOS]
	, ICG.[Nivel de complexidade de gestao da escola] 
	, IRD.IRD 
	, IED.FUN_AI_CAT_1, IED.FUN_AI_CAT_2, IED.FUN_AI_CAT_3, IED.FUN_AI_CAT_4, IED.FUN_AI_CAT_5, IED.FUN_AI_CAT_6
	, IED.FUN_AF_CAT_1, IED.FUN_AF_CAT_2, IED.FUN_AF_CAT_3, IED.FUN_AF_CAT_4, IED.FUN_AF_CAT_5, IED.FUN_AF_CAT_6
	, IED.MED_CAT_1, IED.MED_CAT_2, IED.MED_CAT_3, IED.MED_CAT_4, IED.MED_CAT_5, IED.MED_CAT_6 
	, VWD.[TX_RESP_Q001], VWD.[TX_RESP_Q002], VWD.[TX_RESP_Q004], VWD.[TX_RESP_Q006], VWD.[TX_RESP_Q008], VWD.[TX_RESP_Q010]
	, VWD.[TX_RESP_Q014], VWD.[TX_RESP_Q015], VWD.[TX_RESP_Q016], VWD.[TX_RESP_Q017], VWD.[TX_RESP_Q018], VWD.[TX_RESP_Q019]
	, VWD.[TX_RESP_Q026], VWD.[TX_RESP_Q027], VWD.[TX_RESP_Q028], VWD.[TX_RESP_Q032], VWD.[TX_RESP_Q037], VWD.[TX_RESP_Q038]
	, VWD.[TX_RESP_Q039], VWD.[TX_RESP_Q040], VWD.[TX_RESP_Q041], VWD.[TX_RESP_Q042], VWD.[TX_RESP_Q043], VWD.[TX_RESP_Q044]
	, VWD.[TX_RESP_Q045], VWD.[TX_RESP_Q046], VWD.[TX_RESP_Q047], VWD.[TX_RESP_Q048], VWD.[TX_RESP_Q049], VWD.[TX_RESP_Q050]
	, VWD.[TX_RESP_Q051], VWD.[TX_RESP_Q052], VWD.[TX_RESP_Q053], VWD.[TX_RESP_Q054], VWD.[TX_RESP_Q055]
	, VWD.[TX_RESP_Q077], VWD.[TX_RESP_Q078], VWD.[TX_RESP_Q079], VWD.[TX_RESP_Q080], VWD.[TX_RESP_Q086]
	, GE.TEM_GRÊMIO, PEI.ANO, ETI.ANO
	, VWD.[TX_RESP_Q067], VWD.[TX_RESP_Q068], VWD.[TX_RESP_Q069], VWD.[TX_RESP_Q070], VWD.[TX_RESP_Q071], VWD.[TX_RESP_Q072], VWD.[TX_RESP_Q073], VWD.[TX_RESP_Q074], VWD.[TX_RESP_Q075], VWD.[TX_RESP_Q076]
	, VWD.[TX_RESP_Q081], VWD.[TX_RESP_Q082], VWD.[TX_RESP_Q083], VWD.[TX_RESP_Q084], VWD.[TX_RESP_Q085]
	, VWD.[TX_RESP_Q090], VWD.[TX_RESP_Q091], VWD.[TX_RESP_Q092], VWD.[TX_RESP_Q093], VWD.[TX_RESP_Q094]
	, VWD.[TX_RESP_Q095], VWD.[TX_RESP_Q096], VWD.[TX_RESP_Q097], VWD.[TX_RESP_Q098], VWD.[TX_RESP_Q099]
	, VWD.[TX_RESP_Q100], VWD.[TX_RESP_Q101], VWD.[TX_RESP_Q102], VWD.[TX_RESP_Q103], VWD.[TX_RESP_Q104]
	, VWD.[TX_RESP_Q105], VWD.[TX_RESP_Q106], VWD.[TX_RESP_Q107], VWD.[TX_RESP_Q108]
order by
	I.codigo_cie