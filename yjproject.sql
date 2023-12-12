conn system/123456;
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER joeun_exam IDENTIFIED BY 123456;

ALTER USER joeun_exam DEFAULT TABLESPACE users;
--3. joeun_exam 계정의 테이블스페이스 영역 할당량을 무제한으로 변경하시오.
ALTER USER joeun_exam QUOTA UNLIMITED ON users;

GRANT CONNECT, RESOURCE TO joeun_exam;

CREATE TABLE BOARD (
BOARD_NO NUMBER CONSTRAINT BOARD_PK PRIMARY KEY,
TITLE VARCHAR2(100) NOT NULL,
CONTENT VARCHAR2(2000),
WRITER VARCHAR2(20) NOT NULL,
REG_DATE DATE NOT NULL,
UPD_DATE DATE NOT NULL
);

CREATE SEQUENCE SEQ_BOARD 
INCREMENT BY 1
START WITH 1
MAXVALUE 100000
MINVALUE 1;

--7. 아래 조회 결과와 같이, board 테이블에 데이터를 추가하는 SQL 문을 작성하시오.
INSERT INTO BOARD (BOARD_NO, TITLE, CONTENT, WRITER, REG_DATE, UPD_DATE)
VALUES ('1', '제목01', '내용01', '김조은', TO_DATE('22/12/27', 'YY/MM/DD'), TO_DATE('22/12/27', 'YY,MM,DD')
);
INSERT INTO BOARD (BOARD_NO, TITLE, CONTENT, WRITER, REG_DATE, UPD_DATE)
VALUES ('2', '제목02', '내용02', '김조은', TO_DATE('22/12/27', 'YY/MM/DD'), TO_DATE('22/12/27', 'YY,MM,DD')
);
INSERT INTO BOARD (BOARD_NO, TITLE, CONTENT, WRITER, REG_DATE, UPD_DATE)
VALUES ('3', '제목03', '내용03', '김조은', SYSDATE, SYSDATE
);
--8. 8. 아래 조회 결과와 같이, board 테이블의 데이터를 수정하는 SQL 문을 작성하시오.
UPDATE BOARD 
SET TITLE='수정01', CONTENT='수정01'
WHERE BOARD_NO = 1;

UPDATE BOARD 
SET TITLE='수정02', CONTENT='수정02'
WHERE BOARD_NO = 2;

--9. board 테이블에서 작성자가 김씨 인 게시글을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM BOARD
WHERE WRITER LIKE '김%'
;

DELETE FROM BOARD
WHERE WRITER='김조은';

SELECT * FROM EMPLOYEE;
DESC EMPLOYEE;
--2. 1. 함수 “get_dept_title”을 정의하시오.
CREATE OR REPLACE FUNCTION get_dept_title(p_emp_id NUMBER)
RETURN VARCHAR2
IS 
    out_title department.dept_title%TYPE ;
BEGIN 
    SELECT  dept_title
    INTO out_title
    FROM employee e, department d
    WHERE e.dept_code = d.dept_id
    AND e.emp_id = p_emp_id;
    RETURN out_title;
END;
/

SELECT emp_name 사원명
      ,get_dept_title(emp_id) 부서명
FROM employee;

--EXECUTE pro_emp_write( '200', '제목', '내용' );
CREATE OR REPLACE PROCEDURE pro_emp_write
    (
    P_EMP_ID IN employee.emp_id%TYPE,
    P_TITLE IN VARCHAR2(100),
    P_CONTENT IN VARCHAR2(2000)
    )
IS 
    P_EMP_NAME VARCHAR2(20);
BEGIN
    SELECT EMP_NAME INTO P_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
    
    INSERT INTO BOARD (BOARD_NO, TITLE, CONTENT, WRITER, REG_DATE, UPD_DATE)
    VALUES ( 
    SEQ_BOARD.NEXTVAL,
    P_TITLE, 
    P_CONTENT,
    P_EMP_NAME,
    SYSDATE,
    SYSDATE
    );
END;
/
    
SELECT * FROM BOARD;
    
    
CREATE OR REPLACE PROCEDURE pro_emp_write 
(
    IN_EMP_ID IN employee.emp_id%TYPE,
    IN_TITLE IN VARCHAR2 DEFAULT '제목없음',
    IN_CONTENT IN VARCHAR2 DEFAULT '내용없음'
)
IS
    V_EMP_NAME employee.emp_name%TYPE;
BEGIN
    SELECT emp_name INTO V_EMP_NAME
    FROM employee
    WHERE emp_id = IN_EMP_ID;
    
    INSERT INTO board( board_no, title, writer, content, REG_DATE, UPD_DATE)
    VALUES ( SEQ_BOARD.nextval,  IN_TITLE, V_EMP_NAME, IN_CONTENT, SYSDATE, SYSDATE );

END;
/

DROP PROCEDURE pro_emp_write;

EXECUTE pro_emp_write( '200', '제목', '내용' );



















