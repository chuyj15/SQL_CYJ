-- 커서 실행 단축키 : ctrl + enter
--문서 전체 실행: F5
SELECT 1+1
FROM dual;

--1. 계정 접속 명령어
--conn/계정명/비밀번호;
conn system/123456;

--2. SQL은 대/소문자 구분이 없다.
--명령어 키워드 대문자, 식별자는 소문자 주로 사용한다. (각자 스타일대로)
SELECT user_id, username
FROM all_users
-- WHERE username = 'HR'    : HR 계정이 있는지 확인
;

-- 사용자 계정 생성
--11g 버전 이하: 어떤 이름으로도 계정 생성 가능
--12C 버전 이상: 'c##'접두어를 붙여서 계정을 생성하도록 정책을 정함 (common의 약자)
--c##없이 계정생성하는 방법
--     ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; --명령어 먼저 실행하면 됨. 
--       이걸 안쓰면 ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다.
--       65096. 00000 -  "invalid common user or role name" 오류 발생
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER HR IDENTIFIED BY 123456;


-- 테이블 스페이스 변경
-- 해당 계정이 현재 테이블관리하는 영역안에서 어느범위까지 사용할수있는지 용량설명, 영역설정
-- ALTER USER 계정명 DEFAULT TABLESPACE users;
--HR 계정의 기본 테이블 영역을 'users'영역으로 지정
ALTER USER HR DEFAULT TABLESPACE users;

-- 계정이 사용할 수 있는 용량 설정
-- HR 계정이 사용할 수 있는 용량을 무한대로 지정
-- ALTER USER 계정명 QUOTA UNLIMITED ON users;
ALTER USER HR QUOTA UNLIMITED ON users;

-- 계정에 권한을 부여
--GRANT 권한명1, 권한명2 TO 계정명;
--HR 계정에 connect, resource 권한을 부여
GRANT connect, resource TO HR;

--기본계정생성
--HR계정을 생성하고, 기본 설정 후 권한 부여
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER HR IDENTIFIED BY 123456;
ALTER USER HR DEFAULT TABLESPACE users;
ALTER USER HR QUOTA UNLIMITED ON users;
GRANT connect, resource TO HR;

-- *계정 삭제
-- DROP USER 계정명 [CASCADE];
--HR계정 삭제
DROP USER HR [CASCADE];

--*계정 잠금 해제
-- ALTER USER 계정명 ACCOUNT UNLOCK;
ALTER USER HR ACCOUNT UNLOCK;

--HR 샘플 스키마(데이터) 가져오기
--1. SQL PLUS 
--2. HR 계정을 접속
--3. 명령어 입력
--@[경로]/hr_main.sql
--  @ : 오라클이 설치된 기본 경로
-- @?/demo/schema/human_resources/\HR_main.sql
--4. 123456 [비밀번호]
--5. users [tablespace]
--6. temp [temp tablespace] --임시테이블스페이스
--7. [log 경로] - @?/demo/schema/log



--3. 
--테이블 EMPLOYEES 의 테이블 구조를 조회하는 SQL문을 작성하시오.
DESC employees;

-- 사원테이블의 사원번호와 이름을 조회
SELECT employee_id, first_name
FROM employees;

--4. 테이블 EMPLOYEES 이 <예시>와 같이 출력되도록 조회하는 SQL 문을 작성하시오.
--한글 별칭을 부여하여 조회
--*띄어쓰기가 없으면, 따옴표 생략가능
--*AS도 생략가능
--만약 employee_id AS 사원 번호 (X)
--      employee_id AS "사원 번호" (0)
--      employee_id 사원번호 (0)
--AS (alias) : 출력되는 컬럼명에 별명을 짓는 명령어
SELECT employee_id AS "사원 번호"           --띄어쓰기가 있으면 ""로 표기
        , first_name AS 이름
        , last_name AS 성
        , email AS 이메일
        , phone_number AS 전화번호
        , hire_date AS 입사일자
        , salary AS 급여
FROM employees
;

--
SELECT *            --(*) [에스터리크] : 모든 컬럼 지정
FROM employees
;

--5. 테이블 EMPLOYEES 의 JOB_ID를 중복된 데이터를 제거하고 조회하는 SQL 문을 작성하시오.
--DISTINCT 라는 명령어를 사용함. 
-- DISTINCT 컬럼명: 중복된 데이터를 제거하고 조회하는 키워드
SELECT DISTINCT job_id FROM employees;


--6. 테이블 EMPLOYEES 의 SALARY(급여)가 6000을 초과하는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
--WHERE 조건: 조회 조건을 작성하는 구문
SELECT * FROM employees
WHERE salary >6000;

--7. 테이블 EMPLOYEES 의 SALARY(급여)가 10000인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees
WHERE salary = 10000;       --sql에서의 비교연산은 = 하나만 사용함

