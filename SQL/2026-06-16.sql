
-- 한 줄 주석

# 한 줄 주석

/*
	여러 줄 주석
    여러 줄 주석
*/

-- 현재 MySQL DBMS 서버에 만들어져 있는 데이터베이스 목록 보기 명령
show databases;

-- 사용 할 데이터베이스 선택 명렁
-- 작성 문법: use 사용 할 데이터베이스명;
use world;

/*
	특정 테이블에 저장된 모든 열의 데이터들을 조회(검색)

	문법
		select 조회할데이터가_저장된_열명1, 열명2, 열명3
        from 조회할_테이블명;
        
	문법
		select *
        from 조회할_테이블명;
        
	문법	
		select *
        from 조회할_테이블명
        where 조건값이_저장된_열명 = 조건값;
        
	요약: member 테이블(표)에 저장된 member_ide, member_addr 열 세로 방향의 각 칸에 저장된 값 조회
*/
--  풀이: member 테이블에 저장된 데이터들 중에서
--  	 member_id열 방향(세로방향)에 저장된 데이터와
--  	 member_addr열 방향(세로방향)에 저장된 데이터들만 모두 조회
        select member_id, member_addr
		from member;

-- 풀이: member 테이블에 저장된 모든 열의 데이터들 조회
		select *
        from member;
        
-- 풀이: member_name_열 방향(세로 방향)에 저장된 이름들 중에서 "아이유"가 저장된 행 위치의 모든 열의 값 조회
-- 요약: 이름이 아이유인 회원의 모든 열 데이터 조회
		select *
        from member
        where member_name = '아이유';
-- 맛보기 끝
        
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	개체(객체) ? 데이터로 표현하고자 하는 데이터베이스의 구성요소
    
    개체 종류: 테이블, 인덱스, 뷰, 스토어드프로시저, 트리거, 함수, 커서 등...

	1. 인덱스(index)
    - 데이터베이스 테이블에 저장된 데이터의 검색 속도를 향상시키기 위한 개체
*/
-- 인덱스 개체를 생성해서 사용하지 않고 
-- member 테이블에 저장되어 있는 이름이 아이유인 한 사람의 정보 조회
select * from member
where member_name='아이유';

/*
	인덱스 객체 만들기 문법
		create index 생성할인덱스개체명 ON 테이블명(열명);
*/
-- member 테이블의 member_name 열에 대한 빠른속도로 데이터를 조회 하기 위해 인덱스 개체를 생성하자.
create index idx_member_name on member(member_name);
        
-- 인덱스 개체를 idx_member_name 을 생성하고 나서
-- member 테이블에 저장되어 있는 이름이 아이유인 한 사람의 정보를 조회
select * from member
where member_name = '아이유';
        
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	뷰 개체: 가상의 테이블(가짜 테이블)
    
    뷰 개체 생성 문법
    
		create view  생성할뷰명
        as select * from 조회할_실제_테이블명;
*/        
-- member 테이블에 저장된 모든 열 정보 조회
select * from member;

-- member 테이블과 연결되는 회원 뷰 개체(member_view) 생성
create view member_view
as select * from member;

-- member 테이블 명이 아닌 ~ 회원뷰 개체(member_view)명으로
-- member 테이블의 정보를 조회 할 수있다.
select * from member_view;

-- 조회 시 테이블을 사용하지 않고 굳이 뷰를 사용하여 조회한 이유는?
-- 1. member 테이블을 조작하면 데이터가 변경되거나 삭제 될 수 있어 보안에 좋지 않음
--    그래서 뷰명으로 조회 하면 member테이블을 직접 만져서 조회하지 않기 때문에 보안에 좋음
-- 2. 긴 조회 select SQL 문을 간략하게 만들 수도 있다.

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	스토어드 프로시저 개체: 개체 프로그램 코드를 묶어 놓은 함수와 같은 개체
*/
-- 회원테이블(member)에 저장된 데이터들 중에서 member_name 열에 저장된 값이 '나훈아'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회
select * from member where member_name = '나훈아';

-- 상품테이블(product)에 저장된 데이터들 중에서 product_name 열에 저장된 값이 '삼각김밥' 인
-- 행 에 관한 모든 열의 해당되는 값들을 조회
select * from product where product_name = '삼각김밥';

/*
	스토어드 프로시저 개체 생성 문법
    
			DELIMITER //
			CREATE PROCEDURE 생성할스토어드프로시저명() 
			BEGIN
				프로그래밍할 SQL문장;
				프로그래밍할 SQL문장; ...
			END //
			DELIMITER ;
            
		참고. 위 첫 행과 마지막 행에 구분 문자라는 의미의 DELIMITER // 와
			 DELIMITER; 문을 작성하였는데...
             일단 이것은 스토어드 프로시저를 만들기 위해 묶어 주는 약속의 문법이라고 생각하면 됩니다.
*/
-- 위 두 SELECT 문을 하나의 기능인 스토어드 프로시저 개체로 만들어보겠습니다.
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
	select * from member where member_name = '나훈아';
	select * from product where product_name = '삼각김밥';
END //
DELIMITER ;

-- 바로 위에서 만든 myProc라는 이름의 스토어드 프로시저 개체를 호출해서 실행하기 위한 문법
-- CALL 호출할프로시저명();
CALL myProc();
CALL myProc();
CALL myProc();

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 주제: 기본 조회문 SELECT ~ FROM 절 배우기
/*
	USE 문
    - SELECT 문으로 테이블에 저장된 데이터를 조회하기 전에 ~
      먼저 사용할 데이터베이스를 선택할때 이용하는 예약어.
      
	- 사용 문법
		USE 사용할데이터베이스명;
*/
use market_db;

/*
	SELECT 문?
		- 특정 테이블 표에 저장되어 있는 데이터를 조회하여 가져올 때 사용되는 SQL 구문.
        
	SELECT 문 전체 작성 문법
    
		SELECT 조회할_데이터가_저장되어있는_열명
        FROM 조회할_데이터가_저장되어있는_테이블명
        WHERE 조건열명 = 조건값
        GROUP BY 그룹으로_묶을_데이터들이_저장된_열명
        HAVING 조건식
        ORDER BY 정렬할_데이터가_저장된_열명 ASC 또는 DESC
        LIMIT 숫자;

	------------------------------------------------------------------------------
    
		SELECT 핵심 문법1.
        
			SELECT 조회할_데이터가_저장되어있는_열명
			FROM 조회할_데이터가_저장되어있는_테이블명
			WHERE 조건열명 = 조건값;
*/
-- 실습 0. member 테이블에 저장된 모든 열의 값 조회
select mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date
from member;

