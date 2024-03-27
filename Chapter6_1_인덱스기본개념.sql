

-- ************************************************
-- PART II - 6.1.1 SQL1
-- ************************************************

-- �׽�Ʈ�� ���� ���̺� �����
CREATE TABLE T_ORD_BIG AS
SELECT  T1.* ,T2.RNO ,TO_CHAR(T1.ORD_DT,'YYYYMMDD') ORD_YMD
FROM    T_ORD T1
        ,(SELECT ROWNUM RNO
          FROM DUAL CONNECT BY ROWNUM <= 10000) T2
          ;

-- �Ʒ��� T_ORD_BIG ���̺��� ��踦 �����ϴ� ��ɾ��.
-- ù ��° �Ķ���Ϳ��� ���̺� OWNER��, �� ��° �Ķ���Ϳ��� ���̺� ���� �Է��Ѵ�.
EXEC DBMS_STATS.GATHER_TABLE_STATS('ORA_SQL_TEST','T_ORD_BIG');


-- ************************************************
-- PART II - 6.1.1 SQL2
-- ************************************************

-- �ε����� ���� BIG���̺� ��ȸ
SELECT  /*+ GATHER_PLAN_STATISTICS */ 
        COUNT(*) 
FROM    T_ORD_BIG T1 
WHERE   T1.ORD_SEQ = 343;



SELECT  T1.SQL_ID ,T1.CHILD_NUMBER ,T1.SQL_TEXT
FROM    V$SQL T1
WHERE   T1.SQL_TEXT LIKE '%GATHER_PLAN_STATISTICS%'
ORDER BY T1.LAST_ACTIVE_TIME DESC;


SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('64zytgkun017h',0,'ALLSTATS LAST'));


-- ************************************************
-- PART II - 6.1.1 SQL3
-- ************************************************

-- ORD_SEQ �÷��� �ε��� ����
CREATE INDEX X_T_ORD_BIG_TEST ON T_ORD_BIG(ORD_SEQ);



-- ************************************************
-- PART II - 6.1.5 SQL1
-- ************************************************

-- TABLE ACCESS FULL�� ����ϴ� SQL
SELECT  /*+ GATHER_PLAN_STATISTICS */
        T1.CUS_ID ,COUNT(*) ORD_CNT
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD = '20170316'
GROUP BY T1.CUS_ID
ORDER BY T1.CUS_ID;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('0pghnam4br94r',0,'ALLSTATS LAST'));


-- ************************************************
-- PART II - 6.1.6 SQL1
-- ************************************************

-- INDEX RANGE SCAN�� ����ϴ� SQL
CREATE INDEX X_T_ORD_BIG_1 ON T_ORD_BIG(ORD_YMD);

SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_1) */
        T1.CUS_ID ,COUNT(*) ORD_CNT
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD = '20170316'
GROUP BY T1.CUS_ID
ORDER BY T1.CUS_ID;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('br1774wn1f4yc',0,'ALLSTATS LAST'));


-- ************************************************
-- PART II - 6.1.7 SQL1
-- ************************************************

-- INDEX RANGE SCAN�� ����ϴ� SQL
SELECT  /*+ GATHER_PLAN_STATISTICS 6.1.7*/
        T1.CUS_ID ,COUNT(*) ORD_CNT
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD = '20170316'
GROUP BY T1.CUS_ID
ORDER BY T1.CUS_ID;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('936uuj6k8q5v6',0,'ALLSTATS LAST'));




-- ************************************************
-- PART II - 6.1.7 SQL2
-- ************************************************

-- 3�������� �ֹ��� ��ȸ ? ORD_YMD�÷� �ε����� ���
SELECT  /*+ GATHER_PLAN_STATISTICS INDEX(T1 X_T_ORD_BIG_1) */
        T1.ORD_ST ,SUM(T1.ORD_AMT)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD BETWEEN '20170401' AND '20170630'
GROUP BY T1.ORD_ST;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('9s6kqtqd5nzrb',0,'ALLSTATS LAST'));




-- ************************************************
-- PART II - 6.1.7 SQL3
-- ************************************************

-- 3�������� �ֹ��� ��ȸ ? FULL(T1) ��Ʈ ���
SELECT  /*+ GATHER_PLAN_STATISTICS FULL(T1) */
        T1.ORD_ST ,SUM(T1.ORD_AMT)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD BETWEEN '20170401' AND '20170630'
GROUP BY T1.ORD_ST;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('660666snjp7rd',0,'ALLSTATS LAST'));