--8. 테이블 EMPLOYEES 의 모든 속성들을 SALARY 를 기준으로 내림차순 정렬하고, FIRST_NAME 을 기준으로 오름차순 정렬
--   하여 조회하는 SQL 문을 작성하시오.
-- 정렬 명령어 : ORDER BY 컬럼명 [ASC/DESC];
--생략해서 쓰면 기본은 오름차순
SELECT * FROM employees ORDER BY salary DESC, first_name ASC;

--9. 테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. 
-- 컬럼안의 값을 지정할 때는 ''을 씀. 그리고 대문자로 지정되어있음. 
-- 명령어가 대소문자 구분이 없는거지 안에 들어있는 값은 구분해야 함. 
--OR 연산 : ~또는, ~이거나
--WHERE A OR B
SELECT * FROM employees 
WHERE job_id = 'FI_ACCOUNT' OR job_id = 'IT_PROG';

--10. 테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. 
--<조건> IN 키워드를 사용하여 SQL 쿼리를 완성하시오.
-- * 컬럼명 IN ('A', 'B')   : OR 연산을 대체하여 사용할 수 있는 키워드
SELECT * FROM employees 
WHERE job_id IN ('FI_ACCOUNT', 'IT_PROG') ;

--11. 테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 아닌 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- <조건> IN 키워드를 사용하여 SQL 쿼리를 완성하시오.
-- * 컬럼명 NOT IN ('A', 'B')   : OR 연산을 대체하여 사용할 수 있는 키워드
SELECT * FROM employees 
WHERE job_id NOT IN ('FI_ACCOUNT', 'IT_PROG') ;

--12. 테이블 EMPLOYEES 의 JOB_ID가 ‘IT_PROG’ 이면서 SALARY 가 6000 이상인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오
--조건연산: ~이면서, 그리고, 동시에
--WHERE A AND B;
SELECT * FROM employees WHERE job_id = 'IT_PROG' AND salary >=6000;

--13. 테이블 EMPLOYEES 의 FIRST_NAME 이 ‘S’로 시작하는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
--WHERE first_name LIKE 'S%'
-- LIKE  : 컬럼명 LIKE '와일드카드';
-- % 여러글자를 대체
-- _ 한 글자를 대체
SELECT * FROM employees WHERE first_name LIKE 'S%';

--14. 테이블 EMPLOYEES 의 FIRST_NAME 이 ‘s’로 끝나는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE first_name LIKE '%s';

--15. 테이블 EMPLOYEES 의 FIRST_NAME 에 소문자‘s’가 포함되는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE first_name LIKE '%s%';

--16. 테이블 EMPLOYEES 의 FIRST_NAME 이 5글자인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE first_name LIKE '_____';
--아니면 함수를 이용할 수 있음.
SELECT * FROM employees WHERE LENGTH(first_name) =5;

--17. 테이블 EMPLOYEES 의 COMMISSION_PCT가 NULL 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
-- COMMISSION_PCT:성과급 비율
-- WHERE commition_pst =NULL; : 사실 =는 값을 비교하는건데, NULL은 값이 아니므로 비교 불가. 
--IS NULL이라는 키워드로 비교함. 
SELECT * FROM employees WHERE commission_pct IS NULL;

--18. 테이블 EMPLOYEES 의 COMMISSION_PCT가 NULL이 아닌 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE commission_pct IS NOT NULL;

--19. 테이블 EMPLOYEES 의 사원의 HIRE_DATE가 04년 이상인 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE hire_date >=  '04/01/01'; --SQL developer가 문자형 데이터를 날짜형 데이터로 자동 변환
                            --DATE타입        CHAR타입
--TO_DATE() : 문자형식을 날짜형 데이터로 변환하는 함수
SELECT * FROM employees WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD');
                            --DATE타입        DATE타입
                            
                            
--20. 테이블 EMPLOYEES 의 사원의 HIRE_DATE가 04년도부터 05년도인 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT * FROM employees WHERE hire_date >= '04/01/01' AND hire_date < '06/01/01';
SELECT * FROM employees WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD')
                            AND hire_date <= TO_DATE('20051231', 'YYYYMMDD')
;
SELECT * FROM employees WHERE hire_date BETWEEN  '04/01/01' AND '05/12/31';
SELECT * FROM employees WHERE hire_date BETWEEN TO_DATE('20040101', 'YYYYMMDD') AND TO_DATE('20051231', 'YYYYMMDD')
;

--21. 12.45, -12.45 보다 크거나 같은 정수 중 제일 작은 수를 계산하는 SQL 문을 각각 작성하시오.
--- 결과 : 13, -12
--자바에서는 ceil, floor이었음. 
SELECT CEIL(12.45) FROM dual ;
SELECT CEIL(-12.45) FROM dual;
SELECT CEIL(12.44), CEIL(-12.45) FROM dual;
--dual: 산술 연산, 함수 결과 등을 확인해볼 수 있는 임시 테이블
--CEIL : "천장"
-- : 지정한 값보다 크거나 같은 정수 중 제일 작은 수를 반환하는 함수