-- select -> 테이블에서 데이터를 조회해서 가져올 때 사용되는 예약어.
-- * -> 조회해 올 데이터가 저장된 모든 열명.
-- from -> 테이블에서 데이터를 조회해 온다는 의미의 예약어.
-- member -> 조회할 데이터가 저장된 테이블명.
select *
from member;
-- 풀어서 해석하면? member 테이블에 저장된 모든 열의 데이터들을 조회해서 가져오라~ 의미

-- 실습1. 회원테이블(member)에 그룹이름이 저장된 mem_name열의 데이터들만 조회
-- 작성 문법
-- 		select 조회할_데이터가_저장된_열명 from 조회할_테이블명;
select mem_name from member;

-- 실습2. 회원테이블(member)에 주소 addr, 입사년도 debut_date, 그룹이름 mem_name 열의 데이터들만 조회
select addr, debut_date, mem_name from member;

-- 실습3. 회원테이블(member)에 조회할 열명 대신 별칭을 지어서 조회된 결과창에 보여주기 위해서는
-- 		 아래의 문법을 사용하자.
-- 		 select 조회할_열명1 as 별칭명1, 조회할_열명2 as 별칭명2
-- 		 from 조회할테이블명;
-- 또는
-- 		 select 조회할_열명1 별칭명1, 조회할_열명2 별칭명2
-- 		 from 조회할테이블명;
select addr as "주소", debut_date as "데뷔일자", mem_name "그룹명" from member;

-- 실습4. 회원테이블(member)에서 회원그룹 이름(mem_name)이
-- 		 '블랙핑크'가 저장되어 있는 위치의 행이 있는 모든 열의 데이터를 조회
-- 		 요약: 회원그룹 이름이 '블랙핑크'인 모든 열의 값들 조회!

-- 문법
-- 		select 조회할데이터가저장된_열명
-- 		from 조회할_테이블명
-- 		where 조건에서_사용할_데이터들이_저장된_열명 = 비교할_조건값;

select *
from member
where mem_name = '블랙핑크';

-- 실습5. member 테이블에서 회원그룹인원(mem_number 열의 데이터)이 4명인 그룹의 모든 열의 데이터 조회
select *
from member
where mem_number = 4;

-- 실습6. 관계(비교) 연산자 기호 <=	, >=, <, >, =
--  	 member 테이블에서 회원 그룹 평균 키들 중에서
--   	 데이터가 162이상인 회원 그룹의 아이디들, 회원 그룹명들 조회

select mem_id, mem_name from member
where height >= 162;

-- 실습7-1. 관계(비교) 연산자 기호 <=	, >=, <, >, =
--  	   논리 연산자 기호 AND, OR

-- member 테이블에서 회원 그룹 평균키(height 열에 저장된 데이터들)가 165이상이면서!
-- 그룹인원(mem_number 열에 저장된 데이터들)이 6명 초과한 회원 그룹의
-- 회원그룹명(mem_name 열에 저장된 데이터들),
-- 그룹평균키(height 열에 저장된 데이터들),
-- 그룹인원(mem_number 열에 저장된 데이터들) 조회!!!
select mem_name, height, mem_number from member
where height >= 165 and mem_number > 6;

-- member 테이블에서 회원그룹 평균 키가 165이상이거나 또는 ~ 그룹 인원이 6명 초과인 회원그룹의?
-- 회원그룹명, 회원평균키, 회원그룹인원수 조회!!!
select mem_name, height, mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 7-1-1. BETWEEN AND절 미사용한 경우
-- 회원그룹의 평균키가 163이상이면서 165이하인 회원그룹의 그룹명, 평균키, 그룹인원수 조회!!!
select mem_name, height, mem_number from member
where height >= 163 and height <= 165;

/*
BETWEEN AND 절 작성 문법 
		
	select 열명 from 테이블명
    where 비교할_값들이_저장된_열명 between 범위의최솟값 and 범위의최댓값;
*/
-- 실습 7-1-2. BETWEEN AND 절 사용한 경우
-- 회원그룹의 평균키가 163이상이면서 165이하인 회원그룹의 그룹명, 평균키, 그룹인원수 조회!!!
select mem_name, height, mem_number from member
where height between 163 and 165;

-- 실습 8. 회원그룹의 평균키가 165이상이거나 또는 그룹인원이 6명 초과인
-- 		  회원그룹들의 그룹명, 그룹평균키, 그룹인원수 조회!!!
select mem_name, height, mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 8-1. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
-- 		IN() 절을 사용하지 않고 조회!!!
select mem_name, addr from member
where addr = "경기" or addr = "전남" or addr = "경남";

-- 실습 8-2. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 한 곳이라도 해당되는 그룹의 이름, 주소 조회!!!
-- 		IN() 절을 사용해 조회!!!
-- 		문법
-- 			where 비교할_데이터가_저장된_열명 IN('비교할값1', '비교할값2', '비교할값3');
select mem_name, addr from member
where addr in('경기', '전남', '경남');

/*
	Like
    - 문자열 데이터의 일부 글자가 옆의 데이터로 포함되어 있는 행에 대한 열의 값 조회하는 예약어.
	  예를들어 회원 그룹명의 첫 글자가 '우' 문자로 시작하는 단어를 포함하는 데이터가 저장된
      행에 관한 열의 데이터를 조회할 수 있습니다.
	- 문법
			where 비교할_데이터_저장된_열명 LIKE '문자%';
*/
-- 실습9. member 테이블에서 회원그룹명 중에서 '우' 문자로 시작하는 단어가 포함된 데이터가 있으면
-- 		 그 행에 관한 모든 열의 데이터들 조회!!!
select * from member
where mem_name like '우%';

-- 실습9-1. LIKE 절에 _언더바 기호 사용 가능
-- 	member 테이블에서 회원그룹명 중에서 앞 두글자는 상관없고 뒷 단어가 '핑크'인
-- 	회원그룹의 이름이 저장되어 있으면? 이름이 저장된 행에 관한 모든 열의 데이터를 조회
select * from member
where mem_name like '__핑크';

-- 실습 9-2 LIKE 절에 %단어% 사용
-- 	member 테이블에서 회원그룹명 중에서 '마' 단어가 포함하고 있는 그룹명이 저장되어 있으면?
-- 	그 그룹의 행에 관한 모든 열의 데이터를 조회!!!
select * from member
where mem_name like '%마%';

-- 실습 9-2-1. LIKE 절에 '%단어' 사용
-- 	member 테이블에서 회원그룹명 중에서 '친구' 단어로 끝나는 그룹명이 저장되어 있으면?
-- 그 해당 그룹의 행에 관한 모든 열의 데이터 조회!!!
select * from member
where mem_name like '%친구';

