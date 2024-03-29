


-- ************************************************
-- PART I - 4.1.2 SQL1
-- ************************************************

	-- 17년8월 총 주문금액 구하기 ? SELECT절 단독 서브쿼리
SELECT ORD.ORD_DT ORD_YMD
    , SUM(ORD.ORD_AMT) ORD_AMT
    , ( SELECT SUM(ORD.ORD_AMT)
        FROM T_ORD ORD
        WHERE ORD.ORD_DT >= '20170801'
        AND ORD.ORD_DT < '20170901'
    ) TOTAL_ORD_AMT
FROM T_ORD ORD
WHERE 1=1
    -- AND ORD.ORD_ST = 'COMP'
    AND ORD.ORD_DT >= '20170801'
    AND ORD.ORD_DT < '20170901'
GROUP BY ORD.ORD_DT
ORDER BY ORD.ORD_DT;


-- 답
SELECT  TO_CHAR(T1.ORD_DT, 'YYYYMMDD') ORD_YMD
			,SUM(T1.ORD_AMT) ORD_AMT
			,(
	SELECT  SUM(A.ORD_AMT)
			  FROM    T_ORD A
			  WHERE   A.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
			  AND     A.ORD_DT < TO_DATE('20170901','YYYYMMDD')
			) TOTAL_ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMMDD')
ORDER BY ORD_YMD;




-- ************************************************
-- PART I - 4.1.2 SQL2
-- ************************************************

	-- 17년8월 총 주문금액, 주문일자의 주문금액비율 구하기 ? SELECT절 단독 서브쿼리
	-- 주문금액 비율 = 주문일자별 주문금액(ORD_AMT) / 17년8월 주문 총 금액(TOTAL_ORD_AMT) * 100.00
SELECT BASE.ORD_YMD
    , BASE.ORD_AMT
    , BASE.TOTAL_ORD_AMT
    , ROUND(BASE.ORD_AMT / BASE.TOTAL_ORD_AMT * 100.00, 2) ORD_AMT_RT
FROM
(SELECT ORD.ORD_DT                      ORD_YMD
      , SUM(ORD.ORD_AMT)                ORD_AMT
      , (SELECT SUM(ORD.ORD_AMT)
         FROM T_ORD ORD
         WHERE ORD.ORD_DT >= '20170801'
           AND ORD.ORD_DT < '20170901') TOTAL_ORD_AMT
 FROM T_ORD ORD
 WHERE 1 = 1
   -- AND ORD.ORD_ST = 'COMP'
   AND ORD.ORD_DT >= '20170801'
   AND ORD.ORD_DT < '20170901'
 GROUP BY ORD.ORD_DT) BASE
ORDER BY BASE.ORD_YMD;


-- 답
	SELECT  TO_CHAR(T1.ORD_DT, 'YYYYMMDD') ORD_YMD
			,SUM(T1.ORD_AMT) ORD_AMT
			,(
			  SELECT  SUM(A.ORD_AMT)
			  FROM    T_ORD A
			  WHERE   A.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
			  AND     A.ORD_DT < TO_DATE('20170901','YYYYMMDD')
			) TOTAL_ORD_AMT
			,ROUND(
			  SUM(T1.ORD_AMT) / (
				  SELECT  SUM(A.ORD_AMT)
				  FROM    T_ORD A
				  WHERE   A.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
				  AND     A.ORD_DT < TO_DATE('20170901','YYYYMMDD')
				)  * 100,2) ORD_AMT_RT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMMDD')
	ORDER BY ORD_YMD;



-- ************************************************
-- PART I - 4.1.2 SQL3
-- ************************************************

	-- 인라인-뷰를 사용해 반복 서브쿼리를 제거하는 방법
	SELECT  T1.ORD_YMD
			,T1.ORD_AMT
			,T1.TOTAL_ORD_AMT
			,ROUND(T1.ORD_AMT / T1.TOTAL_ORD_AMT * 100,2) ORD_AMT_RT
	FROM    (
			SELECT  TO_CHAR(T1.ORD_DT, 'YYYYMMDD') ORD_YMD
					,SUM(T1.ORD_AMT) ORD_AMT
					,(SELECT  SUM(A.ORD_AMT)
					  FROM    T_ORD A
					  WHERE   A.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
					  AND     A.ORD_DT < TO_DATE('20170901','YYYYMMDD')
					) TOTAL_ORD_AMT
			FROM    T_ORD T1
			WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
			AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
			GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMMDD')
			) T1;


