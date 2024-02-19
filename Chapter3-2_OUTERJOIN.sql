
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
	SELECT  T0.CUS_ID ,T0.ITM_ID ,T0.ORD_DT ,T3.ITM_ID ,T3.EVL_PT
	FROM    (
	    SELECT T1.CUS_ID
	            , T2.ITM_ID
	            , T1.ORD_DT
	        FROM T_ORD T1
			,T_ORD_DET T2
	        WHERE T1.ORD_SEQ = T2.ORD_SEQ
	        AND T1.CUS_ID = 'CUS_0002'
	        AND T1.ORD_DT >= TO_DATE('20170122', 'YYYYMMDD')
	        AND T1.ORD_DT < TO_DATE('20170123', 'YYYYMMDD')
		) T0
	     ,T_ITM_EVL T3
	WHERE   T3.CUS_ID(+) = T0.CUS_ID
	AND     T3.ITM_ID(+) = T0.ITM_ID
	ORDER BY T0.CUS_ID;

	--��
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
	SELECT  T1.CUS_ID ,T2.ITM_ID ,T1.ORD_DT ,T3.ITM_ID ,T3.EVL_PT
	FROM    T_ORD T1
			LEFT OUTER JOIN T_ORD_DET T2
			    ON T2.ORD_SEQ = T1.ORD_SEQ
			LEFT OUTER JOIN T_ITM_EVL T3
	            ON T3.CUS_ID = T1.CUS_ID
	            AND T3.ITM_ID = T2.ITM_ID
	WHERE   T1.CUS_ID = 'CUS_0002'
	AND     T1.ORD_DT >= TO_DATE('20170122','YYYYMMDD')
	AND     T1.ORD_DT < TO_DATE('20170123','YYYYMMDD');

-- ��
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
SELECT CUS.CUS_ID
    , ORD.ORD_SEQ
    , ORD.ORD_DT
    , DET.ORD_SEQ
    , DET.ITM_ID
FROM M_CUS CUS
    LEFT OUTER JOIN T_ORD ORD
        ON CUS.CUS_ID = ORD.CUS_ID
        AND ORD.ORD_DT >= TO_DATE('20170122', 'YYYYMMDD')
        AND ORD.ORD_DT < TO_DATE('20170123', 'YYYYMMDD')
    LEFT OUTER JOIN T_ORD_DET DET
        ON ORD.ORD_SEQ = DET.ORD_SEQ
WHERE CUS.CUS_ID = 'CUS_0073';

-- ��
	SELECT  T1.CUS_ID ,T2.ORD_SEQ ,T2.ORD_DT ,T3.ORD_SEQ ,T3.ITM_ID
	FROM    M_CUS T1
			,T_ORD T2
			,T_ORD_DET T3
	WHERE   T1.CUS_ID = 'CUS_0073'
	AND     T1.CUS_ID = T2.CUS_ID(+)
	AND     T2.ORD_DT(+) >= TO_DATE('20170122','YYYYMMDD')
	AND     T2.ORD_DT(+) < TO_DATE('20170123','YYYYMMDD')
	AND     T3.ORD_SEQ= T2.ORD_SEQ;



-- ************************************************
-- PART I - 3.2.5 SQL1
-- ************************************************


	-- ��ID�� �ֹ��Ǽ�, �ֹ��� ���� ���� �������� ó��
SELECT CUS.CUS_ID
    , COUNT(*) ORD_CNT_1 -- ��� 1�� ����
    , COUNT(ORD.ORD_SEQ) -- ������ 0 ����
FROM M_CUS CUS
    LEFT OUTER JOIN T_ORD ORD
        ON ORD.CUS_ID = CUS.CUS_ID
        AND ORD.ORD_DT >= TO_DATE('20170101', 'YYYYMMDD')
        AND ORD.ORD_DT < TO_DATE('20170201', 'YYYYMMDD')
GROUP BY CUS.CUS_ID
ORDER BY COUNT(*), CUS.CUS_ID;



-- ��
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
SELECT ITM.ITM_ID
    , ITM.ITM_NM
    , COUNT(ORDDD.ITM_ID)
FROM M_ITM ITM
    LEFT OUTER JOIN (SELECT ORDD.ITM_ID
                     FROM T_ORD_DET ORDD
                     INNER JOIN T_ORD ORD
                        ON ORD.ORD_SEQ = ORDD.ORD_SEQ
                      AND ORD.ORD_ST = 'COMP'
                      AND ORD.ORD_DT >= TO_DATE('20170101', 'YYYYMMDD')
                      AND ORD.ORD_DT < TO_DATE('20170201', 'YYYYMMDD')) ORDDD
        ON ORDDD.ITM_ID = ITM.ITM_ID
WHERE ITM.ITM_TP IN ('PC','ELEC')
GROUP BY ITM.ITM_ID, ITM.ITM_NM
ORDER BY ITM_ID, ITM_NM;

;


SELECT * FROM T_ORD;
SELECT * FROM M_ITM
WHERE ITM_TP IN ('PC', 'ELEC');
SELECT * FROM T_ORD_DET;



-- ��
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