/*
	서브 쿼리 구문
		- 안쪽 SELECT 구문을 이용하여 조회한 결과 데이터들을
		  바깥쪽 SELECT 구문을 이용하여 다시 조회하는 전체 구문을 말함.
          
		- 문법
			SELECT * FROM 테이블명
            WHERE 조건열명 > (SELECT * FROM 테이블명
							WHERE 조건열명 = 조건열의 값들과 비교할 값);
*/
-- 실습 10-1. 서브쿼리를 사용하지 않고 두개의 SELECT 문장을 사용한 예
-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다 ~ 큰 ~ 그룹회원의 그룹이름과 그룹평균키 조회하고 싶다.
-- 순서1. 일단 에이핑크 그룹의 평균키 164 조회 해오자
	select height from member where mem_name = '에이핑크';
    
-- 순서2. 에이핑크 그룹의 평균키는 순서1. 에서 조회했으므로 164입니다.
-- 		 where 조건절의 조건값 자리에 164를 대입해서 164 보다 큰 ~ 그룹의 이름과 평균키를 조회하면 된다.
select mem_name, height from member
where height > 164;

-- 실습 10-2. 서브쿼리 사용
-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다 ~ 큰 ~ 그룹회원의 그룹이름과 그룹평균키 조회하고 싶다.
select mem_name, height from member
where height > (select height from member 
				where mem_name = '에이핑크');
-- ----------------------------------------------------------------------------------------------------------------------
-- 연습문제
-- 1번. 회원테이블에서 모든 회원의 ID와 그룹이름을 조회해라.
	select mem_id, mem_name from member;
-- 2번. 회원테이블에서 그룹회원의 평균키가 167이상인 그룹회원의 모든 열의 정보 조회해라.
	select * from member 
    where height >= 167;
-- 3번. 회원테이블에서 그룹인원수가 5명 이하인 그룹의 이름과 인원수를 조회해라.
	select mem_name, mem_number from member 
    where mem_number <= 5;
-- 4번. 구매테이블(buy)에서 상품가격이 100이상인 구매한 상품의 이름과 가격을 조회해라.
	select prod_name, price from buy 
    where price >= 100;
-- 5번. 회원테이블에서 주소가 '경기'인 회원그룹의 모든 열 정보를 조회해라.
	select * from member 
    where addr = '경기';
-- 6번. 구매 테이블(buy)에서 '패션' 분류의 상품 이름과 구매수량을 조회해라.
	select prod_name, amount from buy 
    where group_name = '패션';
-- 7번. 회원 테이블에서 '서울'에 사는 그룹회원 이름과 전화번호(국번, 뒷번호 모두 포함)해서 조회해라.
	select mem_name, phone1, phone2 from member 
    where addr = '서울';
-- 8번. 회원 테이블에서 그룹명이 '트와이스'인 그룹 회원의 모든 열정보 조회해라.
	select * from member 
    where mem_name = '트와이스';
-- 9번. '블랙핑크'라는 이름을 가진 그룹회원이 구매한 모든 제품의 정보(모든열값)를 조회 하시오.
-- 서브쿼리 사용!
	select * from buy 
    where mem_id = (select mem_id from member 
					where mem_name = '블랙핑크');
-- 10번. 회원테이블에서 그룹 인원수가 8명인 그룹의 모든 열정보를 조회해라.   
	select * from member 
    where mem_number = 8;
-- 11번. 구매테이블에서 구매한 상품이름에 '지갑' 단어가 포함된 상품의 모든 열 정보를 조회해라.
	select * from buy 
    where prod_name like '%지갑%';
-- 12번. 회원 테이블에서 평균키가 165cm 이하인 그룹의 이름과 평균키를 조회해라.
	select mem_name, height from member 
    where height <= 165;
-- 13번. 회원 테이블에서 '여자친구' 또는 '트와이스' 그룹이 가진 모든 열 정보를 조회해라.
	select * from member 
    where mem_name in('여자친구', '트와이스');
-- 14번. 구매 테이블에서 구매한 제품 수량이 3이상인 구매한 그룹의 그룹아이디, 상품의 이름과 가격을 조회해라.
	select mem_id, prod_name, price from buy 
    where amount >= 3;
-- 15번. 회원 테이블에서 사는지역이 '강남'인 회원의 이름과 주소를 조회해라. -> 조회 X: 사는지역이 강남인 회원 정보가 없음.
	select mem_name, addr from member 
    where addr = '강남';
-- 16번. 구매 테이블에서 '디지털' 분류의 상품 중 가격이 200 이하인 구매한_상품의_이름을 조회해라.
	select prod_name from buy 
    where group_name = '디지털' and price <= 200;
-- 17번. 회원 테이블에서 그룹 평균키가 162cm이상인 그룹의 이름을 조회해라.
	select mem_name from member 
    where height >= 162;
-- 18번. 구매 테이블에서 특정그룹('블랙핑크')의 구매 내역에서
--   	 가격이 50이상인 구매한_상품의_모든열 정보 조회해라.
-- 서브쿼리 ~~~
	select * from buy 
    where price >=50 and mem_id = (select mem_id from member 
								   where mem_name = '블랙핑크');
/*
	먼저 member 테이블에 저장된 블랙핑크 그룹을 식별할 mem_id 열 값을 조회 ! 'BNK'
    select mem_id from member
    where mem_name = '블랙핑크' ---> 'BNK'
*/

-- -------------------------------------------------------------------------------------------------------------------------------------------------------
-- 03-2 절 조금 더 깊게 알아보는 SELECT 문 2026.06.15(월)
-- -------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	ORDER BY 절
		- 최종 조회 시 특정 열의 값을 기준으로 해서 내림차순 또는 오름차순 정렬해서
          조회하는 예약어
		- 문법
			SELECT * FROM 조회할테이블명
            WHERE 조건식
            ORDER BY 정렬할_데이터가_저장된_열명 ASC 또는 DESC;
            
		- 참고. 
			ASC -> Ascending 의 약자로 오름차순 정렬을 의미.
            DESC -> Descending 의 약자로 내림차순 정렬을 의미.
*/
select * from member;
-- 실습1. 그룹회원의 데뷔일자(debut_date 열에 저장된 날짜들)를 기준으로
-- 		 오름차순 정렬(데뷔일자가 빠른 날짜순)하여 조회 ORDER BY 절을 사용합니다.
select * from member
order by debut_date asc;

-- 실습2. 그룹회원의 데뷔일자(debut_date 열에 저장된 날짜들)를 기준으로
-- 		 내림차순 정렬(데뷔일자가 늦은 날짜순)하여 조회 ORDER BY 절을 사용합니다.
select * from member
order by debut_date desc;