-- ************************************************
-- PART I - 4.1.2 SQL4
-- ************************************************

	-- 카테시안-조인을 사용해 반복 서브쿼리를 제거하는 방법
SELECT ORD.ORD_DT                      ORD_YMD
      , SUM(ORD.ORD_AMT)                ORD_AMT
      , MAX(TOTAL.TOTAL_ORD_AMT)             TOTAL_ORD_AMT
      , ROUND(SUM(ORD.ORD_AMT) / MAX(TOTAL.TOTAL_ORD_AMT) * 100.00, 2) ORD_AMT_RT
 FROM T_ORD ORD
    CROSS JOIN (SELECT SUM(ORD.ORD_AMT) TOTAL_ORD_AMT
                FROM T_ORD ORD
                 WHERE ORD.ORD_DT >= '20170801'
                   AND ORD.ORD_DT < '20170901') TOTAL
 WHERE 1 = 1
   -- AND ORD.ORD_ST = 'COMP'
   AND ORD.ORD_DT >= '20170801'
   AND ORD.ORD_DT < '20170901'
GROUP BY ORD.ORD_DT
ORDER BY ORD.ORD_DT;


-- 답
	SELECT  TO_CHAR(T1.ORD_DT, 'YYYYMMDD') ORD_YMD
			,SUM(T1.ORD_AMT) ORD_AMT
			,MAX(T2.TOTAL_ORD_AMT) TOTAL_ORD_AMT
			,ROUND(SUM(T1.ORD_AMT) / MAX(T2.TOTAL_ORD_AMT) * 100, 2) ORD_AMT_RT
	FROM    T_ORD T1
			,(    SELECT  SUM(A.ORD_AMT) TOTAL_ORD_AMT
				  FROM    T_ORD A
				  WHERE   A.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
				  AND     A.ORD_DT < TO_DATE('20170901','YYYYMMDD')
	) T2
	WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMMDD');


-- ************************************************
-- PART I - 4.1.3 SQL1
-- ************************************************

	-- 코드값을 가져오는 SELECT 절 상관 서브쿼리
SELECT ITM.ITM_TP
    , CD.BAS_CD_NM
    , ITM.ITM_ID
    , ITM.ITM_NM
FROM M_ITM ITM
    INNER JOIN C_BAS_CD CD
        ON CD.BAS_CD_DV = 'ITM_TP'
        AND CD.LNG_CD = 'KO'
        AND CD.BAS_CD = ITM.ITM_TP;


-- 답
	SELECT  T1.ITM_TP
			,(SELECT  A.BAS_CD_NM
			  FROM    C_BAS_CD A
			  WHERE   A.BAS_CD_DV = 'ITM_TP' AND A.BAS_CD = T1.ITM_TP AND A.LNG_CD = 'KO') ITM_TP_NM
			,T1.ITM_ID ,T1.ITM_NM
	FROM    M_ITM T1;





-- ************************************************
-- PART I - 4.1.3 SQL2
-- ************************************************

	-- 고객정보를 가져오는 SELECT 절 상관 서브쿼리
-- 조인 사용
SELECT CUS.CUS_ID
    , TO_CHAR(ORD.ORD_DT, 'YYYYMMDD') ORD_YMD
    , CUS.CUS_NM
    , CUS.CUS_GD
    , ORD.ORD_AMT
FROM M_CUS CUS
    INNER JOIN T_ORD ORD
        ON ORD.CUS_ID = CUS.CUS_ID
	WHERE   ORD.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     ORD.ORD_DT < TO_DATE('20170901','YYYYMMDD');


-- 서브쿼리로
SELECT ORD.CUS_ID
    , TO_CHAR(ORD.ORD_DT, 'YYYYMMDD') ORD_YMD
    , (SELECT CUS.CUS_NM FROM M_CUS CUS WHERE CUS.CUS_ID = ORD.CUS_ID) CUS_NM
    , (SELECT CUS.CUS_GD FROM M_CUS CUS WHERE CUS.CUS_ID = ORD.CUS_ID) CUS_GD
    , ORD.ORD_AMT