--22. 12.55와 -12.55 보다 작거나 같은 정수 중 가장 큰 수를 계산하는 SQL 문을 각각 작성하시오.
--- 결과 : 13, -12
SELECT FLOOR(12.55) FROM dual;
SELECT FLOOR(-12.55) FROM dual;
SELECT FLOOR(12.55), FLOOR(-12.55) FROM dual;
---FLOOR() :"바닥" : 지정한 값보다 작거나 같은 정수 중 가장 큰 수를 반환하는 함수 

--23. 각 소문제에 제시된 수와 자리 수를 이용하여 반올림하는 SQL문을 작성하시오.
-- 0.54 를 소수점 아래 첫째 자리에서 반올림하시오. → 결과 : 1
-- 0.54 를 소수점 아래 둘째 자리에서 반올림하시오. → 결과 : 0.5
-- 125.67 을 일의 자리에서 반올림하시오. → 결과 : 130
-- 125.67 을 십의 자리에서 반올림하시오. → 결과 : 120
--ROUND(값, 자리수)
--: 지정한 값을, 해당 자리수에서 반올림하는 함수
-- a a a a a.bbbb
--...  -1 -2 0123
SELECT ROUND(0.54, 0) FROM dual;
SELECT ROUND(0.54, 1) FROM dual;
SELECT ROUND(125.67, -1) FROM dual;
SELECT ROUND(125.67, -2) FROM dual;

--24. 각 소문제에 제시된 두 수를 이용하여 나머지를 구하는 SQL문을 작성하시오.
--- 3을 8로 나눈 나머지를 구하시오. → 결과 : 3
--- 30을 4로 나눈 나머지를 구하시오. → 결과 : 2
--MOD(A,B) 
-- : A를 B로 나눈 나머지를 구하는 함수
SELECT MOD(3,8) FROM dual;
SELECT MOD(30, 4) FROM dual;

--25. 각 소문제에 제시된 두 수를 이용하여 제곱수를 구하는 SQL문을 작성하시오.
--- 2의 10제곱을 구하시오. → 결과 : 1024
SELECT POWER(2,10) FROM dual;
--- 2의 31제곱을 구하시오. → 결과 : 2147483648
SELECT POWER(2, 31) FROM dual;
--POWER(A, B): A의 B제곱을 구하는 함수


--26. 각 소문제에 제시된 수를 이용하여 제곱근을 구하는 SQL문을 작성하시오.
--- 2의 제곱근을 구하시오. → 결과 : 1.41421...
--- 100의 제곱근을 구하시오. → 결과 : 10
SELECT SQRT(2) FROM dual;
SELECT SQRT(100) FROM dual;
--SQRY(A): A의 제곱근을 구하는 함수
-- *A는 양의 정수와 실수만 사용 가능

--27. 각 소문제에 제시된 수와 자리 수를 이용하여 해당 수를 절삭하는 SQL문을 작성하시오.
--- 527425.1234 을 소수점 아래 첫째 자리에서 절삭하시오.
--- 527425.1234 을 소수점 아래 둘째 자리에서 절삭하시오.
--- 527425.1234 을 일의 자리에서 절삭하시오.
--- 527425.1234 을 십의 자리에서 절삭하시오.
SELECT TRUNC(527425.1234, 0) FROM dual;
SELECT TRUNC(527425.1234, 1) FROM dual;
SELECT TRUNC(527425.1234, -1) FROM dual;
SELECT TRUNC(527425.1234, -2) FROM dual;
--TRUNC(값, 자리수) : 지정한 값을 해당 자리수에서 절삭하는 함수

--28. 각 소문제에 제시된 수를 이용하여 절댓값을 구하는 SQL문을 작성하시오.
--    -20 의 절댓값을 구하시오.
--    -12.456 의 절댓값을 구하시오.
SELECT ABS(-20) FROM dual;
SELECT ABS(-12.456) FROM dual;
--ABS(A) : 값 A의 절댓값을 구하여 반환하는 함수

--29. <예시>와 같이 문자열을 대문자, 소문자, 첫글자만 대문자로 변환하는 SQL문을 작성하시오.
--원문 대문자 소문자 첫글자만 대문자
--AlOhA WoRlD~!  ->  ALOHA WORLD~! aloha world~! Aloha World~!
--자바에서는 //toUpperCase() : 대문자로 변환
SELECT UPPER('AlOhA WoRlD~!') FROM dual;
SELECT LOWER('AlOhA WoRlD~!') FROM dual;
SELECT INITCAP('AlOhA woRlD~!') FROM dual;
--UPPER(): 모두 대문자로 변환
--LOWWER(): 모두 소문자로 변환
--INITCAP(): 첫글자만 대문자, 나머지는 소문자로 변환