-- 실습3. ORDER BY 절과 WHERE 조건절 함께 사용하기
-- 그룹평균키(height 열에 저장된 데이터들)가 164 이상인 그룹회원들의 키가 큰 순서대로(내림차순) 정렬해서
-- 그룹명(mem_name 열에 저장된 데이터들),
-- 그룹아이디(mem_id 열에 저장된 데이터들),
-- 그룹평균키(height 열에 저장된 데이터들),
-- 데뷔날짜(debut_date 열제 저장된 데이터들) 조회!
select mem_name, mem_id, height, debut_date from member
where height >= 164
order by height desc;

-- 실습4. ORDER BY 절과 WHERE 조건절 함께 사용하기2
-- 		 (정렬 조건 하나 이상 설정가능)
-- 그룹평균키(height 열에 저장된 데이터들)가 큰(네림차순) 순서대로 조회하되,
-- 같은 평균키를 가진 그룹들이 있으면, 데뷔일자가 빠른 순서대로(오름차순) 최종 정렬해서 조회!
select mem_name, mem_id, height, debut_date from member
where height >= 164
order by height desc, debut_date asc;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- LIMIT 예약어: 테이블 저장된 전체 행(row, 레코드) 중에서
-- 			    원하는 행의 갯수를 정해서 조회할 때 사용하는 예약어.
/*
	문법
		SELECT * FROM 조회할_테이블명
        WHERE 조건식
        ORDER BY 정렬_기준_데이터가_저장된_열명 ASC 또는 DESC
        LIMIT 조회할_행의_개수를 숫자로 작성;
*/
-- 실습5. member 테이블에서 전체 행 데이터(레코드)들 중에서 3개의 행만 잘라서 조회
select * from member
limit 3; -- 0, 3 같은 의미로
		 -- index 행 개수
		 -- 0 index 행 번호 위치의 조회될 행부터 시작해서 3개의 행을 잘라서 최종 조회해 옴.
-- LIMIT 조회할 행의 index 위치 번호, 몇 개의 행을 조회할건지 행 개수;

-- 실습6. member 테이블에서 회원그룹평균키가 큰 순(desc)으로 정렬해서 조회하되,
-- 		 정렬해서 조회한 결과 데이터들 중에서
-- 		 3 index 위치 행의 레코드 2개의 행(레코드)만 잘라서 조회!
select * from member
order by height desc
limit 3, 2;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- DISTINCT 예약어: 조회할 열의 데이터들이 중복되서 같은 이름의 데이터로 조회되면?
-- 				   중복된 데이터를 1개만 남기고 1개로만 조회시키는 예약어.
-- 				   요약: 중복된 열의 데이터가 저장되어 있으면 하나로 조회하는 예약어.
/*
	문법
		SELECT DISTINCT 조회할열명
        FROM 조회할테이블명
        WHERE 조건식
        ORDER BY 정렬기준데이터의_열명 정렬방식
        LIMIT 숫자;
*/
-- 실습8. 모든 그룹회원의 사는 지역 조회
select addr, mem_name
from member;
-- 실습8-1. ORDER BY 절을 사용해 같은 지역에 사는 주소들을 기준으로 오름차순 정렬해 조회
select addr, mem_name
from member
order by addr asc;

-- 실습8-2. DISTINCT 사용해서 열에 중복된 데이터를 하나로 통일해서 하나의 데이터만 조회
select distinct addr
from member
order by addr asc; 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
/*
	GROUP BY 절
		- GROUP BY 절은 데이터베이스에서 데이터를 그룹으로 묶어서 조회하는데 사용되는 예약어.
        - 예를 들어, 같은 날짜에 해당하는 데이터들을 하나의 그룹으로 묶어 관리할 수 있다.
        - GROUP BY 절은 보통 SUM, COUNT, AVG 같은 집계함수와 함께 작성해서 사용해야 합니다.
        - 예를 들어, 각 카테고리 별로 판매량의 합계를 구할 때 사용합니다.
        - 문법
			SELECT 열명1, 집계함수명(열명2)
            FROM 조회할테이블명
            GROUP BY 그룹으로_묶을_같은데이터가_저장된_열명
			HAVING 조건식
            ORDER BY 정렬기준열명 정렬방식
            LIMIT 숫자;
            
		-- 제공해주는 집계함수들
		-- SUM(): 열명을 SUM(열명) 로 지정하면 열에 저장된 데이터들을 합계를 계산하여 반환해줍니다.
		-- AVG(): 열명을 AVG(열명) 로 지정하면 열에 저장된 데이터들을 평균을 구하여 반환해줍니다.
		-- MIN(): 열명을 MIN(열명) 로 지정하면 열에 저장된 데이터들 중에서 최소 작은 데이터를 반환해줍니다.
		-- MAX(): 열명을 MAX(열명) 로 지정하면 열에 저장된 데이터들 중에서 가장 큰 최대 데이터를 반환해줍니다.
		-- COUNT(*): 모든 열에 관한 행 개수 반환해줍니다.
		-- COUNT(DISTINCT): 행의 개수를 셉니다.(중복된 데이터 1개만 인정)
*/
select * from buy;
-- 실습9. 
-- 'buy' 테이블에서 각 mem_id(구매한 그룹회원 아이디) 별로 총 구매 수량을 계산해서
-- 계산한 총 구매 수량과 각 회원 그룹아이디 같이 조회

-- 순서1. 각 회원 그룹단위로 한 번 상품 구매시 구매한 수량 조회
select mem_id as '그룹아이디', amount as '한 번 구매시 구매한 수량'
from buy;
-- 순서2. 각 회원 그룹아이디 단위로 묶어서 한 번만 조회된 그룹아이디로 표시하되
-- 		 (group by 그룹으로_묶을_같은데이터가_저장된_열명) 을 이용해서
-- 		 그룹아이디 단위로 조회되게 묶어서 조회시키자

-- 순서3. group by mem_id; 를 끝에 작성해
-- 		 mem_id 열에 세로 방향으로 저장된 아이디를 하나의 그룹으로 묶어서 하나만 조회되게 시켜보자
select mem_id as '그룹아이디'
from buy
group by mem_id; -- <--- 이 한줄을 추가하니 아래의 조회 결과가 달라졌다.

-- 순서4. 'buy' 테이블에서 각 mem_id(그룹회원 아이디) 별로 총 구매 수량을 계산해서
-- 		 계산한 총 구매수량과 같이 조회하기 위해 추가! 
-- 		 이때 SUM 이라는 집계함수를 작성하여 amount 열에 조회되는 모든 행 위치의 열값들을 추출해
-- 		 + 모두 합계한 회원그룹 아이디 별 총 구매 수량을 조회하면 같이 보여줄 수 있음.
select mem_id as '그룹아이디', sum(amount) as '총_구매수량'
from buy
group by mem_id;

