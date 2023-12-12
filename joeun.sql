
--70. 주어진 “community.dmp” 덤프파일을 ‘joeun’ 계정에 import 하는 명령어를 작성하시오
--imp userid=관리자계정/비밀번호 file=덤프파일경로 fromuser=덤프소유계정 touser=임포트할계정
imp userid=system/123456 file=D:\cyj\SQL\community.dmp fromuser=joeun touser=joeun
--fromuser: 덤프파일 생성한 계정 --touser: 덤프파일을 넣을 계정


--71. 사용 중인 계정(‘joeun’)이 소유하고 있는 데이터를 “community2.dmp” 덤프파일로 export 하는 명령어를 작성하시오.
--exp userid=생성계정/비밀번호 file=덤프파일경로 log=로그파일경로
-- * 생성계정은 import할 때 fromuser로 쓰인다. 
exp userid=joeun/123456 file=D:\cyj\SQL\community2.dmp log=D:\cyj\SQL\community2.log
--log경로가 뭔가요? 로그가 없어도 됨. 

--72. 1) 테이블 MS_BOARD 에서 WRITER 속성을 아래 <예시>와 같이 데이터 타입을 변경하고, 테이블 MS_USER 의 USER_NO 를 참조하는 외래키를 지정하는 SQL 문을 작성하시오.
--MS_BOARD 테이블의 WRITER 속성의 타입을 NUMBER 변경하시오. 
ALTER TABLE MS_BOARD MODIFY WRITER NUMBER;

--WRITER 속성을, MS_USER 의 USER_NO를 참조하는 외래키로 지정하시오. 
--외래키 지정
--ALTER TABLE 테이블명 ADD COMSTRAINT 제약조건명
--FOREIGN KEY (외래키컬럼) REFERENCES 참조테이블(기본키);
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO);

--2) 테이블 MS_FILE 의 BOARD_NO 속성을 테이블 MS_BOARD 의 BOARD_NO 를 참조하는 외래키로 지정하는 SQL 문을 작성하시오
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

--3) 테이블 MS_REPLY 의 BOARD_NO 속성을 테이블 MS_BOARD 의 BOARD_NO 를 참조하는 외래키로 지정하는 SQL 문을 작성하시오
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

--제약조건 삭제
--ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;


--73. 테이블 MS_USER 에 아래 <예시> 과 같이 속성을 추가하는 SQL문을 작성하시오.
ALTER TABLE MS_USER ADD CTZ_NO CHAR(14) NULL UNIQUE ;
ALTER TABLE MS_USER ADD GENDER CHAR(6) NULL ;
COMMENT ON COLUMN MS_USER.CTZ_NO IS '주민번호';
COMMENT ON COLUMN MS_USER.GENDER IS '성별';
DESC MS_USER;

--74. 테이블 MS_USER 의 GENDER 속성이 (‘여‘, ‘남‘, ‘기타‘) 값을 갖도록 하는 제약조건을 추가하는 SQL 문을 작성하시오
ALTER TABLE MS_USER ADD CONSTRAINT MS_USER_GENDER_CHECK
CHECK (gender IN ('여', '남', '기타'));


--75. 테이블 MS_FILE 에 <예시> 와 같이 확장자 속성을 추가하는 SQL 문을 작성하시오.
ALTER TABLE MS_FILE ADD EXT VARCHAR2(10) NULL;
COMMENT ON COLUMN MS_FILE.EXT IS '확장자';

DESC MS_FILE;

--76. 테이블 MS_FILE 의 FILE_NAME 속성에서 확장자를 추출하여 EXT 속성에 UPDATE 하는 SQL 문을 작성하시오.
--<조건>
--- 테이블 MS_FILE 의 FILE_NO 를 기준으로 매치한다.
--- FILE NAME 에서 추출한 확장자가 jpeg, jpg, gif, png 가 아니면 삭제한다.
--- FILE_NAME 에서 추출한 확장자를 EXT 속성에 UPDATE 한다
--MERGE한다고 함. (업데이트하면서 삭제하는.... 조건에 해당하면 추가하고, 해당하지 않으면 삭제하고)
--머지는 두개이상의 데이터를 합칠 때 주로 사용함. 
MERGE INTO MS_FILE T      --대상 테이블 지정
--사용할 데이터의 자원을 지정
USING ( SELECT FILE_NO, FILE_NAME FROM MS_FILE) F
--ON (update될 조건)
ON (T.FILE_NO = F.FILE_NO)
--매치조건에 만족한 경우
WHEN MATCHED THEN
--SUBSTR(문자열, 시작번호)
    UPDATE SET T.EXT = SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1 )
    DELETE WHERE SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1 )
            NOT IN ('jpeg', 'jpg', 'gif', 'png')