--30. <예시>와 같이 문자열의 글자 수와 바이트 수를 출력하는 SQL문을 작성하시오.
-- ‘ALOHA WORLD’
--문자열 : ‘알로하 월드’
-- LENGTH('문자열') : 글자 수
-- LENGTH('문자열') : 바이트 수
-- : * 영문, 숫자, 빈칸: 1 byte
-- : * 한글: 3 byte
SELECT LENGTH('ALOHA WORLD') AS "글자 수" FROM dual;
SELECT LENGTHB('ALOHA WORLD') AS "바이트 수" FROM dual;
SELECT LENGTH('알로하 월드') AS "글자 수" FROM dual;
SELECT LENGTHB('알로하 월드') AS "바이트 수" FROM dual;

--31. <예시>와 같이 각각 함수와 기호를 이용하여 두 문자열을 병합하여 출력하는 SQL문을 작성하시오.
SELECT CONCAT( CONCAT('ALOHA', 'WORLD'), '안뇽') AS "함수" FROM dual;
SELECT 'ALOHA'||'WORLD'||'안뇽' AS "기호" FROM dual; --여러개 연결의 경우 기호가 더 편리하네
--CONCAT(A, B) : 
--|| :

--32. <예시>와 같이 주어진 문자열의 일부만 출력하는 SQL문을 작성하시오.
-- - 문자열 : ‘www.alohacampus.com’
-- - 문자열 : ‘www.알로하캠퍼스.com’
SELECT SUBSTR( 'www.alohacampus.com', 1,3) AS "1" , SUBSTR('www.alohacampus.com', 5, 11) AS "2" , SUBSTR('www.alohacampus.com', -3, 3) AS "3" FROM dual;
SELECT SUBSTR( 'www.알로하캠퍼스.com', 1,3) AS "1" , SUBSTR('www.알로하캠퍼스.com', 5, 6) AS "2" , SUBSTR('www.알로하캠퍼스.com', -3, 3) AS "3" FROM dual;
--SUBSTR(문자열, 시작번호(1~), 글자수) : 
-- 뒤에서부터 세고 싶을경우 맨끝글자를 -1로 생각함. 
SELECT SUBSTRB( 'www.alohacampus.com', 1,3) AS "1" , SUBSTRB('www.alohacampus.com', 5, 11) AS "2" , SUBSTRB('www.alohacampus.com', -3, 3) AS "3" FROM dual;
SELECT SUBSTRB( 'www.알로하캠퍼스.com', 1,3) AS "1" , SUBSTRB('www.알로하캠퍼스.com', 5, 6*3) AS "2" , SUBSTRB('www.알로하캠퍼스.com', -3, 3) AS "3" FROM dual;
--SUBSTRB(문자열, 시작번호(1~), 글자수) :  바이트단위로 셈.

--33. <예시>와 같이 문자열에서 특정 문자의 위치를 구하는 SQL문을 작성하시오.
-- - 문자열 : ‘ALOHACAMPUS’
SELECT INSTR('ALOHACAMPUS', 'CAMPUS', 1, 1) FROM dual;
SELECT INSTR('ALOHACAMPUS', 'A', 1, 2) FROM dual;
SELECT INSTR('ALOHACAMPUS', 'A', 1, 3) FROM dual;
--INSTR(문자열, 찾을문자, 시작번호(몇번째글자부터찾을건지), 순서)

--34. <예시>와 같이 대상 문자열을 왼쪽/오른쪽에 출력하고 빈공간을 특정 문자로 채우는 SQL문을 작성하시오.
--- 문자열: ‘ALOHACAMPUS’
--- 문자 : ‘#’
SELECT LPAD('ALOHACAMPUS', 20, '#') FROM dual; --#########ALOHACAMPUS
SELECT RPAD('ALOHACAMPUS', 20, '#') FROM dual;
--LPAD(왼쪽에 패드를 만들어서 넣어준다는 뜻) : 문자열에 지정한 칸을 확보하고, 왼쪽에 특정문자로 채움
-- : LPAD(문자열, 바이트수, 빈공간의 값(채울문자))
--RPAD(문자열, 바이트수, 빈공간의 값(채울문자))
SELECT LPAD('알로하CAMPUS', 20, '#') FROM dual; --########알로하CAMPUS
SELECT RPAD('알로하CAMPUS', 20, '#') FROM dual;

--35. 테이블 EMPLOYEES 의 FIRST_NAME과 HIRE_DATE 를 검색하되 <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
--      날짜형 --(형변환)--> 2003-06-17 (화) 12:00:00 문자형
SELECT first_name AS 이름 , hire_date , TO_CHAR(hire_date, 'YYYY-MM-DD (dy) HH:MI:SS') AS 입사일자
FROM employees;
--TO_CHAR(데이터, '날짜/숫자 형식')
-- : 특정 데이터를 문자열 형식으로 변환하는 함수


--36. 테이블 EMPLOYEES 의 FIRST_NAME과 SALARY 를 검색하되 <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- 숫자형 -> 문자형 변환
SELECT first_name AS 이름 , 
TO_CHAR(salary, '$999,999,999.00')  AS 급여 
FROM employees; 
-- 9: 유효숫자 대체(값이 있으면 표시, 없으면 표시안함)
-- 0: 값이 존재하든 안존재하든 무조건 출력함


