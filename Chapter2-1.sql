-- 2.1 Group BY

-- 테이블 조회용
SELECT *  FROM T_ORD T1;
SELECT ORD_ST FROM T_ORD T1
GROUP BY ORD_ST;

----------------------------------------------------------
-- 주문일시, 지불유형별 주문금액
----------------------------------------------------------
SELECT ORD.PAY_DT
    , ORD.PAY_TP
    , SUM(ORD.PAY_AMT)
FROM T_ORD ORD
GROUP BY ORD.PAY_DT, ORD.PAY_TP
ORDER BY ORD.PAY_DT, ORD.PAY_TP;



----------------------------------------------------------
-- 집계함수 - 정상적인 SQL, 에러가 발생하는 SQL
----------------------------------------------------------
SELECT  COUNT(*) CNT
        ,SUM(T1.ORD_AMT) TTL_ORD_AMT
        ,MIN(T1.ORD_SEQ) MIN_ORD_SEQ
        ,MAX(T1.ORD_SEQ) MAX_ORD_SEQ
FROM    T_ORD T1;




----------------------------------------------------------
-- CASE를 이용해 가격유형(ORD_AMT_TP)별로 주문 건수를 카운트 (*)
-- -> GROUP BY 에도 CASE 문을 쓸 수 있음
----------------------------------------------------------
SELECT ORD.ORD_ST
    , CASE WHEN ORD.ORD_AMT >= 5000 THEN 'High Order'
        WHEN ORD.ORD_AMT >= 3000 THEN 'Middle Order'
        ELSE 'Low Order'
        END ORD_AMT_TP
    , COUNT(*) AS ORD_CNT
FROM T_ORD ORD
GROUP BY ORD.ORD_ST
    , CASE WHEN ORD.ORD_AMT >= 5000 THEN 'High Order'
        WHEN ORD.ORD_AMT >= 3000 THEN 'Middle Order'
        ELSE 'Low Order'
        END
ORDER BY 1,2;

-- 답
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
	ORDER BY 1 ,2;



----------------------------------------------------------
-- TO_CHAR 변형을 이용한 주문년월, 지불유형별 주문건수
----------------------------------------------------------
SELECT TO_CHAR(T1.ORD_DT, 'YYYYMM') AS ORD_YM
    , T1.PAY_TP
    , COUNT(*) AS ORD_CNT
FROM T_ORD T1
-- WHERE T1.ORD_ST = 'COMP'
GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMM')
    , T1.PAY_TP
ORDER BY 1,2 ;



-- 답
	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM ,T1.PAY_TP
			,COUNT(*) ORD_CNT
	FROM    T_ORD T1
	WHERE   T1.ORD_ST = 'COMP'
	GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.PAY_TP
	ORDER BY TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.PAY_TP;


----------------------------------------------------------
-- 주문년월별 계좌이체(PAY_TP=BANK) 건수와 카드결제(PAY_TP=CARD) 건수
-- -> SUM 안에 CASE 문 쓰는 방법 참고
----------------------------------------------------------
SELECT TO_CHAR(T1.ORD_DT, 'YYYYMM') AS ORD_YM
    , SUM(CASE WHEN PAY_TP = 'BANK' THEN 1 END) AS BANK_SUM
     , SUM(CASE WHEN PAY_TP = 'CARD' THEN 1 END) AS CARD_SUM
FROM T_ORD T1
WHERE T1.ORD_ST = 'COMP'
GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMM')
ORDER BY TO_CHAR(T1.ORD_DT, 'YYYYMM');



----------------------------------------------------------
-- 지불유형(PAY_TP)별 주문건수(주문 건수를 주문년월별로 컬럼으로 표시)
----------------------------------------------------------
SELECT T1.PAY_TP
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201701' THEN 1 END) ORD_CNT_1701
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201702' THEN 1 END) ORD_CNT_1702
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201703' THEN 1 END) ORD_CNT_1703
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201704' THEN 1 END) ORD_CNT_1704
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201705' THEN 1 END) ORD_CNT_1705
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201706' THEN 1 END) ORD_CNT_1706
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201707' THEN 1 END) ORD_CNT_1707
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201708' THEN 1 END) ORD_CNT_1708
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201709' THEN 1 END) ORD_CNT_1709
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201710' THEN 1 END) ORD_CNT_1710
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201711' THEN 1 END) ORD_CNT_1711
    , COUNT(CASE WHEN TO_CHAR(T1.ORD_DT, 'YYYYMM')='201712' THEN 1 END) ORD_CNT_1712