--WHEN NOT MATCHED THEN
--[매치가 안 될 때, ]
;

SELECT * FROM MS_FILE;

--파일 추가
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT )
    VALUES (1,1,'강아지.png', '123', sysdate, sysdate, 'png');
    INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT )
    VALUES (2,1,'Main.fxml', '123', sysdate, sysdate, 'fxml');
--추가안되는 이유: ms보드에 행이 아예 없어서  보드넘버 1도 없음.  => 참조 무결성 위배
DESC MS_FILE;


--게시글 추가
INSERT INTO MS_BOARD( BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT, DEL_YN, DEL_DATE, REG_DATE, UPD_DATE)
VALUES(1, '제목', '내용', 1,0,0,'N', NULL, sysdate, sysdate);
--추가 안되는 이유: WRITER도 외래키인데 , USER_ID 1이 없음. 

--유저 추가
INSERT INTO MS_USER(USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER)
VALUES (1, 'JOEUN', '123456', '김조은', TO_DATE('2020/01/01', 'YYYY/MM/DD'), '010-1234-1234', '부평', sysdate, sysdate, '200101-334444', '남');

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;

--77. 테이블 MS_FILE 의 EXT 속성이 (‘jpg’, ‘jpeg’, ‘gif’, ‘png’) 값을 갖도록 하는 제약조건을 추가하는 SQL문을 작성하시오.
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_EXT_CHECK
CHECK ( EXT IN ('jpg', 'jpeg', 'gif', 'png'));
--.webp ->움짤과 투명배경과 용량낮춤을 다 가지고 있음.
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT )
    VALUES (3,1,'Main.java', '123', sysdate, sysdate, 'java');
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT )
    VALUES (4,1,'고양이.jpg', '123', sysdate, sysdate, 'jpg');
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT )
    VALUES (5,1,'제목없음', '123', sysdate, sysdate, NULL); --NULL은 check제약조건이 아닌 NOTNULL, NULL제약조건에서 실행됨.

    
--78. 아래 <예시> 에 주어진 테이블의 모든 행을 삭제하는 SQL 문을 작성하시오.
--<예시>1. [MS_USER] 테이블의 모든 행을 삭제하시오.
--2. [MS_BOARD] 테이블의 모든 행을 삭제하시오.
--3. [MS_FILE] 테이블의 모든 행을 삭제하시오.
--4. [MS_REPLY] 테이블의 모든 행을 삭제하시오.

TRUNCATE TABLE MS_USER; --Table MS_USER이(가) 잘렸습니다.
TRUNCATE TABLE MS_BOARD;
TRUNCATE TABLE MS_FILE;
TRUNCATE TABLE MS_REPLY; --밑에서부터 TRUNCATE해야 함. 
--오류: ORA-02266: 사용으로 설정된 외래 키에 의해 참조되는 테이블의 고유/기본 키
--drop은 테이블자체삭제. TRUNCATE는 그안에 있는 데이터 삭제. 

DELETE FROM MS_USER;  --얘도 TRUNCATE랑 똑같이 행이 삭제됨. 
DELETE FROM MS_BOARD;
DELETE FROM MS_FILE;
DELETE FROM MS_REPLY;

/*
    DELETE VS TRUNCATE 차이
    * DELETE - 데이터 조작어 (DML)
        -한 행 단위로 데이터를 삭제한다 (조건도 걸 수 있음)
        -COMMIT, ROLLBACK 를 이용하여 변경사항을 적용하거나 되돌릴 수 있음
        
    * TRUNCATE - 데이터 정의어 (DDL) (ALTER, CREATE 처럼 데이터 구조를 정의하는...)
        -모든 행을 삭제한다
        -삭제된 데이터를 되돌릴 수 없다
*/

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

