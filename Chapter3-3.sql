
-- ************************************************
-- PART I - 3.3.1 SQL1
-- ************************************************

	-- 고객등급(M_CUS.CUS_GD)과 아이템유형(M_ITM.ITM_TP)의 조합 가능한 모든 데이터
	SELECT  T1.CUS_GD ,T2.ITM_TP
	FROM    (SELECT DISTINCT A.CUS_GD FROM M_CUS A) T1
			,(SELECT DISTINCT A.ITM_TP FROM M_ITM A ) T2
	ORDER BY T1.CUS_GD ,T2.ITM_TP;





-- ************************************************
-- PART I - 3.3.2 SQL1
-- ************************************************

	-- 조인 조건의 누락
	SELECT  COUNT(*)
	FROM    T_ORD T1
			,T_ORD_DET T2;



-- ************************************************
-- PART I - 3.3.2 SQL2
-- ************************************************

	-- 조인 조건의 별칭 실수
	SELECT COUNT(*)
	FROM    T_ORD T1
			,T_ORD_DET T2
	WHERE   T1.ORD_SEQ = T1.ORD_SEQ;




-- ************************************************
-- PART I - 3.3.3 SQL1
-- ************************************************

	-- 특정 고객 두 명의 2월, 3월, 4월의 월별 주문 건수
	SELECT  T1.CUS_ID ,T1.CUS_NM ,T2.ORD_YM ,T2.ORD_CNT
	FROM    M_CUS T1
			,(  SELECT  A.CUS_ID
						,TO_CHAR(A.ORD_DT,'YYYYMM') ORD_YM
						,COUNT(*) ORD_CNT
				FROM    T_ORD A
				WHERE   A.CUS_ID IN ('CUS_0003','CUS_0004')
				AND     A.ORD_DT >= TO_DATE('20170201','YYYYMMDD')
				AND     A.ORD_DT < TO_DATE('20170501','YYYYMMDD')
				GROUP BY A.CUS_ID
						,TO_CHAR(A.ORD_DT,'YYYYMM')
			) T2
	WHERE   T1.CUS_ID IN ('CUS_0003','CUS_0004')
	AND     T1.CUS_ID = T2.CUS_ID(+)
	ORDER BY T1.CUS_ID ,T2.ORD_YM;



-- ************************************************
-- PART I - 3.3.3 SQL2
-- ************************************************

	-- 특정 고객 두 명의 2월, 3월, 4월의 월별 주문 건수 ? 주문이 없는 월도 0으로 나오게 처리
	SELECT  T0.CUS_ID ,T0.CUS_NM ,T0.BASE_YM ,NVL(T2.ORD_CNT,0) ORD_CNT
	FROM    (   SELECT  T1.CUS_ID
						,T1.CUS_NM
						,T4.BASE_YM
				FROM    M_CUS T1
						,(
						 SELECT TO_CHAR(ADD_MONTHS(TO_DATE('20170201','YYYYMMDD'),ROWNUM-1),'YYYYMM') BASE_YM
						 FROM   DUAL
						 CONNECT BY ROWNUM <= 3
						) T4
				WHERE   T1.CUS_ID IN ('CUS_0003','CUS_0004')) T0
			,(  SELECT  A.CUS_ID
						,TO_CHAR(A.ORD_DT,'YYYYMM') ORD_YM
						,COUNT(*) ORD_CNT
				FROM    T_ORD A
				WHERE   A.CUS_ID IN ('CUS_0003','CUS_0004')
				AND     A.ORD_DT >= TO_DATE('20170201','YYYYMMDD')
				AND     A.ORD_DT < TO_DATE('20170501','YYYYMMDD')
				GROUP BY A.CUS_ID
						,TO_CHAR(A.ORD_DT,'YYYYMM')) T2
	WHERE   T0.CUS_ID = T2.CUS_ID(+)
	AND     T0.BASE_YM = T2.ORD_YM(+)
	ORDER BY T0.CUS_ID ,T0.BASE_YM;