FROM T_ORD T1
WHERE T1.ORD_ST = 'COMP'
GROUP BY T1.PAY_TP;


-- 답
	SELECT  T1.PAY_TP
			,COUNT(CASE WHEN TO_CHAR(T1.ORD_DT,'YYYYMM') = '201701' THEN 'X' END) ORD_CNT_1701
			,COUNT(CASE WHEN TO_CHAR(T1.ORD_DT,'YYYYMM') = '201702' THEN 'X' END) ORD_CNT_1702
			--...201703~201711반복.
			,COUNT(CASE WHEN TO_CHAR(T1.ORD_DT,'YYYYMM') = '201712' THEN 'X' END) ORD_CNT_1712
	FROM    T_ORD T1
	WHERE   T1.ORD_ST = 'COMP'
	GROUP BY T1.PAY_TP
	ORDER BY T1.PAY_TP;



----------------------------------------------------------
-- 지불유형(PAY_TP)별 주문건수(주문 건수를 주문년월별로 컬럼으로 표시) - 인라인 뷰 활용
-- -> PIVOT
----------------------------------------------------------
SELECT T1.PAY_TP
    , MAX(CASE WHEN T1.ORD_YM='201701' THEN T1.ORD_CNT END) ORD_CNT_1701
    , MAX(CASE WHEN T1.ORD_YM='201702' THEN T1.ORD_CNT END) ORD_CNT_1702
    , MAX(CASE WHEN T1.ORD_YM='201703' THEN T1.ORD_CNT END) ORD_CNT_1703
    , MAX(CASE WHEN T1.ORD_YM='201704' THEN T1.ORD_CNT END) ORD_CNT_1704
    , MAX(CASE WHEN T1.ORD_YM='201705' THEN T1.ORD_CNT END) ORD_CNT_1705
    , MAX(CASE WHEN T1.ORD_YM='201706' THEN T1.ORD_CNT END) ORD_CNT_1706
    , MAX(CASE WHEN T1.ORD_YM='201707' THEN T1.ORD_CNT END) ORD_CNT_1707
    , MAX(CASE WHEN T1.ORD_YM='201708' THEN T1.ORD_CNT END) ORD_CNT_1708
    , MAX(CASE WHEN T1.ORD_YM='201709' THEN T1.ORD_CNT END) ORD_CNT_1709
    , MAX(CASE WHEN T1.ORD_YM='201710' THEN T1.ORD_CNT END) ORD_CNT_1710
    , MAX(CASE WHEN T1.ORD_YM='201711' THEN T1.ORD_CNT END) ORD_CNT_1711
    , MAX(CASE WHEN T1.ORD_YM='201712' THEN T1.ORD_CNT END) ORD_CNT_1712
FROM ( SELECT T1.PAY_TP,
            TO_CHAR(T1.ORD_DT, 'YYYYMM') AS ORD_YM
            , COUNT(*) AS ORD_CNT
       FROM T_ORD T1
       WHERE T1.ORD_ST = 'COMP'
       GROUP BY T1.PAY_TP, TO_CHAR(T1.ORD_DT, 'YYYYMM')
     ) T1
GROUP BY T1.PAY_TP;

-- 인라인뷰
SELECT T1.PAY_TP,
    TO_CHAR(T1.ORD_DT, 'YYYYMM') AS ORD_YM
    , COUNT(*) AS ORD_CNT
FROM T_ORD T1
WHERE T1.ORD_ST = 'COMP'
GROUP BY T1.PAY_TP, TO_CHAR(T1.ORD_DT, 'YYYYMM');

-- 답지
SELECT  T1.PAY_TP
        ,MAX(CASE WHEN T1.ORD_YM = '201701' THEN T1.ORD_CNT END) ORD_CNT_1701
        ,MAX(CASE WHEN T1.ORD_YM = '201702' THEN T1.ORD_CNT END) ORD_CNT_1702
        --...201703~201711반복.
        ,MAX(CASE WHEN T1.ORD_YM = '201712' THEN T1.ORD_CNT END) ORD_CNT_1712
FROM    (
        SELECT  T1.PAY_TP ,TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM
                ,COUNT(*) ORD_CNT
        FROM    T_ORD T1
        WHERE   T1.ORD_ST = 'COMP'
        GROUP BY T1.PAY_TP ,TO_CHAR(T1.ORD_DT,'YYYYMM')
        ) T1
GROUP BY T1.PAY_TP;



----------------------------------------------------------
-- NULL에 대한 COUNT #1
-- -> NULL인 컬럼을 카운트하면 안뜸
----------------------------------------------------------
SELECT COUNT(COL1) CNT_COL1
    , COUNT(COL2) CNT_COL2
    , COUNT(COL3) CNT_COL3
