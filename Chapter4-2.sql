
-- ************************************************
-- PART I - 4.2.1 SQL1
-- ************************************************

	-- MERGE 문을 위한 테스트 테이블 생성
	CREATE TABLE M_CUS_CUD_TEST AS
	SELECT  *
	FROM    M_CUS T1;

	ALTER TABLE M_CUS_CUD_TEST
		ADD CONSTRAINT PK_M_CUS_CUD_TEST PRIMARY KEY(CUS_ID) USING INDEX;



-- ************************************************
-- PART I - 4.2.1 SQL2
-- ************************************************

	-- CUS_0090 고객을 입력하거나 변경하는 PL/SQL
	DECLARE v_EXISTS_YN varchar2(1);
	BEGIN
		SELECT  NVL(MAX('Y'),'N')
		INTO    v_EXISTS_YN
		FROM    DUAL A
		WHERE   EXISTS(
				  SELECT  *
				  FROM    M_CUS_CUD_TEST T1
				  WHERE   T1.CUS_ID = 'CUS_0090'
				  );

		IF v_EXISTS_YN = 'N' THEN
			INSERT INTO M_CUS_CUD_TEST (CUS_ID ,CUS_NM ,CUS_GD)
			VALUES  ('CUS_0090' ,'NAME_0090' ,'A');

			DBMS_OUTPUT.PUT_LINE('INSERT NEW CUST');
		ELSE
			UPDATE  M_CUS_CUD_TEST T1
			SET     T1.CUS_NM = 'NAME_0090'
					,T1.CUS_GD = 'A'
			WHERE   CUS_ID = 'CUS_0090'
			;

			DBMS_OUTPUT.PUT_LINE('UPDATE OLD CUST');
		END IF;

		COMMIT;
	END;



-- ************************************************
-- PART I - 4.2.1 SQL3
-- ************************************************

	-- 고객을 입력하거나 변경하는 SQL ? MERGE 문으로 처리
	MERGE INTO M_CUS_CUD_TEST T1
	USING (
		  SELECT  'CUS_0090' CUS_ID
				  ,'NAME_0090' CUS_NM
				  ,'A' CUS_GD
		  FROM    DUAL
		  ) T2
		  ON (T1.CUS_ID = T2.CUS_ID)
	WHEN MATCHED THEN UPDATE SET T1.CUS_NM = T2.CUS_NM
								,T1.CUS_GD = T2.CUS_GD
	WHEN NOT MATCHED THEN INSERT (T1.CUS_ID ,T1.CUS_NM ,T1.CUS_GD)
						  VALUES(T2.CUS_ID ,T2.CUS_NM ,T2.CUS_GD)
						  ;
	COMMIT;



-- ************************************************
-- PART I - 4.2.2 SQL1
-- ************************************************

	-- 월별고객주문 테이블 생성 및 기조 데이터 입력
	CREATE TABLE S_CUS_YM
	(
		BAS_YM	VARCHAR2(6) NOT NULL,
		CUS_ID 	VARCHAR2(40) NOT NULL,
		ITM_TP 	VARCHAR2(40) NOT NULL,
		ORD_QTY NUMBER(18,3) NULL,
		ORD_AMT NUMBER(18,3) NULL
	);

	CREATE UNIQUE INDEX PK_S_CUS_YM ON S_CUS_YM(BAS_YM, CUS_ID, ITM_TP);

	ALTER TABLE S_CUS_YM
		ADD CONSTRAINT PK_S_CUM_YM PRIMARY KEY (BAS_YM, CUS_ID, ITM_TP);

	INSERT INTO S_CUS_YM (BAS_YM ,CUS_ID ,ITM_TP ,ORD_QTY ,ORD_AMT)
	SELECT  '201702' BAS_YM ,T1.CUS_ID ,T2.BAS_CD ITM_TP ,NULL ORD_QTY ,NULL ORD_AMT
	FROM    M_CUS T1
			,C_BAS_CD T2
	WHERE   T2.BAS_CD_DV = 'ITM_TP'
	AND     T2.LNG_CD = 'KO';

	COMMIT;



-- ************************************************
-- PART I - 4.2.2 SQL2
-- ************************************************

	-- 월별고객주문의 주문수량, 주문금액 업데이트
	UPDATE  S_CUS_YM T1
	SET     T1.ORD_QTY = (
					SELECT  SUM(B.ORD_QTY)
					FROM    T_ORD A
							,T_ORD_DET B
							,M_ITM C
					WHERE   A.ORD_SEQ = B.ORD_SEQ
					AND     C.ITM_ID = B.ITM_ID
					AND     C.ITM_TP = T1.ITM_TP
					AND     A.CUS_ID = T1.CUS_ID
					AND     A.ORD_DT >= TO_DATE(T1.BAS_YM||'01','YYYYMMDD')
					AND     A.ORD_DT < ADD_MONTHS(TO_DATE(T1.BAS_YM||'01','YYYYMMDD'), 1)
					)
			,T1.ORD_AMT = (
					SELECT  SUM(B.UNT_PRC * B.ORD_QTY)
					FROM    T_ORD A
							,T_ORD_DET B
							,M_ITM C
					WHERE   A.ORD_SEQ = B.ORD_SEQ
					AND     C.ITM_ID = B.ITM_ID
					AND     C.ITM_TP = T1.ITM_TP
					AND     A.CUS_ID = T1.CUS_ID
					AND     A.ORD_DT >= TO_DATE(T1.BAS_YM||'01','YYYYMMDD')
					AND     A.ORD_DT < ADD_MONTHS(TO_DATE(T1.BAS_YM||'01','YYYYMMDD'), 1)
					)
	WHERE   T1.BAS_YM = '201702';

	COMMIT;


