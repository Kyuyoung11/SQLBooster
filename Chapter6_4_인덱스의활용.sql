-- ************************************************
-- PART II - 6.4.1 SQL1
-- ************************************************

-- CUS_ID, ORD_YMD�ε����� ����ϴ� SQL
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_4) */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201703%'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;


-- ************************************************
-- PART II - 6.4.1 SQL2
-- ************************************************

-- X_T_ORD_BIG_4�ε����� �����
DROP INDEX X_T_ORD_BIG_4;
CREATE INDEX X_T_ORD_BIG_4 ON T_ORD_BIG(CUS_ID, ORD_YMD, ORD_ST);


-- ************************************************
-- PART II - 6.4.2 SQL1
-- ************************************************

-- CUS_0075�� 201703�ֹ��� ��ȸ�ϴ� SQL
SELECT  /*+ GATHER_PLAN_STATISTICS */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   SUBSTR(T1.ORD_YMD,1,6) = '201703'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;

-- ************************************************
-- PART II - 6.4.2 SQL2
-- ************************************************

-- CUS_0075�� 201703�ֹ��� ��ȸ�ϴ� SQL ? LIKE�� ó��
SELECT  /*+ GATHER_PLAN_STATISTICS */
        T1.ORD_ST ,COUNT(*)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD LIKE '201703%'
AND     T1.CUS_ID = 'CUS_0075'
GROUP BY T1.ORD_ST;

-- ************************************************
-- PART II - 6.4.3 SQL1
-- ************************************************

-- ���̺� �� �ε��� ũ�� Ȯ��
SELECT  T1.SEGMENT_NAME ,T1.SEGMENT_TYPE
        ,T1.BYTES / 1024 / 1024 as SIZE_MB
        ,T1.BYTES / T2.CNT BYTE_PER_ROW
FROM    DBA_SEGMENTS T1
        ,(SELECT COUNT(*) CNT FROM ORA_SQL_TEST.T_ORD_BIG) T2
WHERE   T1.SEGMENT_NAME LIKE '%ORD_BIG%'
ORDER BY T1.SEGMENT_NAME;