FROM (
    SELECT 'A' COL1
        , NULL COL2
        , 'C' COL3
    FROM DUAL
    UNION ALL
    SELECT 'B' COL1
        , NULL COL2
        , NULL COL3
    FROM DUAL
     ) T1;

----------------------------------------------------------
-- NULL에 대한 COUNT #2
-- COUNT(*)으로 하면 NULL인 컬럼이어도 뜸
----------------------------------------------------------
SELECT COUNT(COL1) CNT_COL1
    , COUNT(COL2) CNT_COL2
    , COUNT(COL3) CNT_COL3
FROM (
    SELECT 'A' COL1
        , NULL COL2
        , 'C' COL3
    FROM DUAL
    UNION ALL
    SELECT 'B' COL1
        , NULL COL2
        , NULL COL3
    FROM DUAL
     ) T1;


----------------------------------------------------------
-- 주문년월별 주문고객 수(중복을 제거해서 카운트), 주문건수
-- - 중복제거 => DISTINCT
----------------------------------------------------------
SELECT TO_CHAR(T1.ORD_DT, 'YYYYMM') AS ORD_DT
    , COUNT(DISTINCT T1.CUS_ID) AS CUS_CNT
    , COUNT(*) AS COUNT
FROM T_ORD T1
GROUP BY TO_CHAR(T1.ORD_DT, 'YYYYMM')
ORDER BY TO_CHAR(T1.ORD_DT, 'YYYYMM');
-- 답

	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM
			,COUNT(DISTINCT T1.CUS_ID) CUS_CNT
			,COUNT(*) ORD_CNT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170101','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170401','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM')
	ORDER BY TO_CHAR(T1.ORD_DT,'YYYYMM');

----------------------------------------------------------
-- 주문상태(ORD_ST)와 지불유형(PAY_TP)의 조합에 대한 종류 수
----------------------------------------------------------
-- 파이프를 쓰면 인라인뷰, GROUPBY 쓰지 않고도 작성가능
SELECT COUNT(DISTINCT T1.ORD_ST || '-' || T1.PAY_TP)
  FROM T_ORD T1;

SELECT COUNT(*)
FROM (SELECT DISTINCT T1.ORD_ST
           , T1.PAY_TP
      FROM T_ORD T1
      GROUP BY T1.ORD_ST, T1.PAY_TP);


-- 답지
	SELECT  COUNT(*)
	FROM    (
			SELECT  DISTINCT T1.ORD_ST ,T1.PAY_TP
			FROM    T_ORD T1
			) T2;


----------------------------------------------------------
-- 고객ID, 지불유형(PAY_TP)별 주문금액이 10,000 이상인 데이터만 조회
----------------------------------------------------------
SELECT T1.CUS_ID
    , T1.PAY_TP
    , SUM(T1.ORD_AMT)
FROM T_ORD T1
WHERE T1.ORD_ST = 'COMP'
GROUP BY T1.CUS_ID, T1.PAY_TP
HAVING SUM(T1.ORD_AMT) > 10000
ORDER BY T1.CUS_ID, T1.PAY_TP;






----------------------------------------------------------
-- HAVING 절에는 GROUP BY에 사용한 컬럼 또는 집계함수를 사용한 컬럼만 사용 가능하다.
-- HAVING절 대신 인라인-뷰를 사용
----------------------------------------------------------
SELECT TT1.CUS_ID
    , TT1.PAY_TP
    , TT1.ORD_TTL_AMT
FROM (SELECT T1.CUS_ID
           , T1.PAY_TP
           , SUM(T1.ORD_AMT) AS ORD_TTL_AMT
      FROM T_ORD T1
      WHERE T1.ORD_ST = 'COMP'
      GROUP BY T1.CUS_ID, T1.PAY_TP
      ORDER BY T1.CUS_ID, T1.PAY_TP) TT1
WHERE TT1.ORD_TTL_AMT >= 10000
ORDER BY TT1.ORD_TTL_AMT ASC;


-- 답지
	SELECT  T0.*
	FROM    (
			SELECT  T1.CUS_ID ,T1.PAY_TP ,SUM(T1.ORD_AMT) ORD_TTL_AMT
			FROM    T_ORD T1
			WHERE   T1.ORD_ST = 'COMP'
			GROUP BY T1.CUS_ID ,T1.PAY_TP
			) T0
	WHERE   T0.ORD_TTL_AMT >= 10000
	ORDER BY T0.ORD_TTL_AMT ASC;