--79. 아래 <예시> 에 주어진 테이블의 속성을 삭제하는 SQL 문을 작성하시오.
--<예시>
--1. [MS_BOARD] 테이블의 WRITER 속성을 삭제하시오.
--2. [MS_FILE] 테이블의 BOARD_NO 속성을 삭제하시오.
--3. [MS_REPLY] 테이블의 BOARD_NO 속성을 삭제하시오.

ALTER TABLE MS_BOARD DROP COLUMN WRITER;
ALTER TABLE MS_FILE DROP COLUMN BOARD_NO;
ALTER TABLE MS_REPLY DROP COLUMN BOARD_NO;


--80. <예시>에 주어진 속성들을 각 테이블에 추가한 뒤 외래키로 지정하시오. 참조 테이블에 대하여 삭제 시, 
--연결된 속성의 값도 삭제를 하는 제약조건도 추가하는 SQL 문을 작성하시오
/*1. [MS_BOARD] 테이블의 WRITER 속성을 추가하시오.
① MS_BOARD 의 WRITER 속성을 MS_USER 의 USER_NO 를 참조하는 외래키로 지정하시오.
② 참조 테이블의 데이터 삭제 시, 연쇄적으로 삭제되도록 옵션을 지정하시오.
2. [MS_FILE] 테이블의 BOARD_NO 속성을 추가하시오.
① MS_FILE 의 BOARD_NO 속성을 MS_BOARD 의 BOARD_NO 를 참조하는 외래키로 지정하시오.
② 참조 테이블의 데이터 삭제 시, 연쇄적으로 삭제되도록 옵션을 지정하시오.
3. [MS_REPLY] 테이블의 BOARD_NO 속성을 추가하시오.
① MS_REPLY 의 BOARD_NO 속성을 MS_BOARD 의 BOARD_NO 를 참조하는 외래키로 지정하시오.
② 참조 테이블의 데이터 삭제 시, 연쇄적으로 삭제되도록 옵션을 지정하시오.
*/
ALTER TABLE MS_BOARD ADD WRITER NUMBER NOT NULL;
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO)
ON DELETE CASCADE;
--ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
-- * RESTRICT : 자식 테이블의 데이터가 존재하면, 삭제 안 함
-- * CASCADE : 자식 테이블의 데이터도 함께 삭제
-- * SET NULL : 자식 테이블의 데이터를 NULL로 변경
ALTER TABLE MS_FILE ADD BOARD_NO NUMBER NOT NULL;
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

ALTER TABLE MS_REPLY ADD BOARD_NO NUMBER NOT NULL;
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

--회원 탈퇴( 회원번호:1 )
DELETE FROM MS_USER WHERE USER_NO = 1;

--ON DELETE CASCADE 옵션으로 외래키 지정 시, 
--MS_USER 데이터가 삭제하면, 
--MS_BOARD의 참조된 데이터도 연쇄적으로 삭제된다. 

--MS_USER 데이터가 삭제하면, 
--MS_FILE, MS_REPLY의 참조된 데이터도 연쇄적으로 삭제된다. 

--외래키 제약조건 정리
ALTER TABLE 테이블명
ADD CONSTRAINT 제약조건명 FOREIGN KEY (외래키 속성)
REFERENCES 참조테이블(참조 속성);

--옵션
--ON UPDATE     --참조 테이블 수정 시, 
-- * CASCADE    : 자식 데이터 수정
-- * SET NULL    : 자식 데이터는 NULL
-- * SET DEFAULT    : 자식 테이블의 기본값
-- * RESTRICT    : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION    : 아무런 행위도 하지 않는다(기본값)

--ON DELETE
-- * CASCADE    : 자식 데이터 수정
-- * SET NULL    : 자식 데이터는 NULL
-- * SET DEFAULT    : 자식 테이블의 기본값
-- * RESTRICT    : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION    : 아무런 행위도 하지 않는다(기본값)