FROM T_ORD ORD
	WHERE   ORD.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     ORD.ORD_DT < TO_DATE('20170901','YYYYMMDD');


;

-- 답
	SELECT  T1.CUS_ID
			,TO_CHAR(T1.ORD_DT,'YYYYMMDD') ORD_YMD
			,(SELECT A.CUS_NM FROM M_CUS A WHERE A.CUS_ID = T1.CUS_ID) CUS_NM
			,(SELECT A.CUS_GD FROM M_CUS A WHERE A.CUS_ID = T1.CUS_ID) CUS_GD
			,T1.ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD');



-- ************************************************
-- PART I - 4.1.3 SQL3
-- ************************************************

	-- 인라인-뷰 안에서 SELECT 절 서브쿼리를 사용한 예

-- 조인
SELECT CUS_ORD.CUS_ID
    , CUS_ORD.ORD_YM
    , MAX(CUS_ORD.CUS_NM)
    , MAX(CUS_ORD.CUS_GD)
    , CUS_ORD.ORD_ST_NM
    , CUS_ORD.PAY_TP_NM
    , SUM(CUS_ORD.ORD_AMT) ORD_AMT
FROM (SELECT CUS.CUS_ID
           , TO_CHAR(ORD.ORD_DT, 'YYYYMM')      ORD_YM
           , CUS.CUS_NM
           , CUS.CUS_GD
           , (SELECT CD.BAS_CD_NM
              FROM C_BAS_CD CD
              WHERE CD.BAS_CD_DV = 'ORD_ST'
                AND CD.LNG_CD = 'KO'
                AND CD.BAS_CD = ORD.ORD_ST)     ORD_ST_NM
           , (SELECT ORD_CD.BAS_CD_NM
              FROM C_BAS_CD ORD_CD
              WHERE ORD_CD.BAS_CD_DV = 'PAY_TP'
                AND ORD_CD.LNG_CD = 'KO'
                AND ORD_CD.BAS_CD = ORD.PAY_TP) PAY_TP_NM
           , ORD.ORD_AMT
      FROM M_CUS CUS
               INNER JOIN T_ORD ORD
                          ON ORD.CUS_ID = CUS.CUS_ID
      WHERE ORD.ORD_DT >= TO_DATE('20170801', 'YYYYMMDD')
        AND ORD.ORD_DT < TO_DATE('20170901', 'YYYYMMDD'))CUS_ORD
GROUP BY CUS_ORD.CUS_ID, CUS_ORD.ORD_YM, CUS_ORD.ORD_ST_NM, CUS_ORD.PAY_TP_NM
;

SELECT
    CUS_ID
    , ORD_YM
    , MAX(CUS_NM)
    , MAX(CUS_GD)
    , ORD_ST_NM
    , PAY_TP_NM
    , SUM(ORD_AMT)
FROM (
    SELECT ORD.CUS_ID
        , TO_CHAR(ORD.ORD_DT, 'YYYYMM') ORD_YM
    , (SELECT CUS.CUS_NM FROM M_CUS CUS WHERE CUS.CUS_ID = ORD.CUS_ID) CUS_NM
    , (SELECT CUS.CUS_GD FROM M_CUS CUS WHERE CUS.CUS_ID = ORD.CUS_ID) CUS_GD
    , (SELECT CD.BAS_CD_NM
       FROM C_BAS_CD CD
       WHERE CD.BAS_CD_DV = 'ORD_ST' AND CD.LNG_CD = 'KO' AND CD.BAS_CD = ORD.ORD_ST) ORD_ST_NM
    , (SELECT CD.BAS_CD_NM
       FROM C_BAS_CD CD
       WHERE CD.BAS_CD_DV = 'PAY_TP' AND CD.LNG_CD = 'KO' AND CD.BAS_CD = ORD.PAY_TP) PAY_TP_NM
    , ORD_AMT FROM T_ORD ORD
        WHERE   ORD.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
        AND     ORD.ORD_DT < TO_DATE('20170901','YYYYMMDD')
    )
