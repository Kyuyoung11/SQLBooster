

-- ************************************************
-- PART I - 2.3.1 SQL1
-- ************************************************

	-- 주문년월, 고객ID별 주문금액 ? ROLLUP 사용
	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM ,T1.CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	GROUP BY ROLLUP(TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.CUS_ID);



-- ************************************************
-- PART I - 2.3.1 SQL2
-- ************************************************

	-- ROLLUP을 UNION ALL로 대신하기
	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM ,T1.CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.CUS_ID
	UNION ALL
	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM ,'Total' CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM')
	UNION ALL
	SELECT  'Total' ORD_YM ,'Total' CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD');



-- ************************************************
-- PART I - 2.3.1 SQL3
-- ************************************************

	-- ROLLUP을 카테시안 조인으로 대신하기
	SELECT  CASE WHEN T2.RNO = 1 THEN TO_CHAR(T1.ORD_DT,'YYYYMM')
				  WHEN T2.RNO = 2 THEN TO_CHAR(T1.ORD_DT,'YYYYMM')
				  WHEN T2.RNO = 3 THEN 'Total' END ORD_YM
			,CASE WHEN T2.RNO = 1 THEN T1.CUS_ID
				  WHEN T2.RNO = 2 THEN 'Total'
				  WHEN T2.RNO = 3 THEN 'Total' END CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
			,(
				SELECT ROWNUM RNO FROM DUAL CONNECT BY ROWNUM <= 3
			) T2
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	GROUP BY CASE WHEN T2.RNO = 1 THEN TO_CHAR(T1.ORD_DT,'YYYYMM')
				  WHEN T2.RNO = 2 THEN TO_CHAR(T1.ORD_DT,'YYYYMM')
				  WHEN T2.RNO = 3 THEN 'Total' END
			,CASE WHEN T2.RNO = 1 THEN T1.CUS_ID
				  WHEN T2.RNO = 2 THEN 'Total'
				  WHEN T2.RNO = 3 THEN 'Total' END;



-- ************************************************
-- PART I - 2.3.1 SQL4
-- ************************************************

	-- ROLLUP을 WITH 절과 UNION ALL로 대체
	WITH T_RES AS(
		  SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM ,T1.CUS_ID
				  ,SUM(T1.ORD_AMT) ORD_AMT
		  FROM    T_ORD T1
		  WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
		  AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
		  AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
		  GROUP BY TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.CUS_ID
		  )
	SELECT  T1.ORD_YM ,T1.CUS_ID ,T1.ORD_AMT
	FROM    T_RES T1
	UNION ALL
	SELECT  T1.ORD_YM ,'Total' ,SUM(T1.ORD_AMT)
	FROM    T_RES T1
	GROUP BY T1.ORD_YM
	UNION ALL
	SELECT  'Total' ,'Total' ,SUM(T1.ORD_AMT)
	FROM    T_RES T1;



-- ************************************************
-- PART I - 2.3.2 SQL1
-- ************************************************

	-- 주문상태(ORD_ST), 주문년월, 고객ID별 주문금액 ? CUBE로 가능한 모든 소계를 추가
	SELECT  CASE  WHEN GROUPING(T1.ORD_ST)=1 THEN 'Total' ELSE T1.ORD_ST END ORD_ST
			,CASE WHEN GROUPING(TO_CHAR(T1.ORD_DT,'YYYYMM'))=1 THEN 'Total'
				  ELSE TO_CHAR(T1.ORD_DT,'YYYYMM') END ORD_YM
			,CASE WHEN GROUPING(T1.CUS_ID)=1 THEN 'Total' ELSE T1.CUS_ID END CUS_ID
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.CUS_ID IN ('CUS_0001','CUS_0002')
	AND     T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	GROUP BY CUBE(T1.ORD_ST ,TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.CUS_ID)
	ORDER BY T1.ORD_ST ,TO_CHAR(T1.ORD_DT,'YYYYMM') ,T1.CUS_ID;


-- ************************************************
-- PART I - 2.3.3 SQL1
-- ************************************************

	-- 주문년월, 고객ID별 주문건수와 주문 금액 ? GROUPING SETS 활용
	SELECT  TO_CHAR(T1.ORD_DT,'YYYYMM') ORD_YM
			,T1.CUS_ID
			,COUNT(*) ORD_CNT
			,SUM(T1.ORD_AMT) ORD_AMT
	FROM    T_ORD T1
	WHERE   T1.ORD_DT >= TO_DATE('20170301','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170501','YYYYMMDD')
	AND     T1.CUS_ID IN ('CUS_0061','CUS_0062')
	GROUP BY GROUPING SETS(
					  (TO_CHAR(T1.ORD_DT,'YYYYMM'),T1.CUS_ID)  --GROUP BY기본 데이터
					  ,(TO_CHAR(T1.ORD_DT,'YYYYMM'))  --주문년월별 소계
					  ,(T1.CUS_ID)  --고객ID별 소계
					  ,()   --전체합계
				  );