/*
    ▶서브 쿼리(Sub Query; 하위 질의)
    : SQL 문 내부에 사용하는 SELECT문
    * 메인쿼리: 서브쿼리를 사용하는 최종적인 SELECT문
    
    *서브쿼리 종류
    -스칼라 서브쿼리 : SELECT절에서 사용하는 서브쿼리
    -인라인 뷰      : FROM절에서 사용하는 서브쿼리
    -서브 쿼리      : WHERE절에서 사용하는 서브쿼리
*/



--81. <예시> 의 테이블 구조와 출력결과를 참고하여, 스칼라 서브쿼리로 출력결과를 조회하는 SQL 문을 작성하시오.
--joeun 덤프파일 임포트

--파일임포트가 안돼서 조은계정 접속해제하고 다시 생성하고 임포트했음..
DROP USER joeun CASCADE;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER joeun IDENTIFIED BY 123456;
ALTER USER joeun DEFAULT TABLESPACE users;
ALTER USER joeun QUOTA UNLIMITED ON users;
GRANT connect, resource TO joeun;
--"joeun" 사용자에게 데이터베이스 관리자(DBA) 권한을 부여
GRANT DBA TO joeun;
imp userid=system/123456 file=D:\cyj\SQL\joeun.dmp fromuser=joeun touser=joeun --이걸 명령프롬프트에 입력

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM job;

SELECT emp_id 사원번호
    , emp_name 직원명
    , (SELECT dept_title FROM department d WHERE d.dept_id = e.dept_code) 부서명       --조회명령 안에 또 조회명령이 있음.  = 쿼리
    , (SELECT job_name FROM job j WHERE j.job_code = e.job_code) 직급명            --쿼리 안에 쿼리: 서브쿼리(하위질의)
                                                    --얘는 스칼라 서브쿼리임.
FROM employee e;  


--82. <예시> 의 테이블 구조와 출력결과를 참고하여, 인라인 뷰를 이용하여 부서별로 최고급여를 받는 직원을 조회하는 SQL 문을 작성하시오. (단, 부서코드는 DEPT_CODE, DEPT_ID 이다. 
--FROM절에서 사용하는 서브쿼리가 인라인 뷰

--1. 부서별로 최고 급여를 조회
SELECT dept_code
    ,MAX(salary) MAX_SAL
    ,MIN(salary) MIN_SAL
    ,AVG(salary) AVG_SAL
FROM employee
GROUP BY dept_code
;
--2. 부서별 최고급여 조회결과를 서브쿼리(인라인 뷰)로 지정
SELECT emp_id 사원번호
        , emp_name 직원명
        ,dept_title 부서명
        ,salary 급여
        ,max_sal 최대급여
        ,min_sal 최저급여
        ,ROUND(avg_sal,2)  평균급여
FROM employee e, department d, 
    (
    SELECT dept_code
        ,MAX(salary) MAX_SAL
        ,MIN(salary) MIN_SAL
        ,AVG(salary) AVG_SAL
    FROM employee
    GROUP BY dept_code
    ) t
WHERE e.dept_code  = d.dept_id --employee e, department d 의 교집합
--하지만 인라인뷰와의 교집합이 없음. 
    AND e.salary = t.max_sal
;

--서브쿼리는 다른 조회결과가 필요해서 사용하게 됨. 

--그룹함수: 전체를 그룹으로 지어서 맥스,민, 에버리지, 합구하는 거. 이거는 그룹바이를 씀. 


--83. <예시> 의 테이블 구조와 출력결과를 참고하여, 중첩 서브쿼리를 이용하여 직원명이 ‘이태림＇인 사원과 같은 부서의 직원들을 조회하는 SQL 문을 작성하시오
--직원명이 ‘이태림＇인 : 조건:  WHERE emp_name = '이태림' -> 부서코드를 찾아서 그걸 서브쿼리로 만들어야 함. 
--1) 직원명이 이태림인 사원의 부서코드
SELECT dept_code FROM employee WHERE emp_name = '이태림'; --부서코드를 찾음