GROUP BY CUS_ID, ORD_YM, ORD_ST_NM, PAY_TP_NM
ORDER BY CUS_ID, ORD_YM, ORD_ST_NM, PAY_TP_NM;

;


--답
	SELECT  T1.CUS_ID ,SUBSTR(T1.ORD_YMD,1,6) ORD_YM
			,MAX(T1.CUS_NM) ,MAX(T1.CUS_GD)
			,T1.ORD_ST_NM ,T1.PAY_TP_NM
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    (
			SELECT  T1.CUS_ID ,TO_CHAR(T1.ORD_DT,'YYYYMMDD') ORD_YMD ,T2.CUS_NM ,T2.CUS_GD
					,(SELECT  A.BAS_CD_NM
					  FROM    C_BAS_CD A
					  WHERE A.BAS_CD_DV = 'ORD_ST' AND A.BAS_CD = T1.ORD_ST AND A.LNG_CD = 'KO') ORD_ST_NM
					,(SELECT  A.BAS_CD_NM
					  FROM    C_BAS_CD A
					  WHERE A.BAS_CD_DV = 'PAY_TP' AND A.BAS_CD = T1.PAY_TP AND A.LNG_CD = 'KO') PAY_TP_NM
					,T1.ORD_AMT
			FROM    T_ORD T1
					,M_CUS T2
			WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
			AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
			AND     T1.CUS_ID = T2.CUS_ID
			) T1
	GROUP BY T1.CUS_ID ,SUBSTR(T1.ORD_YMD,1,6) ,T1.ORD_ST_NM ,T1.PAY_TP_NM
	ORDER BY T1.CUS_ID ,SUBSTR(T1.ORD_YMD,1,6) ,T1.ORD_ST_NM ,T1.PAY_TP_NM;




-- ************************************************
-- PART I - 4.1.3 SQL4
-- ************************************************

	-- 서브쿼리 안에서 조인을 사용한 예
SELECT
    ORD.ORD_DT
    , ORDD.ORD_QTY
    , ORDD.ITM_ID
    , ITM.ITM_NM
    , (SELECT SUM(EVL.EVL_PT) / COUNT(EVL.EVL_LST_NO)
        FROM T_ITM_EVL EVL
        WHERE EVL.ITM_ID = ITM.ITM_ID
        AND EVL.EVL_DT < ORD.ORD_DT
      ) AVG_EVL_PT
FROM T_ORD ORD
    INNER JOIN T_ORD_DET ORDD
    ON ORDD.ORD_SEQ = ORD.ORD_SEQ
    INNER JOIN M_ITM ITM
        ON ITM.ITM_ID = ORDD.ITM_ID
WHERE ORD.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
  AND ORD.ORD_DT < TO_DATE('20170901','YYYYMMDD')
ORDER BY ORD.ORD_DT, ORDD.ITM_ID;


SELECT * FROM M_ITM;
SELECT * FROM T_ORD;
SELECT * FROM T_ITM_EVL;
SELECT * FROM T_ORD_DET;


-- 답
	SELECT  T1.ORD_DT ,T2.ORD_QTY ,T2.ITM_ID ,T3.ITM_NM
	,(    SELECT  SUM(B.EVL_PT) / COUNT(*)
				  FROM    M_ITM A
						  ,T_ITM_EVL B
				  WHERE   A.ITM_TP = T3.ITM_TP
				  AND     B.ITM_ID = A.ITM_ID
				  AND     B.EVL_DT < T1.ORD_DT
			) ITM_TP_EVL_PT_AVG
	FROM    T_ORD T1
			,T_ORD_DET T2
			,M_ITM T3
	WHERE   T1.ORD_DT >= TO_DATE('20170801','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170901','YYYYMMDD')
	AND     T3.ITM_ID = T2.ITM_ID
	AND     T1.ORD_SEQ = T2.ORD_SEQ
	ORDER BY T1.ORD_DT ,T2.ITM_ID;