-- ************************************************
-- PART I - 4.2.2 SQL3
-- ************************************************

	-- 월별고객주문의 주문금액, 주문수량 업데이트 ? 머지 사용
	MERGE INTO S_CUS_YM T1
	USING (
			  SELECT  A.CUS_ID
					  ,C.ITM_TP
					  ,SUM(B.ORD_QTY) ORD_QTY
					  ,SUM(B.UNT_PRC * B.ORD_QTY) ORD_AMT
			  FROM    T_ORD A
					  ,T_ORD_DET B
					  ,M_ITM C
			  WHERE   A.ORD_SEQ = B.ORD_SEQ
			  AND     C.ITM_ID = B.ITM_ID
			  AND     A.ORD_DT >= TO_DATE('201702'||'01','YYYYMMDD')
			  AND     A.ORD_DT < ADD_MONTHS(TO_DATE('201702'||'01','YYYYMMDD'), 1)
			  GROUP BY A.CUS_ID
					  ,C.ITM_TP
			  ) T2
			  ON (T1.BAS_YM = '201702'
				  AND T1.CUS_ID = T2.CUS_ID
				  AND T1.ITM_TP = T2.ITM_TP
				  )
	WHEN MATCHED THEN UPDATE SET T1.ORD_QTY = T2.ORD_QTY
								,T1.ORD_AMT = T2.ORD_AMT
								;
	COMMIT;


-- ************************************************
-- PART I - 4.2.2 SQL4
-- ************************************************

	-- 월별고객주문의 주문금액, 주문수량 업데이트 ? 반복 서브쿼리 제거
	UPDATE  S_CUS_YM T1
	SET     (T1.ORD_QTY ,T1.ORD_AMT) =
			(
			  SELECT  SUM(B.ORD_QTY) ORD_QTY
					  ,SUM(B.UNT_PRC * B.ORD_QTY) ORD_AMT
			  FROM    T_ORD A
					  ,T_ORD_DET B
					  ,M_ITM C
			  WHERE   A.ORD_SEQ = B.ORD_SEQ
			  AND     C.ITM_ID = B.ITM_ID
			  AND     A.ORD_DT >= TO_DATE('201702'||'01','YYYYMMDD')
			  AND     A.ORD_DT < ADD_MONTHS(TO_DATE('201702'||'01','YYYYMMDD'), 1)
			  AND     C.ITM_TP = T1.ITM_TP
			  AND     A.CUS_ID = T1.CUS_ID
			  GROUP BY A.CUS_ID
					  ,C.ITM_TP
			)
	WHERE   T1.BAS_YM = '201702';

	COMMIT;



-- ************************************************
-- PART I - 4.3.1 SQL1
-- ************************************************

	-- 고객, 아이템유형별 주문금액 구하기 ? 인라인-뷰 이용
	SELECT  T0.CUS_ID ,T1.CUS_NM ,T0.ITM_TP
			,(SELECT A.BAS_CD_NM FROM C_BAS_CD A
	WHERE A.LNG_CD = 'KO' AND A.BAS_CD_DV = 'ITM_TP' AND A.BAS_CD = T0.ITM_TP) ITM_TP_NM
			,T0.ORD_AMT
	FROM    (
			SELECT  A.CUS_ID ,C.ITM_TP ,SUM(B.ORD_QTY * B.UNT_PRC) ORD_AMT
			FROM    T_ORD A
					,T_ORD_DET B
					,M_ITM C
			WHERE   A.ORD_SEQ = B.ORD_SEQ
			AND     B.ITM_ID = C.ITM_ID
			AND     A.ORD_DT >= TO_DATE('20170201','YYYYMMDD')
			AND     A.ORD_DT < TO_DATE('20170301','YYYYMMDD')
			GROUP BY A.CUS_ID ,C.ITM_TP
			) T0
			,M_CUS T1
	WHERE   T1.CUS_ID = T0.CUS_ID
	ORDER BY T0.CUS_ID ,T0.ITM_TP;