-- ************************************************
-- PART I - 3.3.3 SQL3
-- ************************************************

	-- 고객등급, 아이템유형별 주문수량
	SELECT  A.CUS_GD ,D.ITM_TP
			,SUM(C.ORD_QTY) ORD_QTY
	FROM    M_CUS A
			,T_ORD B
			,T_ORD_DET C
			,M_ITM D
	WHERE   A.CUS_ID = B.CUS_ID
	AND     C.ORD_SEQ = B.ORD_SEQ
	AND     D.ITM_ID = C.ITM_ID
	AND     B.ORD_ST = 'COMP'
	GROUP BY A.CUS_GD ,D.ITM_TP
	ORDER BY A.CUS_GD ,D.ITM_TP;




-- ************************************************
-- PART I - 3.3.3 SQL4
-- ************************************************

	-- 고객등급, 아이템유형별 주문수량 ? 주문이 없는 아이템유형도 나오도록 처리
	SELECT  T0.CUS_GD ,T0.ITM_TP ,NVL(T3.ORD_QTY,0) ORD_QTY
	FROM    (       SELECT  T1.CUS_GD ,T2.ITM_TP
					FROM    (SELECT  A.BAS_CD CUS_GD FROM C_BAS_CD A WHERE A.BAS_CD_DV = 'CUS_GD') T1
							,(SELECT  A.BAS_CD ITM_TP FROM C_BAS_CD A WHERE A.BAS_CD_DV = 'ITM_TP') T2
			) T0
			,(      SELECT  A.CUS_GD ,D.ITM_TP
							,SUM(C.ORD_QTY) ORD_QTY
					FROM    M_CUS A
							,T_ORD B
							,T_ORD_DET C
							,M_ITM D
					WHERE   A.CUS_ID = B.CUS_ID
					AND     C.ORD_SEQ = B.ORD_SEQ
					AND     D.ITM_ID = C.ITM_ID
					AND     B.ORD_ST = 'COMP'
					GROUP BY A.CUS_GD ,D.ITM_TP
			) T3
	WHERE   T0.CUS_GD = T3.CUS_GD(+)
	AND     T0.ITM_TP = T3.ITM_TP(+)
	ORDER BY T0.CUS_GD ,T0.ITM_TP;



-- ************************************************
-- PART I - 3.3.4 SQL1
-- ************************************************

	-- 테스트 주문데이터를 만들기 위한 SQL
	SELECT  ROWNUM ORD_NO ,T1.CUS_ID ,T2.ORD_ST ,T3.PAY_TP ,T4.ORD_DT
	FROM    M_CUS T1
			,(  SELECT 'WAIT' ORD_ST FROM DUAL UNION ALL
				SELECT 'COMP' ORD_ST FROM DUAL ) T2
			,(  SELECT  'CARD' PAY_TP FROM DUAL UNION ALL
				SELECT  'BANK' PAY_TP FROM DUAL UNION ALL
				SELECT  NULL PAY_TP FROM DUAL ) T3
			,(
				SELECT  TO_DATE('20170101','YYYYMMDD') + (ROWNUM-1) ORD_DT
				FROM    DUAL
				CONNECT BY ROWNUM <= 365 ) T4;





-- ************************************************
-- PART I - 3.3.4 SQL2
-- ************************************************

	-- 의미 없는 숫자 집합
	SELECT ROWNUM RNO FROM DUAL A CONNECT BY ROWNUM <= 10;



-- ************************************************
-- PART I - 3.3.4 SQL3
-- ************************************************

	-- 데이터 값별로 분포도 조정
	SELECT 'WAIT' ORD_ST FROM DUAL CONNECT BY ROWNUM <= 2 UNION ALL
	SELECT 'COMP' ORD_ST FROM DUAL CONNECT BY ROWNUM <= 3

