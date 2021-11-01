--XEM FILE ĐÁP ÁN
--CÂU 1
SELECT Title, ReleaseDate
FROM [Movies].[Film]
WHERE YEAR(ReleaseDate) > 2000 AND BudgetDollars > 300000000;

--CÂU 2
SELECT TOP 3 LG.Language AS NGON_NGU
		 , COUNT(DISTINCT FM.FilmID) AS SO_PHIM
		 , SUM(FM.BudgetDollars) AS TONG_KINH_PHI
		 , COUNT(DISTINCT AC.ActorID) AS SO_DIEN_VIEN
FROM [Movies].[Film] AS FM
INNER JOIN [Movies].[Language] AS LG
	ON FM.LanguageID = LG.LanguageID
INNER JOIN [Movies].[Role] AS RL
	ON FM.FilmID = RL.FilmID
INNER JOIN [Movies].[Actor] AS AC
	ON RL.ActorID = AC.ActorID
GROUP BY LG.Language
ORDER BY COUNT(DISTINCT FM.FilmID) DESC

--CÂU 3
WITH
	DV_NAM AS(
		SELECT TOP 1
			   AC.ActorID
			 , AC.FullName
			 , YEAR(AC.DoB) AS NAM_SINH
			 , COUNT(DISTINCT FM.FilmID) AS SO_PHIM_HD
		FROM [Movies].[Actor] AS AC
		INNER JOIN [Movies].[Role] AS RL
			ON AC.ActorID = RL.ActorID
		INNER JOIN [Movies].[Film] AS FM
			ON RL.FilmID = FM.FilmID
		INNER JOIN [Movies].[Genre] AS GN
			ON FM.GenreID = GN.GenreID
		WHERE AC.Gender = 'Male' AND GN.Genre = 'Action'
		GROUP BY AC.ActorID, AC.FullName, YEAR(AC.DoB)
		ORDER BY COUNT(DISTINCT FM.FilmID) DESC
	),
	GIAI_OSCAR AS(
		SELECT AC.ActorID, SUM(FM.OscarWins) AS SO_GIAI_OSCAR
		FROM [Movies].[Actor] AS AC
		INNER JOIN [Movies].[Role] AS RL
			ON AC.ActorID = RL.ActorID
		INNER JOIN [Movies].[Film] AS FM
			ON RL.FilmID = FM.FilmID
		INNER JOIN [Movies].[Genre] AS GN
			ON FM.GenreID = GN.GenreID
		WHERE AC.Gender = 'Male'
		GROUP BY AC.ActorID
	)
SELECT DV_NAM.FullName, DV_NAM.NAM_SINH, DV_NAM.SO_PHIM_HD, GIAI_OSCAR.SO_GIAI_OSCAR
FROM DV_NAM
INNER JOIN GIAI_OSCAR
	ON DV_NAM.ActorID = GIAI_OSCAR.ActorID

--CÂU 4
SELECT TOP 5 AC.FullName
		 , YEAR(AC.DoB) AS NAM_SINH
		 , COUNT(DISTINCT FM.FilmID) AS SO_PHIM
		 , SUM(OscarNominations) AS DE_CU_OSCAR
		 , SUM(FM.OscarWins) AS SO_GIAI_OSCAR
		 , (SUM(FM.OscarWins) * 100 / SUM(OscarNominations)) AS TY_LE_OSCAR_DECU
		 , (COUNT(DISTINCT FM.FilmID) * 100 / SUM(FM.OscarWins)) AS TY_LE_DAT_OSCAR
FROM [Movies].[Actor] AS AC
INNER JOIN [Movies].[Role] AS RL
	ON AC.ActorID = RL.ActorID
INNER JOIN [Movies].[Film] AS FM
	ON RL.FilmID = FM.FilmID
GROUP BY AC.FullName, YEAR(AC.DoB)
ORDER BY SUM(FM.OscarWins) DESC