SELECT EMP_ID 사원번호, EMP_NAME 직원명, EMAIL 이메일, PHONE 전화번호
FROM employee
WHERE dept_code = (SELECT dept_code FROM employee WHERE emp_name = '이태림');

DESC employee;
SELECT * FROM employee;
DESC department;
SELECT * FROM department;


--84. 테이블 EMPLOYEE 와 DEPARTMENT 의 DEPT_CODE 와 DEPT_ID 속성이 일치하는 행이 존재하는 경우, 테이블 DEPARTMENT 의 데이터를 조회하는 SQL 문을 작성하시오
--(즉, 사원이 존재하는 부서만 조회하시오.)
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM DEPARTMENT
--1:1인데.. IN을 사용하면 1:다로 비교할 수 있음. 
WHERE DEPT_ID IN (
                SELECT DISTINCT dept_code
                FROM employee
                WHERE dept_code IS NOT NULL)
                ORDER BY dept_id ASC
;
--사원이 있는 부서(서브쿼리)
SELECT DISTINCT dept_code
FROM employee
WHERE dept_code IS NOT NULL;


--2) 두번째 방법: EXISTS 활용
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM DEPARTMENT d
WHERE EXISTS (SELECT * 
                FROM employee e 
                WHERE e.dept_code = d.dept_id
)
ORDER BY dept_id ASC
;

SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM DEPARTMENT
WHERE EXISTS (SELECT * 
                FROM employee 
                WHERE dept_code = dept_id --이게 들어가야 하는 이유: 이런 조건에서만 true로 생각한다고 하는 거임~!!!
                --근데 나는 그냥 이런 조건이 존재하니까 그냥 전체가 true라고 생각했음. 
                --하지만 t, f를 계속해서 검증해나가는 것이었음. 
)
;


--85. 테이블 EMPLOYEE 와 DEPARTMENT 의 DEPT_CODE 와 DEPT_ID 속성이 일치하는 행이 존재하지 않는 경우, 
--테이블DEPARTMENT 의 데이터를 조회하는 SQL 문을 작성하시오
--즉, 사원이 존재하지 않는 부서를 조회하시오.
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM DEPARTMENT
WHERE DEPT_ID  NOT IN (
                SELECT DISTINCT dept_code
                FROM employee
                WHERE dept_code IS NOT NULL
                )
ORDER BY dept_id ASC
;

SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM DEPARTMENT
WHERE NOT EXISTS (SELECT * 
                FROM employee 
                WHERE dept_code = dept_id 
);

--86. 테이블 EMPLOYEE 의 DEPT_CODE 가 ‘D1’인 부서의 최대급여보다 더 큰 급여를 받는 
--사원을 조회하는 SQL 문을 작성하시오.
--서브쿼리
SELECT MAX(salary) 최대급여
FROM employee
WHERE DEPT_CODE = 'D1'
--GROUP BY  DEPT_CODE --이거 안써도 됨. 부서별로 모든 맥스값을 다 구하는게 아니라서. 
;
--메인쿼리
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서명, TO_CHAR(salary, '999,999,999') 급여, dept_title 부서명
FROM employee e, department d
WHERE salary > (SELECT MAX(salary) 최대급여
                FROM employee
                WHERE DEPT_CODE = 'D1'
                )
AND e.dept_code = d.dept_id
ORDER BY 급여
                ;

--ALL이용
--   : 모든 조건이 만족할 때, 결과를 출력하는 연산자
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서명, TO_CHAR(salary, '999,999,999') 급여, dept_title 부서명
FROM employee e, department d
WHERE salary > ALL (SELECT salary
                FROM employee
                WHERE DEPT_CODE = 'D1'
                )
AND e.dept_code = d.dept_id
ORDER BY 급여
                ;


--87. 테이블 EMPLOYEE 의 DEPT_CODE 가 ‘D9’인 부서의 최저급여보다 더 큰 급여를 받는 사원을 조회하는 SQL 문을 작성하시오.
--최저급여 구하기
SELECT MIN(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
;

SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서명, dept_title 부서명, TO_CHAR(salary, '999,999,999') 급여
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                WHERE DEPT_CODE = 'D9'
                )