-- 실습11. 전체 회원그룹이 구매한 총 구매 수량의 평균을 구해서 조회한 결과를 보여주자.
select avg(amount) as '전체 회원 그룹들이 구매한 상품 수량의 평균' from buy;

-- 실습12. 각~ 회원그룹들이 한 번 구매시 몇 개의 상품을 각각 구매했는지 평균 구매 개수 조회
-- 참고. 각~ 회원 그룹들을 식별할 유일한 고유값 mem_id 열에 저장된 그룹 id 를 그룹으로 묶어주자
select mem_id as '회원 그룹 아이디', avg(amount) as '평균 구매 개수'
from buy
group by mem_id;

-- 실습13. member 테이블에 저장된 그룹회원의 전체 행(레코드, row) 의 개수 조회
select count(*) as '전체 행 개수' from member;

-- 실습13-1. member 테이블에서 연락처(phone1, phone2 열에 저장된 데이터들)가
-- 			저장되어 있는 그룹의 그룹회원의 레코드(행) 개수만 조회
select count(phone1) as '연락처가 저장되어 있는 그룹 행의 수' from member;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- HAVING 조건절
-- 		WHERE 조건절 대신 그룹으로 묶어준 데이터의 조건 검사하는 구문

-- 문법
-- 		SELECT 열명1, 집계함수(열명2) FROM 테이블명
--  	GROUP BY 그룹으로_묶을_같은_데이터가_저장된_열명
--  	HAVING 조건식
--  	ORDER BY 정렬기준_데이터가_저장된_열명 정렬방식;

-- 실습14. buy 테이블에서 조회합니다.
-- 		  회원 그룹 아이디를 그룹으로 묶어서
--  	  회원 그룹 아이디 별로 각각 총 구매금액과 그룹아이디열의 데이터 조회
select mem_id as '회원 그룹아이디', sum(price * amount) as '총 구매 금액'
from buy
group by mem_id;

-- 실습14-1.
-- 위 실습14. 는 그룹아이디별로 총 구매한 금액을 조회해서 보여줍니다
-- 만약 그룹아이디별로 총 구매한 급액이 1000이상이면 사은품을 증정하려고 한다면
-- 그룹 아이디별로 총 구매한 금액이 1000이상인 그룹의 총 구매금액, 그룹아이디를 조회합니다
select mem_id as '회원 그룹 아이디', sum(price * amount) as '총 구매 금액'
from buy
group by mem_id
having sum(price * amount) >= 1000;

-- 14-2.
-- 위 실습14. 는 그룹아이디별로 총 구매한 금액을 조회해서 보여줍니다
-- 만약 그룹아이디별로 총 구매한 급액이 1000이상이면 사은품을 증정하려고 한다면
-- 그룹 아이디별로 총 구매한 금액이 1000이상인 그룹의 총 구매금액, 그룹아이디를 조회합니다
-- 또한 총 구매한 금액에 따라 사은품이 다를 수 있기 때문에
-- 총 구매 금액이 큰 순서대로(내림차순 정렬)하여 최종 조회해서 보여줌
select mem_id as '회원 그룹 아이디', sum(price * amount) as '총 구매 금액'
from buy
group by mem_id
having sum(price * amount) >= 1000
order by sum(price * amount) desc;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- 연습 *************************************************************************************************************************************************
-- 1. 회원 그룹수(count)
-- 	  회원 그룹 테이블의 총 그룹회원(행, 레코드) 수를 계산해서 조회
select count(*) as total_members from member;

-- 2. 평균 인원수(avg)
-- 	  회원 그룹테이블의 그룹 평균 인원수 계산해서 조회
select avg(mem_number) as average_members from member;

-- 3. 최대 평균키(max)
-- 	  회원 그릅 테이블에서 가장 키가 큰 그룹회원의 평균 키 조회
select max(height) as tollest_member from member;

-- 4. 최소 평균키(min)
-- 	  회원그룹 테이블에서 가장 키가 작은 회원그룹의 평균 키 조회
select min(height) as shortest_member from member;

-- 5. 구매 수량의 총합(sum)
-- 	  구매 테이블에서 모든 구매 수량의 총합 조회
select sum(amount) as total_amount from buy;

-- 6. 각 회원별 구매 수량의 총합
-- 	  각 회원별로 구매한 총 수량을 계산합니다. mem_id 로 그룹화하여 각 회원의 총 구매 수량 조회
select mem_id, sum(amount) as total_amount
from buy
group by mem_id;

-- 7. 각 제품의 평균 가격(avg)
-- 	  구매한 각 제품별 단가(가격)의 평균을 계산해서 계산한 평균 값 조회되게 하기.
-- 	  참고. 제품 이름으로 그룹화하여 평균 가격을 구합니다.
-- 		  구매한 각 제품의 단가(가격)의 평균을 구하는 것입니다. 
--  	  즉, 특정 제품이 여러 번 구매되었을 때, 
--  	  그 제품의 가격을 모두 더한 후 구매 횟수로 나누어 평균 가격을 계산합니다.
select prod_name, avg(price) as average_price
from buy
group by prod_name;

-- 8. 특정 지역의 그룹 회원 수(count)
-- 	  각 사는 지역별 그룹명, 그룹회원 수 조회.
-- 	  참고. 지역 주소로 그룹화하여 각 지역의 회원그룹 수를 구합니다.
select addr, mem_name, count(*) as total_members 
from member
group by addr;

-- 9. 구매한 제품의 종류 수(count distinct)
-- 	  구매 테이블에서 구매한 제품의 종류 수를 계산합니다. 
-- 	  구매 제품 이름에 중복을 제거하여 고유한 제품 수를 구합니다.
/*
	전체 흐름 참고.
    1. 구매 데이터 조회: buy 테이블에서 모든 구매 정보를 가져옵니다.
    2. 중복 제거: prod_name 열에서 중복된 제품 이름을 제거하여 고유한 제품 이름만 남깁니다.
    3. 고유 제품 수 계산: 남은 고유한 제품 이름의 수를 세어 unique_products 라는 이름으로 결과를 반환합니다.
*/
select count(distinct prod_name) as unique_products from buy;
/*
핵심 
					WHERE  : 그룹으로 묶기 전에 행을 먼저 걸러낸다.
					GROUP BY : 같은 값끼리 묶는다.
					HAVING : GROUP BY로 묶은 조회 결과에 조건을 건다.
	예를 들어 
			-- 일반 열 데이터 조건은 where 사용 
				where mem_number >= 5;
                
            -- SUM(), AVG(), COUNT() 같은 집계 함수 조회결과 조건이므로 HAVING 사용     
                HAVING SUM(amount) >= 2;
*/
-- 10. 구매 테이블에서 상품 분류별 총 구매 수량을 조회하시오.
-- 	   예: 디지털 분류 전체 구매 수량, 패션 분류 전체 구매 수량
/*
    풀이 설명
    1. buy 테이블에서 데이터를 조회한다.
    2. 상품 분류는 group_name 컬럼(열)에 들어 있다.
    3. 같은 상품 분류끼리 묶기 위해 GROUP BY group_name을 사용한다.
    4. 각 상품 분류별 구매 수량의 합계를 구하기 위해 SUM(amount)를 사용한다.
*/
select 
	group_name, 				-- 상품 분류
	sum(amount) as total_amount -- 분류별 총 구매 수량
