
-- ************************************************
-- PART I - 3.1.1 SQL2
-- ************************************************

	-- M_CUS와 T_ORD의 이너-조인
SELECT CUS.CUS_ID
    , CUS.CUS_GD
    , ORD.ORD_SEQ
    , ORD.CUS_ID
    , ORD.ORD_DT
FROM M_CUS CUS
    INNER JOIN T_ORD ORD
    ON ORD.CUS_ID = CUS.CUS_ID
WHERE ORD.ORD_DT BETWEEN '20170101' AND '20170228';
-- 답
	SELECT  T1.CUS_ID ,T1.CUS_GD ,T2.ORD_SEQ ,T2.CUS_ID ,T2.ORD_DT
	FROM    M_CUS T1
			,T_ORD T2
	WHERE   T1.CUS_ID = T2.CUS_ID
	AND     T1.CUS_GD = 'A'
	AND     T2.ORD_DT >= TO_DATE('20170101','YYYYMMDD')
	AND     T2.ORD_DT < TO_DATE('20170201','YYYYMMDD');



-- ************************************************
-- PART I - 3.1.3 SQL1
-- ************************************************

	-- 특정 고객의 17년 3월의 아이템평가(T_ITM_EVL)기록과 3월 주문(T_ORD)에 대해,
	-- 고객ID, 고객명별 아이템평가 건수, 주문건수를 출력

	SELECT  T1.CUS_ID ,T1.CUS_NM
			,COUNT(DISTINCT T2.ITM_ID||'-'||TO_CHAR(T2.EVL_LST_NO)) EVAL_CNT
			,COUNT(DISTINCT T3.ORD_SEQ) ORD_CNT
	FROM    M_CUS T1
			,T_ITM_EVL T2
			,T_ORD T3
	WHERE   T1.CUS_ID = T2.CUS_ID
	AND     T1.CUS_ID = T3.CUS_ID
	AND     T1.CUS_ID = 'CUS_0023'
	AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
	AND     T3.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T3.ORD_DT < TO_DATE('20170401','YYYYMMDD')
	GROUP BY T1.CUS_ID ,T1.CUS_NM;



-- ************************************************
-- PART I - 3.1.3 SQL2
-- ************************************************

	-- M:1:M의 관계를 UNION ALL로 해결
	SELECT  TT.CUS_ID ,TT.CUS_NM
			,SUM(TT.EVAL_CNT) AS EVAL_CNT
			,SUM(TT.ORD_CNT) AS ORD_CNT
FROM 	( SELECT T1.CUS_ID
            , T1.CUS_NM
            , COUNT(*) EVAL_CNT
            , NULL ORD_CNT
	    FROM    M_CUS T1
        INNER JOIN T_ITM_EVL T2
            ON T1.CUS_ID = T2.CUS_ID
	WHERE   T1.CUS_ID = 'CUS_0023'
	AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
    GROUP BY T1.CUS_ID, T1.CUS_NM
    UNION ALL
    SELECT T1.CUS_ID
            , T1.CUS_NM
            , NULL EVAL_CNT
            , COUNT(*) ORD_CNT
        FROM M_CUS T1
        INNER JOIN T_ORD T3
            ON T1.CUS_ID = T3.CUS_ID
	WHERE   T1.CUS_ID = 'CUS_0023'
	AND     T3.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T3.ORD_DT < TO_DATE('20170401','YYYYMMDD')
    GROUP BY T1.CUS_ID, T1.CUS_NM
)TT
GROUP BY TT.CUS_ID ,TT.CUS_NM;



    SELECT T1.CUS_ID
            , T1.CUS_NM
            , COUNT(*) EVAL_CNT
            , NULL ORD_CNT
	    FROM    M_CUS T1
        INNER JOIN T_ITM_EVL T2
            ON T1.CUS_ID = T2.CUS_ID
	WHERE   T1.CUS_ID = 'CUS_0023'
	AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
    GROUP BY T1.CUS_ID, T1.CUS_NM;