-- ************************************************
-- PART I - 4.3.1 SQL2
-- ************************************************

	-- 고객, 아이템유형별 주문금액 구하기 ? WITH~AS 이용
	WITH T_CUS_ITM_AMT AS (
			SELECT  A.CUS_ID ,C.ITM_TP ,SUM(B.ORD_QTY * B.UNT_PRC) ORD_AMT
			FROM    T_ORD A
					,T_ORD_DET B
					,M_ITM C
			WHERE   A.ORD_SEQ = B.ORD_SEQ
			AND     B.ITM_ID = C.ITM_ID
			AND     A.ORD_DT >= TO_DATE('20170201','YYYYMMDD')
			AND     A.ORD_DT < TO_DATE('20170301','YYYYMMDD')
			GROUP BY A.CUS_ID ,C.ITM_TP
			)
	SELECT  T0.CUS_ID ,T1.CUS_NM ,T0.ITM_TP
			,(SELECT A.BAS_CD_NM FROM C_BAS_CD A
	WHERE A.LNG_CD = 'KO' AND A.BAS_CD_DV = 'ITM_TP' AND A.BAS_CD = T0.ITM_TP) ITM_TP_NM
			,T0.ORD_AMT
	FROM    T_CUS_ITM_AMT T0
			,M_CUS T1
	WHERE   T1.CUS_ID = T0.CUS_ID
	ORDER BY T0.CUS_ID ,T0.ITM_TP;





-- ************************************************
-- PART I - 4.3.1 SQL3
-- ************************************************

	-- 고객, 아이템유형별 주문금액 구하기, 전체주문 대비 주문금액비율 추가 ? WITH~AS 이용
	WITH T_CUS_ITM_AMT AS (
			SELECT  A.CUS_ID ,C.ITM_TP ,SUM(B.ORD_QTY * B.UNT_PRC) ORD_AMT
			FROM    T_ORD A
					,T_ORD_DET B
					,M_ITM C
			WHERE   A.ORD_SEQ = B.ORD_SEQ
			AND     B.ITM_ID = C.ITM_ID
			AND     A.ORD_DT >= TO_DATE('20170201','YYYYMMDD')
			AND     A.ORD_DT < TO_DATE('20170301','YYYYMMDD')
			GROUP BY A.CUS_ID ,C.ITM_TP
			)
		,T_TTL_AMT AS(
			SELECT  SUM(A.ORD_AMT) ORD_AMT
			FROM    T_CUS_ITM_AMT A
			)
	SELECT  T0.CUS_ID ,T1.CUS_NM ,T0.ITM_TP
			,(SELECT A.BAS_CD_NM FROM C_BAS_CD A
				WHERE A.LNG_CD = 'KO' AND A.BAS_CD_DV = 'ITM_TP' AND A.BAS_CD = T0.ITM_TP) ITM_TP_NM
			,T0.ORD_AMT
			,TO_CHAR(ROUND(T0.ORD_AMT / T2.ORD_AMT * 100,2)) || '%' ORD_AMT_RT
	FROM    T_CUS_ITM_AMT T0
			,M_CUS T1
			,T_TTL_AMT T2
	WHERE   T1.CUS_ID = T0.CUS_ID
	ORDER BY ROUND(T0.ORD_AMT / T2.ORD_AMT * 100,2) DESC;




-- ************************************************
-- PART I - 4.3.2 SQL1
-- ************************************************

	-- 주문금액 비율 컬럼 추가
	ALTER TABLE S_CUS_YM ADD ORD_AMT_RT NUMBER(18,3);



-- ************************************************
-- PART I - 4.3.2 SQL2
-- ************************************************

	-- WITH~AS 절을 사용한 INSERT문
	INSERT INTO S_CUS_YM (BAS_YM ,CUS_ID ,ITM_TP ,ORD_QTY ,ORD_AMT ,ORD_AMT_RT)
	WITH T_CUS_ITM_AMT AS (
			SELECT  TO_CHAR(A.ORD_DT,'YYYYMM') BAS_YM ,A.CUS_ID ,C.ITM_TP
					,SUM(B.ORD_QTY) ORD_QTY ,SUM(B.ORD_QTY * B.UNT_PRC) ORD_AMT
			FROM    T_ORD A
					,T_ORD_DET B
					,M_ITM C
			WHERE   A.ORD_SEQ = B.ORD_SEQ
			AND     B.ITM_ID = C.ITM_ID
			AND     A.ORD_DT >= TO_DATE('20170401','YYYYMMDD')
			AND     A.ORD_DT < TO_DATE('20170501','YYYYMMDD')
			GROUP BY TO_CHAR(A.ORD_DT,'YYYYMM') ,A.CUS_ID ,C.ITM_TP
			)
		,T_TTL_AMT AS(
			SELECT  SUM(A.ORD_AMT) ORD_AMT
			FROM    T_CUS_ITM_AMT A
			)
	SELECT  T0.BAS_YM ,T0.CUS_ID ,T0.ITM_TP ,T0.ORD_QTY ,T0.ORD_AMT
			,ROUND(T0.ORD_AMT / T2.ORD_AMT * 100,2) ORD_AMT_RT
	FROM    T_CUS_ITM_AMT T0
			,M_CUS T1
			,T_TTL_AMT T2
	WHERE   T1.CUS_ID = T0.CUS_ID;