from buy
group by group_name;

-- 11. 구매 테이블에서 상품 분류별 평균 가격을 조회하시오.
-- 	   단, 상품 분류가 NULL 인데 데이터는 제외하시오.
/*
    풀이 설명
    1. 상품 분류는 group_name 컬럼이다.
    2. group_name이 NULL인 경우는 분류가 없는 데이터이므로 제외한다.
    3. WHERE group_name IS NOT NULL 조건으로 NULL을 제외한다.
    4. GROUP BY group_name으로 상품 분류별로 묶는다.
    5. AVG(price)로 각 분류별 평균 가격을 구한다.
*/
select 
	group_name,					-- 상품 분류
	avg(price) as avg_price		-- 분류별 상품 가격
from buy
where group_name is not null
group by group_name;

-- 12. 구매 테이블에서 회원별 구매 건수를 조회하시오.
-- 	   구매 건수란 buy 테이블에 저장된 구매 기록의 개수를 의미한다.
/*
    풀이 설명
    1. 회원 아이디는 mem_id 컬럼(열)이다.
    2. 같은 회원끼리 묶기 위해 GROUP BY mem_id를 사용한다.
    3. COUNT(*)는 각 회원별 구매 기록 개수를 센다.
    4. SUM(amount)는 총 구매 수량이고, COUNT(*)는 구매한 기록의 개수이다.
       둘은 서로 다르다.
*/
select 
	mem_id, 					-- 회원그룹 아이디
    count(*) as order_count 	-- 회원별 구매 기록 수
from buy
group by mem_id;

-- 13. 구매 테이블에서 회원별 총 구매 금액을 조회하시오.
--     총 구매 금액은 가격(price) * 수량(amount)으로 계산하시오.
select 
	mem_id, 							-- 회원 그룹 아이디별
    sum(price * amount) as total_price 	-- 회원 그룹 아이디별 총 구매 금액
from buy
group by mem_id;

-- 14. 구매 테이블에서 상품별 총 판매 금액을 조회하시오.
--     총 판매 금액은 가격(price) * 수량(amount)으로 계산하시오.
select 
	prod_name, 							-- 상품 이름
	sum(price * amount) as total_price 	-- 상품 이름 별 총 판매 금액
from buy
group by prod_name;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- -------------------------------
-- 03-3 절. 데이터 변경을 위한 SQL문
-- -------------------------------
/*
	주제: 데이터베이스 내부에 만든 특정 테이블에 데이터를 추가(입력)/ 수정/ 삭제 하는 SQL문을 배우자
		
        INSERT 문: 테이블에 새로운 행 데이터를 추가(입력)해서 저장할 때 사용되는 SQL문 종류 중 하나
        
        INSERT 문 작성 기본 문법
        
			insert into 테이블명( 추가할값이저장될_열명1,추가할값이저장될_열명2,추가할값이저장될_열명3)
						values( 열명1에 추가할_값1   , 열명2에 추가할_값2 , 열명3에 추가할 값3 );
                        
			insert into 테이블명(열명1, 열명2, 열명3)
						values( 값1 , 값2 , 값3 );
*/
-- market_db 데이터베이스 사용하기 위해 선택
USE market_db;
/*
	테이블 생성 문법
		create table 생성할테이블명(
        
			생성할열명1 열1에저장할데이터유형,
            생성할열명2 열2에저장할데이터유형,
            ...        
        );

*/
-- hongong1 이라는 이름의 테이블 생성
create table hongong1(
	toy_id int, 		-- 장난감 아이디
    toy_name char(4),	-- 장난감 이름
	age int				-- 장난감 나이
);
-- hongong1 테이블에 저장된 모든 열의 데이터 조회
select * from hongong1;

-- hongong1 테이블에 하나의 행(row, 레코드)을ㄹ 추가하여 저장
insert into hongong1(toy_id, toy_name, age)
			  values(	  1, 	'우디',  25);
              
-- hongong1 테이블에 toy_id 열과 toy_name 열에만 데이터를 추가하여 저장할 값 넣어보자
insert into hongong1(toy_id, toy_name) values(2, '버즈');

-- hongong1 테이블에 열명의 순서를 바꿔서 추가로 행을 저장
-- 주의할 점은 테이블명() 사이에 작성한 열명의 순서에 맞게 values() 사이에 저장할 값 넣어서 추가해야 합니다.
insert into hongong1(toy_name, age, toy_id) 
			  values(   '제시',  20,      3);

-- hongong1 테이블에 (열명1, 열명2, 열명3) 을 생략하고
-- values(열_추가값1, 열_추가값2, 열_추가값3) 구문만 작성해 새로운 행 데이터를 추가할 수 있다.
-- 단! 주의할 점은 테이블 생성 시 작성한 열명 순서에 맞게 추가할 값들을 작성해야 합니다.
--                     toy_id, toy_name, age
insert hongong1 values(     4,    '영구',  30);

/*
	AUTO_INCREMENT 예약어
		- 테이블을 새로 생성할 때 열이름 뒤에 설정하는 예약어로
		  열에 대한 값을 INSERT 문장으로 추가하지 않아도
          자동으로 1씩 증가되면서 추가가 되게하는 예약어.
*/
-- hongong2 테이블 새로 생성
create table hongong2(
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int
);
-- hongong2 테이블에 자동으로 toy_id 열에 대한 값을 1증가해서 들어가는 데이터를 null 값으로 채워놓고 데이터 추가
insert into hongong2(toy_id, toy_name, age) values(null, '보핍', 25);

-- hongong2 테이블에 자동으로 toy_id 열에 대한 값을 1증가해서 들어가는 데이터를 null 값으로 채워놓고 데이터 추가
insert into hongong2(toy_id, toy_name, age)
			  values(  null,   '슬링키',  22);

insert into hongong2(toy_id, toy_name, age)
			  values(  null,    '렉스',  21);