-- 답지
	SELECT  T1.CUS_ID ,MAX(T1.CUS_NM) CUS_NM ,SUM(T1.EVL_CNT) EVL_CNT ,SUM(T1.ORD_CNT) ORD_CNT
	FROM    (
			SELECT  T1.CUS_ID ,MAX(T1.CUS_NM) CUS_NM ,COUNT(*) EVL_CNT ,NULL ORD_CNT
			FROM    M_CUS T1
					,T_ITM_EVL T2
			WHERE   T1.CUS_ID = T2.CUS_ID
			AND     T2.CUS_ID = 'CUS_0023'
			AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T1.CUS_ID ,T1.CUS_NM
			UNION ALL
			SELECT  T1.CUS_ID ,MAX(T1.CUS_NM) CUS_NM ,NULL EVL_CNT ,COUNT(*) ORD_CNT
			FROM    M_CUS T1
					,T_ORD T3
			WHERE   T1.CUS_ID = T3.CUS_ID
			AND     T3.CUS_ID = 'CUS_0023'
			AND     T3.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T3.ORD_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T1.CUS_ID ,T1.CUS_NM
			) T1
	GROUP BY T1.CUS_ID;



-- ************************************************
-- PART I - 3.1.3 SQL3
-- ************************************************

	-- M:1:M의 관계를 UNION ALL로 해결 ? 성능을 고려, M_CUS를 인라인-뷰 바깥에서 한 번만 사용
SELECT CUS.CUS_ID
    , CUS.CUS_NM
    , SUM(TT.EVL_CNT) EVL_CNT
    , SUM(TT.ORD_CNT) ORD_CNT
FROM M_CUS CUS
    INNER JOIN ( SELECT EVL.CUS_ID CUS_ID
                    , COUNT(*) EVL_CNT
                    , NULL ORD_CNT
                 FROM T_ITM_EVL EVL
                 WHERE EVL.CUS_ID = 'CUS_0023'
                 AND EVL.EVL_DT BETWEEN '20170301' AND '20170331'
                 GROUP BY EVL.CUS_ID
                 UNION ALL
                 SELECT ORD.CUS_ID CUS_ID
                    , NULL EVL_CNT
                    , COUNT(*) ORD_CNT
                 FROM T_ORD ORD
                WHERE ORD.CUS_ID = 'CUS_0023'
                 AND ORD.ORD_DT BETWEEN '20170301' AND '20170331'
                GROUP BY ORD.CUS_ID
                ) TT
    ON TT.CUS_ID = CUS.CUS_ID
GROUP BY CUS.CUS_ID, CUS.CUS_NM
;


-- 답지
	SELECT  T1.CUS_ID ,MAX(T1.CUS_NM) CUS_NM ,SUM(T4.EVL_CNT) EVL_CNT ,SUM(T4.ORD_CNT) ORD_CNT
	FROM    M_CUS T1
			,(
			SELECT  T2.CUS_ID ,COUNT(*) EVL_CNT ,NULL ORD_CNT
			FROM    T_ITM_EVL T2
			WHERE   T2.CUS_ID = 'CUS_0023'
			AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T2.CUS_ID
			UNION ALL
			SELECT  T3.CUS_ID ,NULL EVL_CNT ,COUNT(*) ORD_CNT
			FROM    T_ORD T3
			WHERE   T3.CUS_ID = 'CUS_0023'
			AND     T3.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T3.ORD_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T3.CUS_ID
			) T4
	WHERE   T1.CUS_ID = T4.CUS_ID
	GROUP BY T1.CUS_ID;



-- ************************************************
-- PART I - 3.1.3 SQL4
-- ************************************************

	-- M:1:M의 관계에서 M 집합들을  1집합으로 만들어서 처리
SELECT CUS.CUS_ID
    , CUS.CUS_NM
    , EVL.EVL_CNT
    , ORD.ORD_CNT
FROM M_CUS CUS
    INNER JOIN
        (
            SELECT EVL.CUS_ID
                , COUNT(*) EVL_CNT
            FROM T_ITM_EVL EVL
            WHERE EVL.CUS_ID = 'CUS_0023'
            AND EVL.EVL_DT BETWEEN '20170301' AND '20170331'
            GROUP BY EVL.CUS_ID
        ) EVL
    ON EVL.CUS_ID = CUS.CUS_ID
    INNER JOIN
        (
            SELECT ORD.CUS_ID
                , COUNT(*) ORD_CNT
            FROM T_ORD ORD
            WHERE ORD.CUS_ID = 'CUS_0023'
            AND ORD.ORD_DT BETWEEN '20170301' AND '20170331'
            GROUP BY ORD.CUS_ID
        ) ORD
    ON ORD.CUS_ID = CUS.CUS_ID;