-- ************************************************
-- PART I - 4.1.4 SQL1
-- ************************************************

	-- 실행이 불가능한 SELECT 절의 서브쿼리
	--SELECT 절의 서브쿼리에서 두 컬럼을 지정.
	SELECT  T1.ORD_DT ,T1.CUS_ID
			,(SELECT A.CUS_NM ,A.CUS_GD FROM M_CUS A WHERE A.CUS_ID = T1.CUS_ID) CUS_NM_GD
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170401','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD');

	--SELECT 절의 서브쿼리에서 두 건 이상의 데이터가 나오는 경우.
	SELECT  T1.ORD_DT ,T1.CUS_ID
			,(SELECT A.ITM_ID FROM T_ORD_DET A WHERE A.ORD_SEQ = T1.ORD_SEQ) ITM_LIST
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170401','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD');


-- ************************************************
-- PART I - 4.1.4 SQL2
-- ************************************************

	-- 고객 이름과 등급을 합쳐서 하나의 컬럼으로 처리
	-- 단가(UNT_PRC)와 주문수량(ORD_QTY)를 곱해서 주문금액으로 처리.
SELECT
    ORD.ORD_DT
    , ORD.CUS_ID
    , (SELECT (CUS.CUS_NM||'('||CUS_GD||')') FROM M_CUS CUS WHERE CUS.CUS_ID = ORD.CUS_ID) CUS_NM_GD
    , (SELECT SUM(ORDD.UNT_PRC * ORDD.ORD_QTY) FROM T_ORD_DET ORDD WHERE ORDD.ORD_SEQ = ORD.ORD_SEQ) ORD_AMT
    , ORD.ORD_AMT
FROM T_ORD ORD
WHERE   ORD.ORD_DT >= TO_DATE('20170401','YYYYMMDD')
AND     ORD.ORD_DT < TO_DATE('20170501','YYYYMMDD');




-- 답
	SELECT  T1.ORD_DT ,T1.CUS_ID
			,(SELECT A.CUS_NM||'('||CUS_GD||')' FROM M_CUS A WHERE A.CUS_ID = T1.CUS_ID) CUS_NM_GD
			,(SELECT SUM(A.UNT_PRC * A.ORD_QTY) FROM T_ORD_DET A WHERE A.ORD_SEQ = T1.ORD_SEQ) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170401','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD');


-- ************************************************
-- PART I - 4.1.4 SQL3
-- ************************************************


	-- 고객별 마지막 ORD_SEQ의 주문금액
SELECT
    RANK_ORD.CUS_ID
    , CUS.CUS_NM
    , RANK_ORD.ORD_AMT
FROM (
    SELECT ROW_NUMBER() over (PARTITION BY ORD.CUS_ID ORDER BY ORD.ORD_SEQ DESC) AS RANK
        , ORD.CUS_ID
        , ORD.ORD_AMT
    FROM T_ORD ORD
     ) RANK_ORD
    INNER JOIN M_CUS CUS
        ON CUS.CUS_ID = RANK_ORD.CUS_ID
WHERE RANK_ORD.RANK = 1
ORDER BY RANK_ORD.CUS_ID;




-- 답
	SELECT  T1.CUS_ID
			,T1.CUS_NM
			,(SELECT  TO_NUMBER(
						SUBSTR(
							MAX(
							  LPAD(TO_CHAR(A.ORD_SEQ),8,'0')
							  ||TO_CHAR(A.ORD_AMT)
							  ),9))
						FROM T_ORD A WHERE A.CUS_ID = T1.CUS_ID) LAST_ORD_AMT
	FROM    M_CUS T1
	ORDER BY T1.CUS_ID;


-- ************************************************
-- PART I - 4.1.4 SQL4
-- ************************************************

	-- 고객별 마지막 ORD_SEQ의 주문금액 ? 중첩된 서브쿼리
SELECT CUS.CUS_ID
    , CUS.CUS_NM
    , (
        SELECT ORD.ORD_AMT
        FROM T_ORD ORD
        WHERE ORD.CUS_ID = CUS.CUS_ID
        AND ORD.ORD_SEQ = (
                SELECT MAX(ORD_SEQ)
                FROM T_ORD SUB_ORD
                WHERE SUB_ORD.CUS_ID = CUS.CUS_ID
                GROUP BY SUB_ORD.CUS_ID
            )
 ) ORD_AMT