/*
	toy_id 열에 추가할 값을 작성하지 않고, 다른 열의 값만 추가시키면
    auto_increment 제약조건 예약어를 설정 해놓은 toy_id 열의 값은 자동으로 1증가하면서 추가된다. 
*/
insert into hongong2(toy_name, age)
			  values(   '맹구', 100);

/*
	hongong2 테이블의 toy_id 열에는 auto_increment 제약조건 예약어를 설정해 놓았기 때문에
    자동 증가 값이 4까지 설정되어 있다는 것을 확인할 수 있지만
    자동으로 증가된 값이 얼마만큼 되었는지 확인하는 구문
*/
select last_insert_id() as 'toy_id 열에 추가된 최근 값';

/*
	auto_increment 제약조건을 지정한 열은 1부터 insert(추가) 가 되기 때문에
    특정 값 부터 insert(추가) 가 되게 하기 위해 auto_increment 제약조건의 속성의 값을 설정해야 한다.
*/
alter table hongong2 auto_increment = 100;
					 -- 초기 값은 100으로 설정
                     -- 초기 100부터 1씩 증가되어 추가되도록 설정

insert into hongong2(toy_name, age) values('제남', 35);
/*
	auto_increment 제약조건을 지정한 열은 100부터 1씩 증가되면서 insert 가 됩니다.
    하지만 3씩 증가, 즉 103, 106, 109 형태로 증가 시킬 수 있게
    @@auto_increment_increment 변수의 값을 변경하면 된다.
*/
-- hongong3 테이블 새로 만들기
create table hongong3(
	toy_id int auto_increment primary key,	-- 장난감 아이디 저장할 toy_id 열을 만들고 숫자 아이디로 저장
    toy_name char(4),	-- 장난감 이름을 저장할 toy_name 열을 만들고 최대 4글자까지 저장
    age int	 -- 장난감 나이를 저장할 age 열을 만들고 숫자로 나이를 저장
);
-- auto_increment 의 자동 증가 시작되는 값을 1000으로 설정
alter table hongong3 auto_increment = 1000;

-- auto_increment 는 1000부터 열의 데이터가 추가되어 1씩 증가되어 추가되지만
-- 만약 3씩 증가하여 추가를 시키려면? 다음과 같이 시스템 변수의 값을 설정하면 됨.
set @@auto_increment_increment = 3;  -- 자동으로 증가되는 값을 3으로 설정

insert into hongong3 values(null, '토마스', 20);
insert into hongong3 values(null, '제임스', 23);
insert into hongong3 values(null, '고든', 25);

insert into hongong3(toy_name, age) values('개똥이', 100);
insert into hongong3(toy_name, age) values('똘똘이', 5);

/*
	insert into ~ select 전체 구문
	- 특정 테이블 select 구문을 이용해 조회한 표 형태의 결과 데이터들을
      insert into 문장을 이용해 테이블에 행의 데이터들을 한 번에 추가시키는 구문
	- 문법
		insert into  테이블명(열명1, 열명2, 열명3)
        select 열명1, 열명2, 열명3 from 테이블명;
*/
-- world 데이터베이스 사용을 위한 선택
use world;
-- world 데이터베이스 내부에 만들어져 있는 테이블 목록 조회
show tables;

-- world 데이터베이스 내부에 만들어져 있는 city 테이블 레코드(행)의 총 개수 조회
select count(*) as '총 행 개수' from city;  -- 4079 행 데이터들

-- city 테이블에 저장된 전체 레코드(행) 조회
select * from city;

-- city 테이블에 어떤 열이 어떤 구조로 설정되어 만들어져 있는지 열의 구성을 확인하는 구문
-- 문법 desc 테이블명;
desc city;

-- city 테이블에 저장된 4079행 데이터 중에서
-- 5개의 행 데이터만 조회
select * from city 
limit 0, 5;
/*
	테이블 생성 문법
		create table 생성할_테이블명(
			생성할 열명1 열명1에_저장할_데이터유형,
            생성할 열명2 열명2에_저장할_데이터유형,
            생성할 열명3 열명3에_저장할_데이터유형
        );
*/
-- city 테이블에 저장된 도시명과 인구 수를 조회해서 저장할 city_popul 테이블 생성하기
create table city_popul(
	city_name char(35),	 -- 도시명
	population int		 -- 각 도시에 사는 인구 수
);
/*
	insert into ~ select 전체 구문
	- 특정 테이블 select 구문을 이용해 조회한 표 형태의 결과 데이터들을
      insert into 문장을 이용해 테이블에 행의 데이터들을 한 번에 추가시키는 구문
	- 문법
		insert into  테이블명(열명1, 열명2, 열명3)
        select 열명1, 열명2, 열명3 from 테이블명;
*/
insert into city_popul(city_name, population)
select name, population from city;

-- city_popul 테이블에 city 테이블에서 조회한 4079행의 정보가 제대로
-- city_name 열과 population 열에 추가되어 저장되는지 나중에 확인
select       *  from city_popul;

select count(*) from city_popul;

/*
insert 문 보충    
    1. 단일 행 삽입 
		-  단일 행 삽입은 한 번에 하나의 행을 테이블에 추가하는 방법.
        - 예시.  INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3);
    
    2. 다중 행 삽입 
		-  다중 행 삽입은 한번에 여러개의 행을 테이블에 추가하는 방법.
        - 예시. INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3),(값4, 값5, 값6),(값7,값8,값9);
    
    3. SELECT문을 활용한 삽입
		- SELECT문을 사용하여 다른 테이블의 데이터를 기반으로 데이터를 삽입하는 방법
        - INSERT INTO 문과 SELECT문을 함께 사용하여 SELECT문의 결과를 기반으로 테이블에 삽입합니다.
        - 예시. INSERT INTO 테이블명(열1, 열2, 열3)
               SELECT 열1, 열2, 열3 FROM 다른테이블명 WHERE 조건;
        
    4. ON DUPLICATE KEY UPDATE 사용 
        - MySQL 8버전에서 도입된 기능으로, 데이터 삽입시 중복된 키가 발생할 경우 업데이트 작업을 수행하는 방법
        - INSERT INTO문 뒤에 ON DUPLICATE KEY UPDATE 절을 추가고, 업데이트할 열과 값을 지정합니다.
        - 예시.  INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3)
                ON DUPLICATE KEY UPDATE 열1=값1, 열2=값2;
*/
-- 1. 테이블 생성
create table users(
	id int auto_increment primary key,	-- 고유한 ID
    name varchar(50),					-- 사용자 이름
	age int								-- 사용자 나이
);

