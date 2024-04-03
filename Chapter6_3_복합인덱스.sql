-- ************************************************
-- PART II - 6.3.1 SQL1
-- ************************************************

-- 2개의 조건이 사용된 SQL
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_3) */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201703%'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;



-- ************************************************
-- PART II - 6.3.1 SQL2
-- ************************************************

-- CUS_ID, ORD_YMD로 구성된 인덱스
CREATE INDEX X_T_ORD_BIG_4 ON T_ORD_BIG(CUS_ID, ORD_YMD);



-- ************************************************
-- PART II - 6.3.1 SQL3
-- ************************************************

-- CUS_ID, ORD_YMD인덱스를 사용하는 SQL
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_4) */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201703%'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;


SELECT  T1.SQL_ID ,T1.CHILD_NUMBER ,T1.SQL_TEXT
FROM    V$SQL T1
WHERE   T1.SQL_TEXT LIKE '%GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_3)%'
ORDER BY T1.LAST_ACTIVE_TIME DESC;


SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('03u9urh9t9k76',0,'ALLSTATS LAST'));


-- ************************************************
-- PART II - 6.3.2 SQL1
-- ************************************************

-- ORD_YMD가 같다(=)조건으로 CUS_ID가 LIKE조건으로 사용하는 SQL
SELECT  T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD = '20170301'
AND     T1.CUS_ID LIKE 'CUS_001%'
GROUP BY T1.ORD_ST;


-- ************************************************
-- PART II - 6.3.3 SQL1
-- ************************************************

-- 세 개의 조건이 사용된 SQL
SELECT  /*+ GATHER_PLAN_STATISTICS */
		T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201704%'
AND     T1.CUS_ID = 'CUS_0042'
AND     T1.PAY_TP = 'BANK'
GROUP BY T1.ORD_ST;



-- ************************************************
-- PART II - 6.3.3 SQL2
-- ************************************************

-- 특정 고객ID에 주문이 존재하는지 확인하는 SQL
SELECT  'X'
FROM    DUAL A
WHERE   EXISTS(
          SELECT  *
          FROM    T_ORD_BIG T1
          WHERE   T1.CUS_ID = 'CUS_0042'
          );



-- ************************************************
-- PART II - 6.3.4 SQL1
-- ************************************************

-- 많은 조건이 걸리는 SQL
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_3) */
    COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_AMT = 2400
AND     T1.PAY_TP = 'CARD'
AND     T1.ORD_YMD = '20170406'
AND     T1.ORD_ST = 'COMP'
AND     T1.CUS_ID = 'CUS_0036';



-- ************************************************
-- PART II - 6.3.4 SQL2
-- ************************************************

-- 각 조건별로 카운트 해보기
SELECT  'ORD_AMT' COL ,COUNT(*) FROM T_ORD_BIG T1 WHERE T1.ORD_AMT = 2400
UNION ALL
SELECT  'PAY_TP' COL ,COUNT(*) FROM T_ORD_BIG T1 WHERE T1.PAY_TP = 'CARD'
UNION ALL
SELECT  'ORD_YMD' COL ,COUNT(*) FROM T_ORD_BIG T1 WHERE T1.ORD_YMD = '20170406'
UNION ALL
SELECT  'ORD_ST' COL ,COUNT(*) FROM T_ORD_BIG T1 WHERE T1.ORD_ST = 'COMP'
UNION ALL
SELECT  'CUS_ID' COL ,COUNT(*)  FROM T_ORD_BIG T1 WHERE T1.CUS_ID = 'CUS_0036';