;

--D9부서의 모든 사람과 비교했을 때 (합집합) 걔보다 크면 되는 방법도 있음. 
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서명, dept_title 부서명, TO_CHAR(salary, '999,999,999') 급여
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND SALARY > ANY (SELECT SALARY
                FROM EMPLOYEE
                WHERE DEPT_CODE = 'D9'
                )
                --ANY :결과 데이터 중 하나라도 비교했을 때 큰 데이터가 있으면 TRUE가 나와서 조회가 됨. 
                --   즉, 조건이 만족하는 값이 하나라도 있으면 결과를 출력하는 연산자
                --ALL: 애니랑 반대
;

--88. 테이블 EMPLOYEE 와 DEPARTMENT 를 조인하여 출력하되, 부서가 없는 직원도 포함하여 출력하는 SQL 문을 작성하시오.
SELECT  E.EMP_ID, E.EMP_NAME, NVL(D.DEPT_ID,'없음'), NVL(D.DEPT_TITLE , '없음') --NVL(값이 널이아닌경우, 값이널인경우)
FROM EMPLOYEE E LEFT JOIN DEPARTMENT D
                ON E.DEPT_CODE = D.DEPT_ID
;

--89. 테이블 EMPLOYEE 와 DEPARTMENT 를 조인하여 출력하되, 직원이 없는 부서도 포함하여 출력하는 SQL 문을 작성하시오
SELECT  NVL(E.EMP_ID,'없음'), NVL(E.EMP_NAME,'없음'),DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E RIGHT JOIN DEPARTMENT D
                ON E.DEPT_CODE = D.DEPT_ID
;

--90. 테이블 EMPLOYEE 와 DEPARTMENT 를 조인하여 출력하되, 직원 및 부서 유무에 상관없이 출력하는 SQL 문을 작성하시오
SELECT  NVL(E.EMP_ID,'없음'), NVL(E.EMP_NAME,'없음'),NVL(D.DEPT_ID,'없음'), NVL(D.DEPT_TITLE , '없음')
FROM EMPLOYEE E FULL JOIN DEPARTMENT D
                ON E.DEPT_CODE = D.DEPT_ID
;

--91. 조인을 이용하여, <예시> 와 같이 출력되는 SQL 문을 완성하시오
SELECT  NVL(E.EMP_ID,'없음') 사원명, NVL(E.EMP_NAME,'없음') 직원명 ,
        NVL(D.DEPT_ID,'없음') 부서번호 , NVL(D.DEPT_TITLE , '없음') 부서명, 
        LOCAL_NAME 지역명 , NATIONAL_NAME 국가명, SALARY 급여, HIRE_DATE 입사일자
FROM EMPLOYEE E LEFT JOIN DEPARTMENT D   ON E.DEPT_CODE = D.DEPT_ID
                LEFT JOIN LOCATION L     ON D.LOCATION_ID = L.LOCAL_CODE
                LEFT JOIN NATIONAL N     ON L.NATIONAL_CODE = N.NATIONAL_CODE
;

desc employee;
SELECT * FROM employee;
desc department;
SELECT * FROM department;
desc location;
SELECT * FROM location;
desc national;
SELECT * FROM national;
DECS JOB;
SELECT * FROM JOB;

--92. 조인을 이용하여, <예시> 와 같이 출력되는 SQL 문을 완성하시오.
--1) 
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL
;
--2) 세 테이블을 조인하여 조회
SELECT * 
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
;
--3) 조인 결과 중, EMP_ID가 매니저 사원번호인 경우만을 조회
SELECT E.EMP_ID 사원번호, E.EMP_NAME 직원명, D.DEPT_TITLE 부서명, J.JOB_NAME 직급, '매니저' 구분
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
WHERE EMP_ID IN (
                SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL
                )
;

--93. 조인을 이용하여, <예시> 와 같이 출력되는 SQL 문을 완성하시오
SELECT E.EMP_ID 사원번호, E.EMP_NAME 직원명, D.DEPT_TITLE 부서명, J.JOB_NAME 직급, '사원' 구분
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
WHERE EMP_ID NOT IN (
                SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL
                )
