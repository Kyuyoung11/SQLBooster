
-- ************************************************
-- PART II - 6.2.1 SQL1
-- ************************************************


-- �ε����� �ʿ��� SQL
SELECT  /*+ GATHER_PLAN_STATISTICS */
        TO_CHAR(T1.ORD_DT,'YYYYMM') ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.CUS_ID = 'CUS_0064'
AND     T1.PAY_TP = 'BANK'
AND     T1.RNO = 2
GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM');



-- ************************************************
-- PART II - 6.2.1 SQL2
-- ************************************************

-- ȿ������ ���� �ε��� ã��
SELECT  'CUS_ID' COL ,COUNT(*) CNT FROM T_ORD_BIG T1 WHERE T1.CUS_ID = 'CUS_0064'
UNION ALL
SELECT  'PAY_TP' COL ,COUNT(*) CNT FROM T_ORD_BIG T1 WHERE T1.PAY_TP = 'BANK'
UNION ALL
SELECT  'RNO' COL ,COUNT(*) CNT FROM T_ORD_BIG T1 WHERE T1.RNO = 2;


-- ************************************************
-- PART II - 6.2.1 SQL3
-- ************************************************

-- RNO �� ���� ���� �ε��� ����
CREATE INDEX X_T_ORD_BIG_2 ON T_ORD_BIG(RNO);


-- ************************************************
-- PART II - 6.2.1 SQL4
-- ************************************************

-- RNO�� ���� ���� �ε��� ���� �� SQL����
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_2) */
        TO_CHAR(T1.ORD_DT,'YYYYMM') ,COUNT(*)
FROM    T_ORD_BIG T1 
WHERE   T1.CUS_ID = 'CUS_0064'
AND     T1.PAY_TP = 'BANK'
AND     T1.RNO = 2
GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM');



-- ************************************************
-- PART II - 6.2.1 SQL5
-- ************************************************

-- CUS_ID �� ���� ���� �ε��� ����
CREATE INDEX X_T_ORD_BIG_3 ON T_ORD_BIG(CUS_ID);




-- ************************************************
-- PART II - 6.2.1 SQL6
-- ************************************************

-- CUS_ID�� ���� ���� �ε��� ���� �� SQL����
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_3) */
        TO_CHAR(T1.ORD_DT,'YYYYMM') ,COUNT(*)
FROM    T_ORD_BIG T1 
WHERE   T1.CUS_ID = 'CUS_0064'
AND     T1.PAY_TP = 'BANK'
AND     T1.RNO = 2
GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM');


SELECT  T1.SQL_ID ,T1.CHILD_NUMBER ,T1.SQL_TEXT
FROM    V$SQL T1
WHERE   T1.SQL_TEXT LIKE '%GATHER_PLAN_STATISTICS INDEX(T1 X%'
ORDER BY T1.LAST_ACTIVE_TIME DESC;


SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('b42g731m3m5jv',0,'ALLSTATS LAST'));



-- ************************************************
-- PART II - 6.2.2 SQL1
-- ************************************************

-- CUS_ID �� ���� ���� �ε��� ����
DROP INDEX X_T_ORD_BIG_3;



-- ************************************************
-- PART II - 6.2.2 SQL2
-- ************************************************

-- 2���� ������ ���� SQL ? ORD_YMD�ε����� ���
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_1) */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201703%'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;


-- ************************************************
-- PART II - 6.2.2 SQL3
-- ************************************************

-- ORD_YMD, CUS_ID������ ���� �ε����� ����
CREATE INDEX X_T_ORD_BIG_3 ON T_ORD_BIG(ORD_YMD, CUS_ID);




-- ************************************************
-- PART II - 6.2.2 SQL4
-- ************************************************

-- ORD_YMD, CUS_ID ���� �ε����� ����ϵ��� SQL�� ����
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_3) */
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
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('4f3zn95aaqn87',0,'ALLSTATS LAST'));