FROM M_CUS CUS
ORDER BY CUS.CUS_ID;


;
	SELECT  T1.CUS_ID
			,T1.CUS_NM
			,(
				SELECT  B.ORD_AMT
				FROM    T_ORD B
				WHERE   B.ORD_SEQ =
						  (SELECT MAX(A.ORD_SEQ) FROM T_ORD A WHERE A.CUS_ID = T1.CUS_ID)
				) LAST_ORD_AMT
	FROM    M_CUS T1
	ORDER BY T1.CUS_ID;



-- ************************************************
-- PART I - 4.1.4 SQL5
-- ************************************************

	-- 잠재적인 오류가 존재하는 서브쿼리 ? 정상 실행
	SELECT  T1.ORD_DT
			,T1.CUS_ID
			,(SELECT A.ORD_QTY FROM T_ORD_DET A WHERE A.ORD_SEQ = T1.ORD_SEQ) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_SEQ = 2297;


-- ************************************************
-- PART I - 4.1.4 SQL6
-- ************************************************

	-- 잠재적인 오류가 존재하는 서브쿼리 ? 오류 발생
	--1. 오류가 발생하는 서브쿼리(ORD_SEQ = 2291)
	SELECT  T1.ORD_DT
			,T1.CUS_ID
			,(SELECT A.ORD_QTY FROM T_ORD_DET A WHERE A.ORD_SEQ = T1.ORD_SEQ) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_SEQ = 2291;

	--2. T_ORD_DET에 ORD_SEQ가 2291인 데이터는 두 건이 존재한다.
	SELECT  T1.*
	FROM    T_ORD_DET T1
	WHERE   T1.ORD_SEQ = 2291;


-- ************************************************
-- PART I - 4.1.5 SQL1
-- ************************************************

	-- 마지막 주문 한 건을 조회하는 SQL, ORD_SEQ가 가장 큰 데이터가 마지막 주문이다.
	SELECT  *
	FROM    T_ORD T1
	WHERE   T1.ORD_SEQ = (SELECT MAX(A.ORD_SEQ) FROM T_ORD A);




-- ************************************************
-- PART I - 4.1.5 SQL2
-- ************************************************

	-- 마지막 주문 한 건을 조회하는 SQL, ORDER BY와 ROWNUM을 사용
	SELECT  *
	FROM    (
			SELECT  *
			FROM    T_ORD T1
			ORDER BY T1.ORD_SEQ DESC
			) A
	WHERE  ROWNUM <= 1;


-- ************************************************
-- PART I - 4.1.5 SQL3
-- ************************************************

	-- 마지막 주문 일자의 데이터를 가져오는 SQL
	SELECT  *
	FROM    T_ORD T1
	WHERE   T1.ORD_DT = (SELECT MAX(A.ORD_DT) FROM T_ORD A);




-- ************************************************
-- PART I - 4.1.5 SQL4
-- ************************************************

	-- 3월 주문 건수가 4건 이상인 고객의 3월달 주문 리스트
SELECT *
FROM T_ORD ORD
WHERE 1=1
    AND ORD.ORD_DT >= TO_DATE ('20170301', 'YYYYMMDD')
    AND ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD')
    AND ORD.CUS_ID IN (SELECT T1.CUS_ID
                     FROM T_ORD T1
                     WHERE T1.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
                       AND T1.ORD_DT < TO_DATE('20170401', 'YYYYMMDD')
                     GROUP BY T1.CUS_ID
                     HAVING COUNT(*) >= 4);



	SELECT  *
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170401','YYYYMMDD')
	AND     T1.CUS_ID IN (
				SELECT  A.CUS_ID
				FROM    T_ORD A
				WHERE   A.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
				AND     A.ORD_DT < TO_DATE('20170401','YYYYMMDD')
				GROUP BY A.CUS_ID
				HAVING COUNT(*)>=4
				);




-- ************************************************
-- PART I - 4.1.5 SQL5
-- ************************************************

	-- 3월 주문 건수가 4건 이상인 고객의 3월달 주문 리스트 ? 조인으로 처리