--37. <예시> 와 같이 문자형으로 주어진 데이터를 날짜형 데이터로 변환하는 SQL 문을 작성하시오.
-- 20220712  --> 22/07/12
SELECT TO_DATE('20220712', 'YY/MM/DD') FROM dual;
SELECT 20230822 AS 문자
    , TO_DATE('20230822', 'YYYYMMDD') AS 날짜1
    , TO_DATE('20230822', 'YYYY-MM-DD') AS 날짜2 
    , TO_DATE('2023.08.22', 'YYYY-MM-DD') AS 날짜3 
--    , TO_DATE('2023-08-22', 'YYYYMMDD') AS 날짜4 --오류: 지정한 월이 부적합합니다.
    FROM dual;
--TO_DATE(데이터) : 문자형 데이터를 날짜형 데이터로 변환하는 함수
-- 해당 문자형 데이터를 날짜형으로 분석할 수 있는 형식을 지정해야 함. 


--38. <예시> 와 같이 문자형으로 주어진 데이터를 숫자형 데이터로 변환하는 SQL 문을 작성하시오.
--     1,200,000 -->  1200000
SELECT '1,200,000' AS 문자
, TO_NUMBER('1,200,000', '999,999,999') AS 숫자 FROM dual;
--TO_NUMBER(데이터, 형식) : 문자형 데이터를 숫자형 데이터로 변환하는 함수


--39. <예시>와 같이 현재 날짜를 반환하는 SQL 문을 작성하시오.
SELECT sysdate 오늘
, sysdate -1 어제 
FROM dual;
-- sysdate : 현재 날짜, 시간 정보를 가지고 있는 키워드
-- 어제를 구하고싶어 sysdate-1 // 오늘은 sysdate+1

--40. <예시> 와 같이 입사일자와 오늘 날짜를 계산하여 근무달수와 근속연수를 구하는 SQL 문을 작성하시오.
-- MONTHS_BETWEEN(A, B) : 날짜 A부터 B까지 개월 수 차이를 반환하는 함수
-- (단, A>B, 즉 A가 더 최근 날짜로 지정되어야 양수로 반환)
SELECT first_name AS 이름
, TO_CHAR(hire_date, 'YYYY.MM.DD') AS 입사일자
, TO_CHAR(sysdate, 'YYYY.MM.DD') AS 오늘
, TRUNC(sysdate - hire_date, 0) AS 근무일수
, TRUNC ( MONTHS_BETWEEN(sysdate, hire_date) ) || '개월' AS 근무달수
,   TRUNC(MONTHS_BETWEEN(sysdate, hire_date)  /12) || '년' AS 근속연수
FROM employees;


--41. <예시> 와 같이 오늘 날짜와 6개월 후의 날짜를 출력하는 SQL 문을 작성하시오.
SELECT ADD_MONTHS(sysdate, 6) "6개월 후" FROM dual;
SELECT ADD_MONTHS('2023-07-25', 6) 종강 FROM dual;
--ADD_MONTHS(날짜, 개월 수) : 지정한 날짜로부터 해당 개월 수 후의 날짜를 반환하는 함수

--42. <예시> 와 같이 오늘 날짜와 오늘 이후 돌아오는 토요일의 날짜를 출력하는 SQL 문을 작성하시오.
SELECT next_day(sysdate, 7) "다음 토요일"
, NEXT_DAY(sysdate, 1) "다음 일요일"
, NEXT_DAY(sysdate, 2) "다음 월요일"
, NEXT_DAY(sysdate, 3) "다음 화"
, NEXT_DAY(sysdate, 4) "다음 수"
, NEXT_DAY(sysdate, 5) "다음 목"
, NEXT_DAY(sysdate, 6) "다음 금"
FROM dual;
--NEXT_DAY(날짜, 요일) : 지정한 날짜 이후 돌아오는 요일을 반환하는 함수
-- * 요일(일1~토7)

--43. <예시> 와 같이 오늘 날짜와 월초, 월말 일자를 구하는 SQL 문을 작성하시오.
SELECT sysdate 오늘
,TRUNC(sysdate, 'MM') 월초
, LAST_DAY( sysdate ) 월말
FROM dual;
--LAST_DAY(날짜) : 지정한 날짜와 동일한 월의 월말 일자를 반환하는 함수
--날짜 : xxxxx.yyyyyy : 1970.1.1 0시0분0초0ms부터 세서 2023.8.22로 변환해서 보게 됨. 
--지난 일자를 정수로 계산, 시간정보는 소수부분으로 계산
--xxxx.yyyy 날짜 데이터를 월 단위로 절삭하면, 월초를 구할 수 있다. 


