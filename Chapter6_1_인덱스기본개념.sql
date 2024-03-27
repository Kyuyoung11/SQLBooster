

-- ************************************************
-- PART II - 6.1.1 SQL1
-- ************************************************

-- 테스트를 위한 테이블 만들기
CREATE TABLE T_ORD_BIG AS
SELECT  T1.* ,T2.RNO ,TO_CHAR(T1.ORD_DT,'YYYYMMDD') ORD_YMD
FROM    T_ORD T1
        ,(SELECT ROWNUM RNO
          FROM DUAL CONNECT BY ROWNUM <= 10000) T2
          ;

-- 아래는 T_ORD_BIG 테이블의 통계를 생성하는 명령어다.
-- 첫 번째 파라미터에는 테이블 OWNER를, 두 번째 파라미터에는 테이블 명을 입력한다.
EXEC DBMS_STATS.GATHER_TABLE_STATS('ORA_SQL_TEST','T_ORD_BIG');


-- ************************************************
-- PART II - 6.1.1 SQL2
-- ************************************************

-- 인덱스가 없는 BIG테이블 조회
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

-- ORD_SEQ 컬럼에 인덱스 구성
CREATE INDEX X_T_ORD_BIG_TEST ON T_ORD_BIG(ORD_SEQ);



-- ************************************************
-- PART II - 6.1.5 SQL1
-- ************************************************

-- TABLE ACCESS FULL을 사용하는 SQL
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

-- INDEX RANGE SCAN을 사용하는 SQL
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

-- INDEX RANGE SCAN을 사용하는 SQL
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

-- 3개월간의 주문을 조회 ? ORD_YMD컬럼 인덱스를 사용
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

-- 3개월간의 주문을 조회 ? FULL(T1) 힌트 사용
SELECT  /*+ GATHER_PLAN_STATISTICS FULL(T1) */
        T1.ORD_ST ,SUM(T1.ORD_AMT)
FROM    T_ORD_BIG T1
WHERE   T1.ORD_YMD BETWEEN '20170401' AND '20170630'
GROUP BY T1.ORD_ST;

SELECT  *
FROM    TABLE(DBMS_XPLAN.DISPLAY_CURSOR('660666snjp7rd',0,'ALLSTATS LAST'));


