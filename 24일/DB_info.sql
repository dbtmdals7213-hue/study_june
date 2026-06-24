/*
	MySQL DBMS 에서
    1. 사용자 계정 만들기
    2. 데이터베이스 만들기
    3. 만든 사용자 계정에 데이터베이스 사용 권한 주기
	4. 권한 정보 새로 고침
    5. 권환 정보 확인
    6. 사용자 계정 삭제
    7. 데이터베이스 백업
	8. 데이터베이스 복구
*/
# 1. 사용자 계정 만들기
/*
	springuser 라는 MySQL 사용자를 만든다.
    이 사용자는 localhost, 즉 같은 컴퓨터에서만 접속할 수 있다.
    비밀번호는 1234 로 설정한다.
*/
CREATE USER 'springuser'@'localhost' IDENTIFIED BY '1234';
-- CREATE			: 만든다
-- USER				: 사용자 계정
-- 'springuser'		: 만들 사용자 아이디
-- @				: "어디에서 접속하는 사용자냐" 를 구분
-- 'localhost'		: MySQL DBMS 소프트웨어가 설치된 서버(컴퓨터)에서만 접속 가능
-- IDENTIFIED BY	: 비밀번호를 지정한다.
-- '1234'			: 계정 비밀번호

# 1.1. 외부 접속 가능한 사용자 생성
CREATE USER 'springuser2'@'%' IDENTIFIED BY '1234';
-- '%' 모든 IP 를 사용하는 컴퓨터에서 springuser2 계정으로 MySQL 에 접속이 가능하게 한다.

# 2. 데이터베이스 생성
CREATE DATABASE springdb;

# 3. 만든 사용자 계정에 특정 데이터베이스를 사용할 권한 부여
/*
	localhost 에서 접속하는 springuser 사용자에게
    springdb 데이터베이스 안의 모든 테이블을 다룰 수 있는 모든 권한(SELECT, INSERT, DELETE, UPDATE ...)을 준다.
*/
GRANT ALL PRIVILEGES ON springdb.* TO 'springuser'@'localhost';

-- GRANT 						권한을 준다
-- ALL PRIVILEGES 				모든 권한
-- ON 							어느 대상에 대해
-- springdb.*					springdb 라는 이름의 데이터베이스 안의 모든 테이블
-- TO 							누구에게
-- 'springuser'@'localhost'		localhost 에서 접속하는 springuser 사용자 계정에게 권한 부여

# 4. 권한 적용
FLUSH PRIVILEGES;
-- FLUSH		새로고침 한다. 다시 읽는다.
-- PRIVILEGES	권한 정보

# 5. 권한 부여 확인
-- localhost 에서 접속하는 springuser 사용자에게 부여된 권한 부여
SHOW GRANTS FOR 'springuser'@'localhost';

# 6. 사용자 계정 삭제
-- localhost 에서 접속하는 springuser 계정을 삭제한다.
DROP USER 'springuser'@'localhost';

# 7. 데이터베이스 백업(명령 프롬포트에서 입력)
/*
	root 계정으로 MySQL 에 접속해서
    springdb 데이터베이스 내용을
    springdb_backup.sql 파일로 저장한다.
*/
-- mysqldump -u root -p market_db > makret_db.sql;

# 8. 데이터베이스 복구(명령 프롬포터에서 입력)
/*
	root 계정으로 MySQL에 접속해서
	springdb_backup.sql 파일 안의 SQL 명령어들을
	springdb 데이터베이스에 실행한다.
*/
-- mysql -u root -p springdb < springdb_backup.sql

