;

--94. 조인을 이용하여, <예시> 와 같이 출력되는 SQL 문을 완성하시오. (단, UNION 키워드를 이용하시오.)
SELECT E.EMP_ID 사원번호, E.EMP_NAME 직원명, D.DEPT_TITLE 부서명, J.JOB_NAME 직급, '매니저' 구분
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
WHERE EMP_ID IN (
                SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL
                )
UNION
SELECT E.EMP_ID 사원번호, E.EMP_NAME 직원명, D.DEPT_TITLE 부서명, J.JOB_NAME 직급, '사원' 구분
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
WHERE EMP_ID NOT IN (
                SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL
                )
;
--UNION : 테이블을 합쳐줌,. 당연히 조회하는 열은 같아야 함. 

--95. 조인을 이용하여, <예시> 와 같이 출력되는 SQL 문을 완성하시오. (단, CASE 키워드를 이용하시오.)
SELECT E.EMP_ID 사원번호, E.EMP_NAME 직원명, D.DEPT_TITLE 부서명, J.JOB_NAME 직급   
        ,CASE WHEN EMP_ID IN ( SELECT DISTINCT MANAGER_ID
                                    FROM EMPLOYEE
                                    WHERE MANAGER_ID IS NOT NULL
                                )
        THEN '매니저'
        ELSE '사원'
    END 구분
    WHEN MANAGER_ID IS NOT NULL THEN '사원'
FROM EMPLOYEE E
                LEFT JOIN DEPARTMENT D ON E.DEPT_CODE=D.DEPT_ID
                JOIN JOB J             ON E.JOB_CODE=J.JOB_CODE
;

--96. <예시> 와 같이 출력되는 SQL 문을 완성하시오

-- 주민등록번호 컬럼 (EMP_NO)

-- 1) 주민등록번호로부터 나이 구하기
--    오늘 날짜 - 생년 월일 날짜
--      i) 주민번호 뒷자리 첫글자가 1,2 이면 1900 년대생
--      ii) 주민번호 뒷자리 첫글자가 3,4 이면 2000 년대생
SELECT  emp_id 사원번호
       ,emp_name 직원명
       ,TO_CHAR(sysdate, 'YYYY') 
         - TO_NUMBER(
                CASE 
                    WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                    WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
                END
                || (SUBSTR(emp_no,1,2))
          )  나이
FROM employee
;