--44. 테이블 EMPLOYEES 의 COMMISSION_PCT 를 중복없이 검색하되, NULL 이면 0으로 조회하고 내림차순으로 정렬하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
SELECT DISTINCT NVL(commission_pct, 0) "커미션(%)"
FROM employees 
ORDER BY  "커미션(%)"  DESC ;  --조회한 컬럼의 별칭으로 ORDER BY 절에서 사용할 수 있다. ex) "커미션(%)"
--좀 이상하게 오류나는 이유: 오더바이는 커미션퍼센트를 모름. ㅠㅠㅠ ㅠ그러니까 실행순서를 잘 봐야 함. 
--NVL(값, 대체할 값) : 해당 값이 null이면 지정된 값으로 변환하는 함수
--          "Null Value Logic"의 약자


--45. 테이블 EMPLOYEES 의 FIRST_NAME, SALARY, COMMISSION_PCT 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오.
SELECT first_name AS 이름
, salary AS 급여
, NVL( commission_pct, 0)  AS 커미션
, salary + salary * NVL( commission_pct, 0) AS 최종급여
FROM employees 
ORDER BY 최종급여 DESC;
--NULL을 연산하면 그 결과값도 NULL이 됨. 

SELECT first_name AS 이름
, salary AS 급여
, NVL( commission_pct, 0)  AS 커미션
, NVL2( commission_pct, salary+ salary*commission_pct , salary ) AS 최종급여
FROM employees 
ORDER BY 최종급여 DESC;
--NVL2(값, NULL아닐 때 값, NULL일 때 값)


--46. 테이블 EMPLOYEES 의 FIRST_NAME, DEPARTMENT_ID 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오.
--<조건>- DECODE 함수를 이용하시오.
--- 부서명은 HR 계정의 DEPARTMENTS 테이블을 참조하시오.
SELECT * FROM employees;
SELECT * FROM departments;
SELECT first_name 이름
, DECODE(department_id, 10, 'Administration'
                    , 20, 'Marketing'
                    , 30, 'Purchasing'
                    , 40, 'Human Resources'
                    , 50, 'Shipping'
                    , 60, 'IT'
                    , 70, 'Public Relations'
                    , 80, 'Sales'
                    , 90, 'Executive'
                    , 100,  'Finance'
        ) 부서
FROM employees;
--en"code" 암호화 decode 복호화
-- DEPARTMENT_ID : 코드  ex) 10---> Administration (decode)
--DECODE(컬럼명, 조건값1, 반환값1, 조건값2, 반환값2, ...)
-- : 지정한 컬럼의 값이 조건값에 일치하면 바로 뒤의 반환값을 출력하는 함수


--47. 테이블 EMPLOYEES 의 FIRST_NAME, DEPARTMENT_ID 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오.
--<조건>- CASE 함수를 이용하시오.
--- 부서명은 HR 계정의 DEPARTMENTS 테이블을 참조하시오.
SELECT first_name 이름
, CASE WHEN department_id = 10 THEN 'Administration' 
       WHEN department_id = 20 THEN 'Marketing' 
       WHEN department_id = 30 THEN 'Purchasing'
       WHEN department_id = 40 THEN 'Human Resources' 
       WHEN department_id = 50 THEN 'Shipping'
       WHEN department_id = 60 THEN 'IT' 
       WHEN department_id = 70 THEN 'Public Relations' 
       WHEN department_id = 80 THEN 'Sales' 
       WHEN department_id = 90 THEN 'Executive'
       WHEN department_id = 100 THEN 'Finance' 
       END 부서
FROM employees;
--CASE문
--     : 조건식을 만족할 때, 출력할 값을 지정하는 구문
-- WHEN 조건식1 THEN 반환값1 
-- WHEN 조건식2 THEN 반환값2 
-- WHEN 조건식3 THEN 반환값3          --ctrl+shift+D하면 한줄복사
--END 


--48. 다음 <예시> 와 같이 테이블 EMPLOYEES 의 사원 수를 구하는 SQL 문을 작성하시오.
SELECT COUNT(*) 사원수
FROM employees;
SELECT COUNT(*) 사원수
        ,COUNT(commission_pct) 커미션받는사원수
       ,COUNT(department_id) 부서가있는사원수
FROM employees;
--COUNT(*)
--COUNT( 컬럼명 ) : 컬럼을 지정하여 NULL을 제외한 데이터 개수를 반환하는 함수
--NULL이 없는 데이터라면 어떤 칼럼을 지정하더라도 개수가 같기 때문에, 일반적으로 COUNT(*)로 개수를 구한다.

--49. 다음 <예시> 와 같이 테이블 EMPLOYEES 의 최고급여, 최저급여를 구하는 SQL 문을 작성하시오.
SELECT MAX(salary) 최고급여
    , MIN(salary) 최저급여
FROM employees;
--MAX()
--MIN()

--50. 다음 <예시> 와 같이 테이블 EMPLOYEES 의 급여합계, 급여평균을 구하는 SQL 문을 작성하시오.
SELECT SUM(salary) 급여합계
    , ROUND( AVG(salary) ) 급여평균