-- 답지
	SELECT  T1.CUS_ID
			,T1.CUS_NM
			,T2.EVL_CNT
			,T3.ORD_CNT
	FROM    M_CUS T1
			,(
			SELECT  T2.CUS_ID
					,COUNT(*) EVL_CNT
			FROM    T_ITM_EVL T2
			WHERE   T2.CUS_ID = 'CUS_0023'
			AND     T2.EVL_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T2.EVL_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T2.CUS_ID
			) T2
			,(
			SELECT  T3.CUS_ID
					,COUNT(*) ORD_CNT
			FROM    T_ORD T3
			WHERE   T3.CUS_ID = 'CUS_0023'
			AND     T3.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
			AND     T3.ORD_DT < TO_DATE('20170401','YYYYMMDD')
			GROUP BY T3.CUS_ID
			) T3
	WHERE   T1.CUS_ID = T2.CUS_ID
	AND     T1.CUS_ID = T3.CUS_ID
	AND     T1.CUS_ID = 'CUS_0023';



-- ************************************************
-- PART I - 3.1.4 SQL1
-- ************************************************

	-- CASE를 이용해 가격유형(ORD_AMT_TP)별로 주문 건수를 카운트

	SELECT  T1.ORD_ST
			,CASE WHEN T1.ORD_AMT >= 5000 THEN 'High Order'
				  WHEN T1.ORD_AMT >= 3000 THEN 'Middle Order'
				  ELSE 'Low Order'
				  END ORD_AMT_TP
			,COUNT(*) ORD_CNT
	FROM    T_ORD T1
	GROUP BY T1.ORD_ST
			,CASE WHEN T1.ORD_AMT >= 5000 THEN 'High Order'
				  WHEN T1.ORD_AMT >= 3000 THEN 'Middle Order'
				  ELSE 'Low Order'
				  END
	ORDER BY 1, 2;



-- ************************************************
-- PART I - 3.1.4 SQL2
-- ************************************************

	--주문금액유형 테이블 생성
	CREATE TABLE M_ORD_AMT_TP
	(
		ORD_AMT_TP VARCHAR2(40) NOT NULL,
		FR_AMT NUMBER(18,3) NULL,
		TO_AMT NUMBER(18,3) NULL
	);

	CREATE UNIQUE INDEX PK_M_ORD_AMT_TP ON M_ORD_AMT_TP(ORD_AMT_TP);

	ALTER TABLE M_ORD_AMT_TP
		ADD CONSTRAINT PK_M_ORD_AMT_TP PRIMARY KEY(ORD_AMT_TP) USING INDEX;

	-- 테스트 데이터 생성.
	INSERT INTO M_ORD_AMT_TP(ORD_AMT_TP ,FR_AMT ,TO_AMT)
	SELECT 'Low Order' ,0 ,3000 FROM DUAL UNION ALL
	SELECT 'Middle Order' ,3000 ,5000 FROM DUAL UNION ALL
	SELECT 'High Order' ,5000 ,999999999999 FROM DUAL;
	COMMIT;



-- ************************************************
-- PART I - 3.1.4 SQL3
-- ************************************************

	-- RANGE-JOIN을 이용해 가격유형(ORD_AMT_TP)별로 주문 건수를 카운트
SELECT * FROM M_ORD_AMT_TP;

SELECT ORD.ORD_ST
    , AMTP.ORD_AMT_TP
    , COUNT(*) ORD_CNT
FROM T_ORD ORD
    INNER JOIN M_ORD_AMT_TP AMTP
    ON NVL(ORD.ORD_AMT, 0) >= AMTP.FR_AMT
    AND NVL(ORD.ORD_AMT, 0) < AMTP.TO_AMT
GROUP BY ORD.ORD_ST, AMTP.ORD_AMT_TP
ORDER BY ORD.ORD_ST, AMTP.ORD_AMT_TP
;


-- 답
	SELECT  T1.ORD_ST ,T2.ORD_AMT_TP ,COUNT(*) ORD_CNT
	FROM    T_ORD T1
			,M_ORD_AMT_TP T2
	WHERE   NVL(T1.ORD_AMT,0) >= T2.FR_AMT
	AND     NVL(T1.ORD_AMT,0) < T2.TO_AMT
	GROUP BY T1.ORD_ST ,T2.ORD_AMT_TP
	ORDER BY 1, 2;



