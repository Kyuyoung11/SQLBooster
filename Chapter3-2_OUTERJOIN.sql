
-- ************************************************
-- PART I - 3.2.1 SQL1
-- ************************************************

	-- �̳�-���ΰ� �ƿ���-������ ��
	SELECT  T1.CUS_ID
			,T1.CUS_NM
			,T2.CUS_ID
			,T2.ITM_ID
			,T2.EVL_LST_NO
	FROM    M_CUS T1
			,T_ITM_EVL T2
	WHERE   T1.CUS_ID = 'CUS_0002'
	AND     T1.CUS_ID = T2.CUS_ID;

	SELECT  T1.CUS_ID
			,T1.CUS_NM
			,T2.CUS_ID
			,T2.ITM_ID
			,T2.EVL_LST_NO
	FROM    M_CUS T1
			,T_ITM_EVL T2
	WHERE   T1.CUS_ID = 'CUS_0002'
	AND     T1.CUS_ID = T2.CUS_ID(+);



-- ************************************************
-- PART I - 3.2.1 SQL2
-- ************************************************

	-- �ƿ���-����, �� ���� �򰡰� ����, �� ���� �򰡰� ����
SELECT CUS.CUS_ID
    , CUS.CUS_NM
    , EVL.CUS_ID
    , EVL.ITM_ID
    , EVL.EVL_LST_NO
FROM M_CUS CUS
    LEFT OUTER JOIN T_ITM_EVL EVL
        ON EVL.CUS_ID = CUS.CUS_ID
WHERE CUS.CUS_ID IN ('CUS_0002', 'CUS_0011')
ORDER BY CUS.CUS_ID;

-- ����
	SELECT  T1.CUS_ID ,T1.CUS_NM
			,T2.CUS_ID ,T2.ITM_ID ,T2.EVL_LST_NO
	FROM    M_CUS T1
			,T_ITM_EVL T2
	WHERE   T1.CUS_ID IN ('CUS_0002','CUS_0011')
	AND     T1.CUS_ID = T2.CUS_ID(+)
	ORDER BY T1.CUS_ID;



-- ************************************************
-- PART I - 3.2.2 SQL1
-- ************************************************

	-- ���� ���ǿ� (+)ǥ�� ������ ���� ��� ��
	SELECT  T1.CUS_ID ,T1.CUS_NM
			,T2.CUS_ID ,T2.ITM_ID
			,T2.EVL_LST_NO ,T2.EVL_DT
	FROM    M_CUS T1
			,T_ITM_EVL T2
	WHERE   T1.CUS_ID IN ('CUS_0073')
	AND     T1.CUS_ID = T2.CUS_ID(+)
	AND     T2.EVL_DT >= TO_DATE('20170201','YYYYMMDD')
	AND     T2.EVL_DT < TO_DATE('20170301','YYYYMMDD');


	SELECT  T1.CUS_ID ,T1.CUS_NM
			,T2.CUS_ID ,T2.ITM_ID
			,T2.EVL_LST_NO ,T2.EVL_DT
	FROM    M_CUS T1
			,T_ITM_EVL T2
	WHERE   T1.CUS_ID IN ('CUS_0073')
	AND T1.CUS_ID = T2.CUS_ID(+)
	AND T2.EVL_DT(+) >= TO_DATE('20170201','YYYYMMDD')
	AND T2.EVL_DT(+) < TO_DATE('20170301','YYYYMMDD');





-- ************************************************
-- PART I - 3.2.3 SQL1
-- ************************************************

	-- �Ұ����� �ƿ���-����
	SELECT  T1.CUS_ID ,T2.ITM_ID ,T1.ORD_DT ,T3.ITM_ID ,T3.EVL_PT
	FROM    T_ORD T1
			,T_ORD_DET T2
			,T_ITM_EVL T3
	WHERE   T1.ORD_SEQ = T2.ORD_SEQ
	AND     T1.CUS_ID = 'CUS_0002'
	AND     T1.ORD_DT >= TO_DATE('20170122','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170123','YYYYMMDD')
	AND     T3.CUS_ID(+) = T1.CUS_ID
	AND     T3.ITM_ID(+) = T2.ITM_ID;

	-- ORA-01417: a table may be outer joined to at most one other table





-- ************************************************
-- PART I - 3.2.3 SQL2
-- ************************************************


	-- �ζ���-�並 ����� �ƿ���-����
	SELECT  T0.CUS_ID ,T0.ITM_ID ,T0.ORD_DT
			,T3.ITM_ID ,T3.EVL_PT
	FROM    (
			SELECT  T1.CUS_ID ,T2.ITM_ID ,T1.ORD_DT
			FROM    T_ORD T1
					,T_ORD_DET T2
			WHERE   T1.ORD_SEQ = T2.ORD_SEQ
			AND     T1.CUS_ID = 'CUS_0002'
			AND     T1.ORD_DT >= TO_DATE('20170122','YYYYMMDD')
			AND     T1.ORD_DT < TO_DATE('20170123','YYYYMMDD')
			) T0
			,T_ITM_EVL T3
	WHERE   T3.CUS_ID(+) = T0.CUS_ID
	AND     T3.ITM_ID(+) = T0.ITM_ID
	ORDER BY T0.CUS_ID;