FROM employees;
--SUM()
--AVG()

--51. 다음 <예시> 와 같이 테이블 EMPLOYEES 의 급여표준편자와 급여분산을 구하는 SQL 문을 작성하시오.
SELECT ROUND( STDDEV(salary),2 ) 급여표준편차
        , ROUND( VARIANCE(salary),2 ) 급여분산
FROM employees;
--standard deviation
--STDDEV()
--VARIANCE()

--52. 아래 <예시>의 TABLE 기술서를 참고하여 MS_STUDENT 테이블을 생성하는 SQL 문을 작성하시오.
-- * 테이블 생성
/*
CREATE TABLE 테이블명 (
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    컬럼명1    타입   [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
    ...
);
*/
CREATE TABLE MS_STUDENT (
    ST_NO       NUMBER                      NOT NULL        PRIMARY KEY
    ,NAME       VARCHAR2(20)                NOT NULL
    ,CTZ_NO     CHAR(14)                    NOT NULL
    ,EMAIL      VARCHAR2(100)               NOT NULL       UNIQUE
    ,ADDRESS    VARCHAR2(1000)                  NULL
    ,DEPT_NO    NUMBER                          NOT NULL
    ,MJ_NO      NUMBER                          NOT NULL
    ,REG_DATE   DATE            DEFAULT sysdate    NOT NULL
    ,UPD_DATE   DATE            DEFAULT sysdate    NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음'    NOT NULL
);
COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.CTZ_NO IS '주민등록번호';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.DEPT_NO IS '학부번호';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

DROP TABLE ms_student;

--53. 아래 <예시> 를 참고하여 MS_STUDENT 테이블에 속성을 추가하는 SQL 문을 작성하시오.
--테이블에 속성 추가
--ALTER TABLE 테이블명 ADD 컬럼명 타입 DEFAULT 기본값 [NOT NULL];
ALTER TABLE MS_STUDENT ADD GENDER CHAR(6) DEFAULT '기타' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';
ALTER TABLE MS_STUDENT ADD STATUS VARCHAR2(10) DEFAULT '대기' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';
ALTER TABLE MS_STUDENT ADD ADM_DATE DATE NULL;
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';
ALTER TABLE MS_STUDENT ADD GRD_DATE DATE NULL;
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';

DESC MS_STUDENT;

--테이블 속성 삭제
--ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE MS_STUDENT DROP COLUMN GENDER;
ALTER TABLE MS_STUDENT DROP COLUMN STATUS;
ALTER TABLE MS_STUDENT DROP COLUMN ADM_DATE;
ALTER TABLE MS_STUDENT DROP COLUMN GRD_DATE;


--54. 아래 <예시> 를 참고하여 MS_STUDENT 테이블의 주민번호 속성을 생년월일 속성으로 수정하는 SQL 문을 작성하시오.
ALTER TABLE MS_STUDENT RENAME COLUMN CTZ_NO TO BIRTH;
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE;
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';

--속성 변경 - 타입 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE;
--속성 변경 - NULL 여부 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH NOT NULL;
--속성 변경 - DEFAULT 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH DEFAULT sysdate;

--동시에 적용 가능
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE  DEFAULT sysdate NOT NULL;


--55. 아래 <예시> 를 참고하여 MS_STUDENT 테이블의 학부번호 속성을 삭제하는 SQL 문을 작성하시오.
ALTER TABLE MS_STUDENT DROP COLUMN DEPT_NO;


--56. MS_STUDENT 테이블을 삭제하는 SQL 문을 작성하시오.
DROP TABLE MS_STUDENT ;

--57. 아래 <예시>의 TABLE 기술서를 참고하여 MS_STUDENT 테이블을 생성하는 SQL 문을 작성하시오.
CREATE TABLE MS_STUDENT (
     ST_NO      NUMBER          NOT NULL   PRIMARY KEY
    ,NAME       VARCHAR2(20)    NOT NULL
    ,BIRTH      DATE            NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL UNIQUE
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,MJ_NO      VARCHAR2(10)          NOT NULL
    ,GENDER     CHAR(6)         DEFAULT '기타'    NOT NULL
    ,STATUS     VARCHAR2(10)    DEFAULT '대기'    NOT NULL
    ,ADM_DATE   DATE    NULL
    ,GRD_DATE   DATE    NULL
    ,REG_DATE   DATE    DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE    DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
);

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';

COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';

COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