SELECT *
FROM T_ORD ORD
    INNER JOIN (
        SELECT SUB_ORD.CUS_ID
        FROM T_ORD SUB_ORD
        WHERE SUB_ORD.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
            AND SUB_ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD')
        GROUP BY SUB_ORD.CUS_ID
        HAVING COUNT(*) >= 4
    ) SUB_ORD
    ON SUB_ORD.CUS_ID = ORD.CUS_ID
WHERE ORD.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
    AND ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD');


	SELECT  T1.*
	FROM    T_ORD T1
			,(
				SELECT  A.CUS_ID
				FROM    T_ORD A
				WHERE   A.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
				AND     A.ORD_DT < TO_DATE('20170401','YYYYMMDD')
				GROUP BY A.CUS_ID
				HAVING COUNT(*)>=4
			) T2
	WHERE   T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170401','YYYYMMDD')
	AND     T1.CUS_ID = T2.CUS_ID;




-- ************************************************
-- PART I - 4.1.6 SQL1
-- ************************************************

	-- 3월에 주문이 존재하는 고객들을 조회
SELECT *
FROM M_CUS CUS
WHERE EXISTS(
    SELECT *
    FROM T_ORD ORD
    WHERE ORD.CUS_ID = CUS.CUS_ID
    AND ORD.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
    AND ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD')
);


-- 답
	SELECT  *
	FROM    M_CUS T1
	WHERE   EXISTS(
			  SELECT  *
			  FROM    T_ORD A
			  WHERE   A.CUS_ID = T1.CUS_ID
			  AND     A.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
			  AND     A.ORD_DT < TO_DATE('20170401','YYYYMMDD')
			  );




-- ************************************************
-- PART I - 4.1.6 SQL2
-- ************************************************

	-- 3월에 ELEC 아이템유형의 주문이 존재하는 고객들을 조회
SELECT *
FROM M_CUS CUS
WHERE EXISTS(
    SELECT *
    FROM T_ORD ORD
        INNER JOIN T_ORD_DET ORDD
            ON ORDD.ORD_SEQ = ORD.ORD_SEQ
        INNER JOIN M_ITM ITM
            ON ITM.ITM_ID = ORDD.ITM_ID
            AND ITM.ITM_TP = 'ELEC'
    WHERE ORD.CUS_ID = CUS.CUS_ID
    AND ORD.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
    AND ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD')
);

SELECT * FROM M_ITM;




	SELECT  *
	FROM    M_CUS T1
	WHERE   EXISTS(
			  SELECT  *
			  FROM    T_ORD A
					  ,T_ORD_DET B
					  ,M_ITM C
			  WHERE   A.CUS_ID = T1.CUS_ID
			  AND     A.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
			  AND     A.ORD_DT < TO_DATE('20170401','YYYYMMDD')
			  AND     A.ORD_SEQ = B.ORD_SEQ
			  AND     B.ITM_ID = C.ITM_ID
			  AND     C.ITM_TP = 'ELEC'
			  );




-- ************************************************
-- PART I - 4.1.6 SQL3
-- ************************************************

	-- 전체 고객을 조회, 3월에 주문이 존재하는지 여부를 같이 보여줌
SELECT CUS.CUS_ID, CUS.CUS_NM
    , CASE WHEN EXISTS (SELECT *
                        FROM T_ORD ORD
                        WHERE ORD.CUS_ID = CUS.CUS_ID
                          AND ORD.ORD_DT >= TO_DATE('20170301', 'YYYYMMDD')
                          AND ORD.ORD_DT < TO_DATE('20170401', 'YYYYMMDD'))
        THEN 'Y'
        ELSE 'N' END AS ORD_YN_03
FROM M_CUS CUS;


	SELECT  T1.CUS_ID ,T1.CUS_NM
			,(CASE  WHEN
					  EXISTS(
						  SELECT  *
						  FROM    T_ORD A
						  WHERE   A.CUS_ID = T1.CUS_ID
						  AND     A.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
						  AND     A.ORD_DT < TO_DATE('20170401','YYYYMMDD')
						  )
			  THEN 'Y'
			  ELSE 'N' END) ORD_YN_03
	FROM    M_CUS T1;