-- 2) 주민등록번호로부터 성별 구하기
--      i) 주민번호 뒷자리 첫글자가 1,3 이면 남자
--     ii) 주민번호 뒷자리 첫글자가 2,4 이면 여자
SELECT  emp_id 사원번호
       ,emp_name 직원명
       ,CASE 
            WHEN SUBSTR(emp_no, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(emp_no, 8, 1) IN ('2','4') THEN '여자'
        END 성별
FROM employee
;
-- 주민등록번호 뒷자리 첫글자 가져오기
SELECT SUBSTR(emp_no, 8, 1)
FROM employee;

-- 주민등록번호에서 출생연도 추출하기
-- 1985.05.04  --> 850504  --  뒷 첫 1,2 
-- 2002.10.06  --> 021006  --  뒷 첫 3,4
SELECT emp_name,
      CASE 
            -- 1900년대 출생
            WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
            -- 2000년대 출생
            WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
      END || SUBSTR(emp_no, 1, 2) 출생연도        -- 85, 02
      -- 1985, 2002
FROM employee;

-- 현재연도 구하기
SELECT TO_CHAR(sysdate, 'YYYY') 현재연도
FROM dual;

-- 나이 구하기
-- → 현재연도 - 출생연도 + 1 = 나이
SELECT emp_name,
      TO_CHAR(sysdate, 'YYYY')  -- 2023
      -
      ( CASE 
            -- 1900년대 출생
            WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
            -- 2000년대 출생
            WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
      END || SUBSTR(emp_no, 1, 2) ) -- 85, 02
      -- 1985, 2002
      + 1 나이        
FROM employee;

-- 전체
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,CASE
            WHEN emp_id IN (
                              SELECT DISTINCT manager_id
                              FROM employee
                              WHERE manager_id IS NOT NULL
                           )
            THEN '매니저'
            ELSE '사원'
        END 구분
      ,CASE 
            WHEN SUBSTR(emp_no, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(emp_no, 8, 1) IN ('2','4') THEN '여자'
        END 성별
      ,TO_CHAR(sysdate, 'YYYY') 
       - TO_NUMBER(
            CASE 
                WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
            END
            || (SUBSTR(emp_no,1,2))
          )  나이
          , TRUNC ( MONTHS_BETWEEN( SYSDATE, TO_DATE(
                            CASE 
                                WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                                WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
                            END
                                || ( SUBSTR(EMP_NO,1,6) ) )
                 ) /12 
         ) 만나이
          , RPAD( SUBSTR(EMP_NO, 1,8) ,14, '*') 주민번호
FROM employee e
     LEFT JOIN department d ON e.dept_code = D.dept_id
     JOIN job J USING(job_code)
;
--USING : 조인하고자 하는 두 테이블의 컬럼명이 같으면, ON 키워드 대신 조인 조건을 간단하게 작성하는 키워드

--만 나이 
SELECT EMP_NAME
        , TRUNC ( MONTHS_BETWEEN( SYSDATE, TO_DATE(
                            CASE 
                                WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                                WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
                            END
                                || ( SUBSTR(EMP_NO,1,6) ) )
                 ) /12 
         ) 만나이
FROM EMPLOYEE;

-- 97.
-- 96번 조회결과에 
-- 순번, 만나이, 근속연수, 입사일자, 연봉을 추가하시오.
-- ROWNUM : 행번호
SELECT ROWNUM 순번
      ,e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,CASE
            WHEN emp_id IN (
                              SELECT DISTINCT manager_id
                              FROM employee
                              WHERE manager_id IS NOT NULL
                           )
            THEN '매니저'
            ELSE '사원'
        END 구분
      ,CASE 
            WHEN SUBSTR(emp_no, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(emp_no, 8, 1) IN ('2','4') THEN '여자'
        END 성별
      ,TO_CHAR(sysdate, 'YYYY') 
       - TO_NUMBER(
            CASE 
                WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
            END
            || (SUBSTR(emp_no,1,2))
          )  나이
      ,TRUNC (MONTHS_BETWEEN( sysdate, TO_DATE(
                                    CASE 
                                          WHEN SUBSTR(emp_no, 8, 1) IN ('1','2') THEN '19'
                                          WHEN SUBSTR(emp_no, 8, 1) IN ('3','4') THEN '20'
                                    END || SUBSTR(emp_no, 1, 6) 
                                 )
                     ) / 12 ) 만나이
      -- 근속연수 : 현재일자 - 입사일자 [연도]
      ,TRUNC(MONTHS_BETWEEN(sysdate, hire_date) / 12) 근속연수

      ,RPAD( SUBSTR( emp_no, 1, 8 ), 14, '*') 주민등록번호

      ,TO_CHAR( hire_date, 'YYYY.MM.DD') 입사일자

      -- 연봉 : (급여 + (급여*보너스)) * 12
      , TO_CHAR( (salary + NVL(salary*bonus, 0)) * 12, '999,999,999,999' ) 연봉

FROM employee e
     LEFT JOIN department d ON e.dept_code = d.dept_id
     JOIN job J USING(job_code)
;

--
SELECT *
FROM USER_TABLES
WHERE TABLE_NAME LIKE '%EMP%'
;

--뷰 생성하기
--사원, 부서 테이블 조인한 결과를 뷰로 생성
--1. 사원, 부서 테이블 조인
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_ID, D.DEPT_TITLE
FROM EMPLOYEE E LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

--2. 뷰로 생성
CREATE VIEW V_EMP_DEPT AS
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_ID, D.DEPT_TITLE
FROM EMPLOYEE E LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
;

--3. 뷰 조회
SELECT * FROM V_EMP_DEPT;

--4. 뷰 삭제
DROP VIEW V_EMP_DEPT;