-- ************************************************
-- PART I - 3.2.3 SQL3
-- ************************************************

	-- ANSI ������ ����� �Ұ����� �ƿ���-���� �ذ�
	SELECT  T1.CUS_ID ,T2.ITM_ID ,T1.ORD_DT
			,T3.ITM_ID ,T3.EVL_PT
	FROM    T_ORD T1
			INNER JOIN T_ORD_DET T2
				ON (T1.ORD_SEQ = T2.ORD_SEQ
					AND T1.CUS_ID = 'CUS_0002'
					AND T1.ORD_DT >= TO_DATE('20170122','YYYYMMDD')
					AND T1.ORD_DT < TO_DATE('20170123','YYYYMMDD'))
			LEFT OUTER JOIN T_ITM_EVL T3
				ON (T3.CUS_ID = T1.CUS_ID
					AND T3.ITM_ID = T2.ITM_ID)
			;


-- ************************************************
-- PART I - 3.2.4 SQL1
-- ************************************************

	-- �ƿ���-���ΰ� �̳�-������ ���ÿ� ����ϴ� SQL
	SELECT  T1.CUS_ID ,T2.ORD_SEQ ,T2.ORD_DT ,T3.ORD_SEQ ,T3.ITM_ID
	FROM    M_CUS T1
			,T_ORD T2
			,T_ORD_DET T3
	WHERE   T1.CUS_ID = 'CUS_0073'
	AND     T1.CUS_ID = T2.CUS_ID(+)
	AND     T2.ORD_DT(+) >= TO_DATE('20170122','YYYYMMDD')
	AND     T2.ORD_DT(+) < TO_DATE('20170123','YYYYMMDD')
	AND     T3.ORD_SEQ = T2.ORD_SEQ;



-- ************************************************
-- PART I - 3.2.5 SQL1
-- ************************************************


	-- ��ID�� �ֹ��Ǽ�, �ֹ��� ���� ���� �������� ó��
	SELECT  T1.CUS_ID
			,COUNT(*) ORD_CNT_1
			,COUNT(T2.ORD_SEQ) ORD_CNT_2
	FROM    M_CUS T1
			,T_ORD T2
	WHERE   T1.CUS_ID = T2.CUS_ID(+)
	AND     T2.ORD_DT(+) >= TO_DATE('20170101','YYYYMMDD')
	AND     T2.ORD_DT(+) < TO_DATE('20170201','YYYYMMDD')
	GROUP BY T1.CUS_ID
	ORDER BY COUNT(*) ,T1.CUS_ID;




-- ************************************************
-- PART I - 3.2.5 SQL2
-- ************************************************

	-- ������ID�� �ֹ�����
	-- 'PC, ELEC' ������ ������ �����ۺ� �ֹ����� ��ȸ (�ֹ��� ��� 0���� ���;� �Ѵ�.)
	SELECT  T1.ITM_ID ,T1.ITM_NM ,NVL(T2.ORD_QTY,0)
	FROM    M_ITM T1
			,(  SELECT  B.ITM_ID ,SUM(B.ORD_QTY) ORD_QTY
				FROM    T_ORD A
						,T_ORD_DET B
				WHERE   A.ORD_SEQ = B.ORD_SEQ
				AND     A.ORD_ST = 'COMP' --�ֹ�����=�Ϸ�
				AND     A.ORD_DT >= TO_DATE('20170101','YYYYMMDD')
				AND     A.ORD_DT < TO_DATE('20170201','YYYYMMDD')
				GROUP BY B.ITM_ID ) T2
	WHERE   T1.ITM_ID = T2.ITM_ID(+)
	AND     T1.ITM_TP IN ('PC','ELEC')
	ORDER BY T1.ITM_TP ,T1.ITM_ID;




-- ************************************************
-- PART I - 3.3.1 SQL1
-- ************************************************

	-- �����(M_CUS.CUS_GD)�� ����������(M_ITM.ITM_TP)�� ���� ������ ��� ������
	SELECT  T1.CUS_GD ,T2.ITM_TP
	FROM    (SELECT DISTINCT A.CUS_GD FROM M_CUS A) T1
			,(SELECT DISTINCT A.ITM_TP FROM M_ITM A ) T2
	ORDER BY T1.CUS_GD ,T2.ITM_TP;





-- ************************************************
-- PART I - 3.3.2 SQL1
-- ************************************************

	-- ���� ������ ����
	SELECT  COUNT(*)
	FROM    T_ORD T1
			,T_ORD_DET T2;



-- ************************************************
-- PART I - 3.3.2 SQL2
-- ************************************************

	-- ���� ������ ��Ī �Ǽ�
	SELECT COUNT(*)
	FROM    T_ORD T1
			,T_ORD_DET T2
	WHERE   T1.ORD_SEQ = T1.ORD_SEQ;




-- ************************************************
-- PART I - 3.3.3 SQL1
-- ************************************************

	-- Ư�� �� �� ���� 2��, 3��, 4���� ���� �ֹ� �Ǽ�
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

	-- Ư�� �� �� ���� 2��, 3��, 4���� ���� �ֹ� �Ǽ� ? �ֹ��� ���� ���� 0���� ������ ó��
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

	-- �����, ������������ �ֹ�����
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

	-- �����, ������������ �ֹ����� ? �ֹ��� ���� ������������ �������� ó��
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

	-- �׽�Ʈ �ֹ������͸� ����� ���� SQL
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

	-- �ǹ� ���� ���� ����
	SELECT ROWNUM RNO FROM DUAL A CONNECT BY ROWNUM <= 10;



-- ************************************************
-- PART I - 3.3.4 SQL3
-- ************************************************

	-- ������ ������ ������ ����
	SELECT 'WAIT' ORD_ST FROM DUAL CONNECT BY ROWNUM <= 2 UNION ALL
	SELECT 'COMP' ORD_ST FROM DUAL CONNECT BY ROWNUM <= 3