-- 2. 단일 행 삽입 예제
--    users 테이블에 한 명의 행 데이터 삽입
insert into users(name, age) values('Alice', 25);

-- 3. 다중 행 삽입 예제
-- users 테이블에 여러 명의 행 데이터를 동시에 삽입합니다.
insert into users(name     , age)
		   values('Bob'    ,  30),
				 ('Charlie',  35), 
                 ('Diana'  ,  28);

-- 4. SELECT 를 사용한 데이터 삽입
-- 	  다른 테이블에서 데이터를 조회해서 users 테이블에 삽입하는 예제
--    예를 들어 new_users 테이블이 있다고 가정하자.
create table new_users(
	name varchar(50),	-- 사용자 이름
    age int				-- 사용자 나이
);
-- 일단 new_users 테이블에 데이터가 하나도 없으므로 다중 행 추가해놓기.
insert into new_users(name, age) values('Eve', 26), ('Frank', 29);

-- new_users 테이블에서 select 구문을 이용해서 조회한 name 열의 값과 age 열에 대한 값을
-- users 테이블에 insert 구문을 이용해서 삽입.
insert into users(name, age)
select name, age from new_users
where age > 25;

-- 5. On DUPLICATE KEY UPDATE 예제. <--- MySQL 8 이상부터 적용되는 문법
-- 	  id 열에 저장된 값이 중복되는 경우는 같은 1을 넣으면 insert 되지 않는다.
--    그럴 경우 name 열과 age 열의 값만 변경하고 싶을때 ON DUPLICATE KEY UPDATE 구문을 사용하면 된다.
insert into users(id, name, age) value(1, 'Alice', 27)
on duplicate key update name = 'Alice Updated', age = 27;

select * from users;
/*
테이블 조회해서 가져온다. select 구문
테이블 새 행 데이터 추가. insert 구문
테이블 열에 저장된 값만 수정. update 구문  <--- 이거 할 차례
테이블에 행 데이터 삭제. delete 구문
*/
/*
	UPDATE 구문?
     - 테이블에 이미 저장되어 있는 열의 데이터를 수정(변경)하는 SQL 문 중 하나
     - 문법
		UPDATE 수정할_데이터가_저장된_테이블명
        SET    수정할_데이터가_저장된_열명1 = 수정할_값1, 열명2 = 수정할_값2, ...
        WHERE 조건식;
        
        UPDATE 테이블명
        SET 수정할_열명 = 수정될_값
        WHERE 조건식;
*/
-- city_popul 테이블에 저장된 도시 이름이 'Seoul' 인 모든 열의 데이터 조회
select * from city_popul
where city_name = 'Seoul';

-- city_popul 테이블의 도시 이름 중에서
-- 영문 'Seoul' 데이터를 한글 '서울' 로 수정하자
update city_popul
set city_name = '서울'
where city_name = 'Seoul';

-- city_popul 테이블에 저장된 도시 이름이 '서울' 인 모든 열의 데이터 조회
select * from city_popul
where city_name = '서울';

-- city_popul 테이블의 city_name 열에 저장된 데이터가 'New York' 을 '뉴욕' 으로 수정하고 동시에
-- 					 population 열에 저장된 인구수를 0으로 수정
-- 조건 -> city_name 열에 저장된 데이터가 'New York' 인 열의 값이면 위 2가지 정보를 수정해야 합니다.

-- 순서1. 수정할 데이터 조회해 볼것 같다.
select city_name, population 
from city_popul
where city_name = 'New York';

-- 순서2. city_popul 테이블의 city_name 열에 저장된 데이터가
-- 	 	 영문 'New York' 을 한글 '뉴욕' 으로 수정하는 동시에
-- 		 population 열에 저장된 인구수를 0으로 수정하자
update city_popul
set city_name = '뉴욕', population = 0
where city_name = 'New York';

-- 순서3. 수정된 열의 데이터 확인을 위해 조회
select city_name, population
from city_popul
where city_name = '뉴욕';

-- city_popul 테이블에 저장된 모든 행의 열 인구 수를 10000 으로 나눈 계산된 값들을
-- population 열의 값들로 수정
update city_popul
set population = population / 10000;

-- 영구반영(commit)인한 update 구문 취소(되돌리기)하는 구문
rollback;

-- population 열의 값들 수정되기 전 상태 조회
select * from city_popul;

-- ------------------------------------------------------------------------------------------------------------------------------------------
/*
	DELETE 문
		- 테이블에 저장된 행 단위로 데이터를 삭제하는 SQL 문 중 하나
        - 문법
			DELETE FROM 삭제할_행이_저장된_테이블명
            WHERE 조건식;
*/
-- 도시 이름(city_name 열의 데이터들)이 New라는 단어로 시작하는 도시 이름이 존재하는 행을 삭제

-- 순서1. 먼저 도시 이름이 New라는 단어로 시작하는 도시 이름이 저장되어 있는지 SELECT 조회해보자.
select * from city_popul
where city_name like'New%';

-- 순서2. city_popul 테이블에 city_name 열에 저장된 데이터 중에서
-- 		 'New' 단어로 시작하는 도시이름의 행 11개를 삭제
delete from city_popul
where city_name like 'New%';

-- 순서3. city_popul 테이블에 저장된 총 행의 개수는 4079개 중에서
-- 		 4068행 개수로 조회되게 전체 행의 개수 조회
select count(*) from city_popul;
-- ----------------------------------------------------------------------------------------------------------------------------
/*
	대용량의 데이터가 저장된 테이블을 삭제하기 위해 먼저 실습 준비
    
    대용량 데이터를 저장하기 위해 일단 테이블 3개 준비
    방법: 대용량의 데이터들이 저장된 테이블을 SELECT 구문으로 조회해 와서
		 CREATE 구문을 이용하여 총 3개의 테이블을 생성
*/
--        외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table1(

	select * from world.city, sakila.country

);

select count(*) from market_db.big_table1;  -- 444611 행 데이터 저장되어 있음

desc market_db.big_table1;

--        외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table2(

	select * from world.city, sakila.country

);

--        외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table3(

	select * from world.city, sakila.country

);

-- DELETE: 테이블에 저장된 행 단위 데이터 삭제하는 SQL 문
delete from market_db.big_table1;	-- 2.516초

-- DROP 테이블 자체를 삭제하는 SQL 문
-- 문법
-- 		DROP TABLE 삭제할테이블명;
drop table market_db.big_table2;	-- 0.031초

-- TRUNCATE: 테이블에 저장된 행 단위 데이터 삭제하는 SQL 문
-- 			 단, WHERE 조건식; 과 같이 작성할 수 없습니다.
-- 			 조건식 없이 전체 행을 삭제해야 할 때만 truncate 문 사용!
