--58. 아래 <예시> 를 참고하여 MS_STUDENT 테이블에 데이터를 삽입하는 SQL 문을 작성하시오.
INSERT INTO MS_STUDENT (ST_NO,NAME,BIRTH,EMAIL,ADDRESS,MJ_NO,GENDER,STATUS,ADM_DATE,GRD_DATE,REG_DATE,UPD_DATE,ETC)
VALUES ('20180001', '최서아', '991005', 'csa@univ.ac.kr', '서울', 'I01', '여', '재학', '2018/03/01', NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210001', '박서준', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'psj@univ.ac.kr', '서울', 'B02',
         '남', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210002', '김아윤', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'kay@univ.ac.kr', '인천', 'S01',
         '여', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20160001', '정수안', TO_DATE('1997/02/10', 'YYYY/MM/DD'), 'jsa@univ.ac.kr', '경남', 'J01',
         '여', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20150010', '윤도현', TO_DATE('1996/03/11', 'YYYY/MM/DD'), 'ydh@univ.ac.kr', '제주', 'K01',
         '남', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20130007', '안아람', TO_DATE('1994/11/24', 'YYYY/MM/DD'), 'aar@univ.ac.kr', '경기', 'Y01',
         '여', '재학', TO_DATE('2013/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, '영상예술 특기자' );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20110002', '한성호', TO_DATE('1992/10/07', 'YYYY/MM/DD'), 'hsh@univ.ac.kr', '서울', 'E03',
         '남', '재학', TO_DATE('2015/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

SELECT * FROM MS_STUDENT;

--59. 아래 <예시> 를 참고하여 MS_STUDENT 테이블에 데이터를 수정하는 SQL 문을 작성하시오.
--MS_STUDENT 테이블의 데이터를 수정
/*
UPDATE 테이블명
SET 칼럼1 = 변경할 값,
    칼럼2 = 변경할 값,
    ...
WHERE 조건;  --update랑 set은 세트로 나와야해서 where이 중간에 들어가면 안됨. 
*/
UPDATE MS_STUDENT
WHERE NAME='정수안'
SET 주소='서울'
,재적='휴학'
;

UPDATE MS_STUDENT
SET address='서울'
,status='휴학'
WHERE st_no='20160001'
;
--(2)
UPDATE MS_STUDENT
SET status = '졸업'
,address='서울'
, grd_date  = '20200220'
, upd_date = sysdate
, etc = '수석'
WHERE st_no = '20150010';
--(3)
UPDATE MS_STUDENT
SET status = '졸업'
, grd_date  = '20200220'
, upd_date = sysdate
WHERE st_no = '20130007';
--(4)
UPDATE MS_STUDENT
SET status = '퇴학'
, upd_date = sysdate
, etc = '자진 퇴학'
WHERE st_no = '20110002';

--60. 아래 <예시> 를 참고하여 MS_STUDENT 테이블에 데이터를 삭제하는 SQL 문을 작성하시오.
DELETE FROM MS_STUDENT
WHERE st_no = '20110002';


--61. 아래 <예시> 를 참고하여 MS_STUDENT 테이블의 모든 속성을 조회하는 SQL 문을 작성하시오.
SELECT * FROM ms_student;

--62. MS_STUDENT 테이블의 모든 속성을 조회하여 MS_STUDENT_BACK 테이블을 생성하는 SQL 문을 작성하시오.
CREATE TABLE ms_student_back
AS SELECT * FROM ms_student;

--63. MS_STUDENT 테이블의 튜플을 삭제하는 SQL 문을 작성하시오.
DELETE FROM ms_student;  --6개 행 이(가) 삭제되었습니다.

--64. MS_STUDENT_BACK 테이블의 모든 속성을 조회하여 MS_STUDENT 테이블에 삽입하는 SQL 문을 작성하시오.
INSERT INTO ms_student
SELECT * FROM ms_student_back;


--65. MS_STUDENT 테이블의 성별 속성이 (‘여’, ‘남‘, ‘기타‘ ) 값만 입력가능하도록 하는 제약조건을 추가하시오.
ALTER TABLE ms_student
ADD CONSTRAINT ms_std_gender_check
CHECK (gender IN ('여', '남', '기타'));

UPDATE ms_student
SET gender = '여';

SELECT * FROM ms_student;
--CHECK 제약 조건
--지정한 값이 아닌 다른 값을 입력/수정하는 경우
--"체크 제약 조건(HR.MS_STD_GENDER_CHECK)이 위배되었습니다" 에러 발생

--제약 조건 3개
--기본키 (PRIMARY KEY)
-- : 중복 불가, NULL 불가(필수 입력)
-- * 해당 타입의 데이터를 고유하게 구분할 수 있는 속성으로 지정

--고유키(UNIQUE)
-- : 중복 불가, NULL 허용
-- * 중복되지 않아야 할 데이터(ID, 주민번호, 이메일, ...)




--66. 아래 <예시>의 TABLE 기술서를 참고하여 MS_USER 테이블을 생성하는 SQL 문을 작성하시오.


--67. 아래 <예시>의 TABLE 기술서를 참고하여 MS_BOARD 테이블을 생성하는 SQL 문을 작성하시오.



--68. 아래 <예시>의 TABLE 기술서를 참고하여 MS_FILE 테이블을 생성하는 SQL 문을 작성하시오.



--69. 아래 <예시>의 TABLE 기술서를 참고하여 MS_REPLY 테이블을 생성하는 SQL 문을 작성하시오.
