conn system/123456;

-- 사용자 계정 생성
--c##없이 계정생성하는 방법
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER joeun_exam IDENTIFIED BY 123456;

-- 테이블 스페이스 변경
-- 해당 계정이 현재 테이블관리하는 영역안에서 어느범위까지 사용할수있는지 용량설명, 영역설정
--HR 계정의 기본 테이블 영역을 'users'영역으로 지정
ALTER USER joeun_exam DEFAULT TABLESPACE users;

-- 계정이 사용할 수 있는 용량 설정
-- HR 계정이 사용할 수 있는 용량을 무한대로 지정
ALTER USER joeun_exam QUOTA UNLIMITED ON users;

-- 계정에 권한을 부여
--HR 계정에 connect, resource 권한을 부여
GRANT connect, resource TO joeun_exam;

/*
CREATE TABLE 테이블명 (
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    ...
);
*/
CREATE TABLE BOARD (
    BOARD_NO       NUMBER    NOT NULL   PRIMARY KEY
    ,TITLE       VARCHAR2(100)  NOT NULL
    ,CONTENT     VARCHAR2(2000)  NOT NULL
    ,WRITER      VARCHAR2(20) NOT NULL   UNIQUE
    ,REG_DATE    DATE   NULL
    ,UPD_DATE    DATE    NOT NULL
);