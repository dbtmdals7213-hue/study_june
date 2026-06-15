
-- 한줄 주석

# 한줄 주석

/*
 여러 줄 주석
 여러 줄 주석 
*/
--  현재 MySQL DBMS 서버에 만들어져 있는 데이터베이스 목록 보기 명령
show databases;

--  사용할 데이터베이스 선택 명령
-- 작성 문법 :    use 사용할데이터베이스명;
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
		
    요약 : member 테이블(표)에 저장된 member_id, member_addr 열 세로 방향의 각칸에 저장된 값 조회
*/
-- 풀이  : member테이블에 저장된 데이터들 중에서 
--        member_id열 방향(세로 방향)에 저장된 데이터와 
--        member_addr열 방향(세로 방향)에 저장된 데이터 들만 모두 조회
		  select member_id, member_addr
          from member;

-- 풀이   :  member 테이블에 저장된 모든 열의 데이터들 조회
		  select  *
          from member;

-- 풀이   : member_name열 방향(세로 방향)에 저장된 이름들 중에서 "아이유"가 저장된 행 위치의 모든 열의 값 조회
-- 요약   : 이름이 아이유인 회원의 모든 열 데이터 조회 
		  select *
          from member
          where member_name = '아이유';

-- 맛보기 끝 

-- ---------------------------------------------------------------------------------------------
/*
	개체(객체) ?  데이터로 표현하고자 하는 데이터베이스의 구성요소
    
    개체 종류 : 테이블 ,  인덱스,  뷰, 스토어드프로시저, 트리거, 함수, 커서 등.......

	1.인덱스(index) 개체 
    - 데이터베이스 테이블에 저장된 데이터의 검색 속도를 향상시키기 위한 개체 
*/
-- 인덱스 개체를 생성해서 사용하지 않고 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보 조회
select  * from  member
where member_name = '아이유';

/*
	인덱스 객체 만들기 문법
		CREATE INDEX 생성할인덱스개체명 ON 테이블명(열명);
*/
-- member 테이블의 member_name열에 대한 빠른속도로 데이터를 조회 하기 위해 인덱스 개체를 생성하자.
CREATE INDEX idx_member_name ON member(member_name);

-- 인덱스 개체를 idx_member_name 을 생성하고 나서 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보를 조회 
select * from member
where member_name = '아이유';

-- ------------------------------------------------------------------------------
/*
	뷰 개체  :   가상의 테이블(가짜 테이블)
    
    뷰 개체 생성 문법
		
			create view 생성할뷰명
            as select * from 조회할_실제_테이블명;
*/
-- member 테이블에 저장된 모든 열 정보 조회 
select * from member;

-- member 테이블과 연결되는 회원뷰 개체(member_view) 생성
create view member_view
as select * from member;

-- member 테이블명이 아닌~~~ 회원뷰 개체(member_view)명으로 
-- member 테이블의 정보를 조회 할수 있다.
select * from member_view;


-- 조회시 테이블을 사용하지 않고 굳이 뷰를 사용하여 조회한 이유는?
-- 1. member테이블을 조작하면 데이터가 변경되거나 삭제 될수 있어 보안에 좋지 않음
--    그래서 뷰명으로 조회 하면 member테이블을 직접 만져서 조회하지 않기떄문에 보안에 좋음
-- 2. 긴 조회 SELECT SQL문을 간략하게 만들수도 있다.
-- ---------------------------------------------------------------------------

/*
	스토어드 프로시저 개체 :  프로그램 코드를 묶어 놓은 함수와 같은 개체 
*/
-- 회원테이블(member)에 저장된 데이터들 중에서 member_name열에 저장된 값이 '나훈아'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from member where member_name = '나훈아';

-- 상품테이블(product)에 저장된 데이터들 중에서 product_name열에 저장된 값이 '삼각김밥'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from product where product_name = '삼각김밥';

/*
	스토어드 프로시저 개체 생성 문법
    
			DELIMITER //
			CREATE PROCEDURE 생성할스토어드프로시저명() 
			BEGIN
					프로그래밍할 SQL문장1;
                    프로그래밍할 SQL문장2; ..........
			END //
			DELIMITER ;
            
	  참고. 위 첫 행과 마지막 행에 구분 문자라는 의미의 DELIMITER // 와 
           DELIMITER; 문을 작성 하였는데...
           일단 이것은 스토어드 프로시저를 만들기 위해 묶어 주는 약속의 문법 이라고 생각 하면됩니다.    
            
*/
--  위 두 SELECT 문을 하나의 기능인 스토어드 프로시저 개체로 만들어 보겠습니다.
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
		select * from member where member_name = '나훈아';
        select * from product where product_name = '삼각김밥';
END //
DELIMITER ;

-- 바로 위에서 만든 myProc라는 이름의 스토어드프로시저 개체를 호출해서 실행하기 위한 문법
--   CALL 호출할프로시저명();
CALL myProc();
CALL myProc();
CALL myProc();

-- -------------------------------------------------------------------------------
-- 주제 : 기본 조회문  SELECT ~ FROM 절 배우기 

/*
		USE 문
		- SELECT문으로 테이블에 저장된 데이터를 조회하기 전에 ~~~~~
          먼저 사용할 데이터베이스를 선택할때 이용하는 예약어.
          
		- 사용 문법
			USE 사용할데이터베이스명;
*/
use market_db;

/*
	SELECT 문?
		- 특정 테이블 표에 저장되어 있는 데이터를 조회하여 가져올때 사용되는 SQL구문.
        
    SELECT문 전체 작성 문법
		
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값
         GROUP BY 그룹으로_묶을_데이터들이_저장된_열명
         HAVING  조건식
         ORDER BY 정렬할_데이터가_저장된_열명 ASC 또는 DESC
         LIMIT 숫자;
			
	----------------------------------------------------
    
		SELECT 핵심 문법1.
        
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값;					
*/
-- 실습0. member테이블에 저장된 모든 열의 값 조회 
select mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date
from member;

-- select -> 테이블에서 데이터를 조회 해서 가져올때 사용되는 예약어.
-- * -> 조회해 올 데이터가 저장된 모든열명.
-- from -> 테이블에서 데이터를 조회해 온다는 의미의 예약어. 
-- member -> 조회할 데이터가 저장된 테이블명.
select *
from member;
-- 풀어서 해석하면? member테이블에 저장된 모든 열의 데이터들을 조회해서 가져오라~ 의미 

-- 실습1. 회원테이블(member)에 그룹이름이 저장된 mem_name열의 데이터들만 조회 
-- 작성 문법
--          select 조회할_데이터가_저장된_열명  from  조회할_테이블명;
select mem_name from member;

--  실습2. 회원테이블(member)에 주소addr, 입사년도debut_date, 그룹이름mem_name열의 데이터들만 조회
select addr, debut_date, mem_name from member;

-- 실습3. 회원테이블(member)에 조회할 열명 대신 별칭을 지어서 조회된 결과창에 보여주기 위해서는 
--       아래의 문법을 사용하자.
--        select 조회할_열명1 as 별칭명1,   조회할_열명2  as 별칭명2
--        from  조회할테이블명;
-- 또는
--        select 조회할_열명1   별칭명1,    조회할_열명2   별칭명2
--        from  조회할테이블명;
select addr as "주소", debut_date as "데뷔일자", mem_name  "그룹명" from member;

-- 실습4. 회원테이블(member)에서 회원그룹이름(mem_name열에 저장되어 있는 데이터들)이 
--       '블랙핑크'가 저장되어 있는 위치의 행이 있는 모든 열의 데이터를 조회
-- 		 요약 : 회원그룹이름이 '블랙핑크' 인 모든 열의 값들 조회!

-- 문법 
--      select 조회할_데이터가_저장된_열명
--      from   조회할_테이블명
--      where  조건에서_사용할_데이터들이_저장된_열명  = 비교할_조건값;
select *
from member
where mem_name = '블랙핑크';

-- 실습5. member테이블에서 회원그룹인원(mem_number열의 데이터)이 4명인 그룹의 모든 열의 데이터 조회
select * 
from member
where mem_number = 4;

-- 실습6.  관계(비교) 연산자 기호  <=     >=    <    >   =
--         member테이블에서 회원 그룹 평균키들 중에서 
--         데이터가 162이상인 회원그룹의 아이디들, 회원그룹명들  조회 
select mem_id,  mem_name  from member  
where  height  >=  162;

-- 실습 7-1.  관계(비교) 연산자 기호  <=     >=    <    >   =
--           논리 연산자 기호   AND    OR

-- member테이블에서 회원그룹 평균키(height열에 저장된 데이터들)가 165이상이면서!
-- 그룹 인원(mem_number열에 저장된 데이터들)이 6명 초과인 회원그룹의 
-- 회원그룹명(mem_name열에 저장된 데이터들), 
-- 그룹평균키(height열에 저장된 데이터들), 
-- 그룹인원(mem_number열에 저장된 데이터들) 조회!!!!
select mem_name, height, mem_number from member
where height >= 165 and  mem_number > 6;

-- member테이블에서 회원그룹 평균키가  165이상 이거나 또는~ 그룹 인원이 6명 초과인 회원그룹의?
-- 회원그룹명, 회원평균키, 회원그룹인원수 조회!!!!
select mem_name, height,  mem_number  from member
where height >= 165 or  mem_number >  6;

-- 실습 7-1-1. BETWEEN  AND절 미사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!
select mem_name, height,  mem_number from member
where height >= 163  and  height <=  165;

/*
BETWEEN AND 절 작성 문법

   select 열명  from  테이블명
   where 비교할_값들이_저장된_열명 between 범위의최솟값 and 범위의최댓값;
*/
-- 실습 7-1-2. BETWEEN  AND절 사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!  
select mem_name, height,  mem_number from member
where height  between  163  and  165;

-- 실습 8. 회원그룹의 평균키가 165이상이거나 또는 그룹인원이 6명 초과인 
--        회원그룹들의 그룹명, 그룹평균키, 그룹인원수 조회!!!!!!!
select mem_name,  height,  mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 8-1. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용하지 않고 조회!!!!!!!    
select mem_name, addr  from member
where  addr = '경기' or  addr = '전남' or  addr = '경남';

-- 실습 8-2. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용해 조회!!!!!!!    
--  문법
--      where 비교할_데이터가_저장된_열명  IN('비교할값1', '비교할값2', '비교할값3');
select mem_name, addr  from member
where  addr in('경기', '전남', '경남');

/*
	Like
    - 문자열 데이터의 일부 글자가 옆의 데이터로 포함되어 있는 행에 대한 열의 값 조회 하는 예약어.
	  예를 들어 회원그룹명의 첫 글자가 '우' 문자로 시작하는 단어를 포함하는 데이터가 저장된 
      행에 관한 열의 데이터를 조회할수 있습니다.
	- 문법
			where  비교할_데이터가_저장된_열명 LIKE '문자%'; 
*/
-- 실습9. member테이블에서 회원그룹명 중에서 '우' 문자로 시작하는 단어가 포함된 데이터가 있으면 
--       그 행에 관한 모든 열의 데이터들 조회
select * from member
where mem_name like '우%';

-- 실습9-1. LIKE절에 _언더바 기호 사용 가능 
--  member테이블에서 회원그룹명 중에서 앞 두글자는 상관없고 뒷 단어가 '핑크'인 
--  회원그룹의 이름이 저장되어 있으면? 이름이 저장된 행에 관한 모든 열의 데이터를 조회
select * from member
where mem_name like '__핑크';

-- 실습9-2. LIKE절에 %단어%  사용 
--  member 테이블에서 회원그룹명 중에서 '마' 단어가 포함하고 있는 그룹명이 저장되어 있으면?
--  그 그룹의 행에 관한 모든 열의 데이터를 조회 
select * from member
where mem_name like '%마%';

-- 실습9-2-1. LIKE절에 '%단어' 사용 
-- member테이블에서 회원그룹명 중에서 '친구' 단어로 끝나는 그룹명이 저장되어 있으면?
-- 그 해당 그룹의 행에 관한 모든 열의 데이터 조회 !!!
select * from member
where mem_name like '%친구';

/*
	서브 쿼리 구문
		-  안쪽 SELECT구문을 이용하여 조회한 결과 데이터들을 
           바깥쪽 SELECT구문을 이용하여 다시 조회하는 전체 구문을 말함.
           
		- 문법
				SELECT * FROM 테이블명
                WHERE 조건열명 > (SELECT * FROM 테이블명
								WHERE 조건열명 = 조건열의 값들과 비교할 값);
*/
-- 실습 10-1. 서브쿼리를 사용하지 않고 두개의 SELECT문장을 사용한 예

-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.

	-- 순서1. 일단 에이핑크 그룹의 평균키 164 조회 해 오자
	select height from member where mem_name = '에이핑크';
	
	-- 순서2. 에이핑크 그룹의 평균키는 순서1.에서 조회 했으므로 164입니다.
	--       where 조건절의 조건값 자리에 164를 대입해서 164보다 큰~ 그룹의 이름과 평균키를 조회하면 된다.
    select mem_name, height from member
    where height  > 164;

-- 실습 10-2. 서브쿼리 사용
-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.
    select mem_name, height from member
    where height  >  (select height from member 
                      where mem_name = '에이핑크');
-- --------------------------------------------------------------------------------------
-- 연습문제 
--  1번.  회원테이블에서 모든 회원의 ID와 그룹이름을 조회 해라.
select mem_id, mem_name from member;

--  2번.  회원테이블에서 그룹회원의 평균키가 167이상인 그룹회원의 모든 열의 정보 조회 해라.
select * from member
where height >= 167;

--  3번.   회원테이블에서 그룹인원수가 5명 이하인 그룹의 이름과 인원수 조회 해라.
select mem_name,  mem_number from member
where mem_number <= 5;

--  4번.  구매 테이블(buy)에서 상품가격이 100 이상인 구매한 상품의 이름과 가격을 조회 해라.
select prod_name, price from buy
where price >= 100;

--  5번.  회원 테이블에서 주소가 '경기'인 회원그룹의 모든 열정보를 조회 해라.
select * from member
where  addr = '경기';

--  6번.  구매 테이블(buy)에서 '패션' 분류의 상품 이름과 구매수량을 조회 해라.
select prod_name, amount from buy
where group_name = '패션';

--  7번. 회원 테이블에서 '서울'에 사는 그룹회원 이름과 전화번호(국번,뒷번호 모두 포함)해서 조회해라.
select mem_name, phone1, phone2 from member
where  addr =  '서울';

--  8번. 회원 테이블에서 그룹명이 '트와이스'인  그룹 회원의 모든 열정보 조회 해라 .
select  * from member
where  mem_name = '트와이스';

-- 9번. '블랙핑크'라는 이름을 가진 그룹회원이 구매한 모든 제품의 정보(모든열값)를 조회 하시오.
-- 서브쿼리 사용!
select * from buy
where mem_id = (select mem_id from member
				where mem_name = '블랙핑크');


--  10번. 회원 테이블에서 그룹 인원수가 8명인 그룹의 모든 열정보를 조회 하라.

--  11번. 구매 테이블에서 구매한 상품이름에 '지갑'단어가 포함된 상품의 모든 열정보를 조회 하라 
select * from buy
where prod_name like '%지갑%';

--  12번. 회원 테이블에서 평균키가 165cm 이하인 그룹의 이름과 평균키를 조회 하라
select mem_name, height from member
where height <= 165;

--  13번. 회원 테이블에서 '여자친구' 또는 '트와이스' 그룹이름가진 모든 열정보를 조회 하라
select * from member
where mem_name in('여자친구','트와이스');

--  14번. 구매 테이블에서 구매한 제품 수량이 3이상인 
--        구매한그룹의 그룹아이디, 상품의 이름, 가격을 조회하라 
select mem_id, prod_name,  price from buy
where amount >= 3;

--  15번. 회원 테이블에서 사는지역이 '강남'인 회원의 이름과 주소를 조회 하라 
select mem_name, addr from member
where  addr = '강남';
-- 조회 되지 않음! 이유 : 사는 지역이 강남인 회원그룹 없음


--  16번. 구매 테이블에서 '디지털' 분류(group_name열)의 상품 중 가격(price열)이 200이하인 
--        구매한_상품의_이름(prod_name열)을 조회 하라
select prod_name  from buy
where group_name = '디지털' and  price <= 200; 

--  17번. 회원 테이블에서 그룹 평균키가 162cm이상인 그룹의 이름을 조회하라
select mem_name from member
where height >= 162;

-- 18번. 구매 테이블에서 특정그룹('블랙핑크')의 구매 내역에서 
--       가격이 50이상인 구매한_상품의_모든열 정보 조회하라
-- 서브쿼리~~~~~~~~~

select * from buy
where price >= 50  AND mem_id = (select mem_id from member
								  where mem_name = '블랙핑크');
/*
먼저 member테이블에 저장된 블랙핑크 그룹을 식별할 mem_id 열 값을 조회 ! -> 'BLK'
select mem_id from member
where mem_name = '블랙핑크';  -- >>>>>>>>> mem_id --->  BLK
*/

-- ----------------------------------------------------------------
-- 03-2절 조금 더 깊게 알아보는 SELECT 문
-- ---------------------------------------------------------------
/*
	 ORDER BY 절 
		- 최종 조회 시 특정 열의 값을 기준으로 해서 내림 차순 또는 오름 차순 정렬해서 
          조회 하는 예약어
		- 문법
				SELECT  * FROM 조회할테이블명
                WHERE 조건식
                ORDER BY 정렬할_데이터가_저장된_열명  ASC 또는 DESC;
        - 참고.
				ASC -> Ascending의 약자로 오름차순 정렬을 의미.
                DESC -> Descending의 약자로 내림차순 정렬을 의미.
*/
select * from member;
-- 실습1. 그룹 회원의 데뷔일자(debut_date열에 저장된 날짜들)를 기준으로
--       오름 차순 정렬(데뷔일자가 빠른 날짜순) 하여 조회시 ORDER BY 절을 사용합니다.
select * from member
order by debut_date asc;

-- 실습2. 그룹 회원의 데뷔일자(debut_date열에 저장된 날짜들)를 기준으로
--       내림 차순 정렬(데뷔일자 늦은 날짜순)하여 조회시 ORDER BY 절을 사용합니다.
select * from member
order by debut_date desc; 

-- 실습3. ORDER BY절과 WHERE조건절 함께 사용하기
-- 그룹 평균키(height열에 저장된 데이터들)가 164이상인 그룹회원들의 키가 큰 순서대로(내림차순)정렬해서
-- 그룹명(mem_name열에 저장된 데이터들),
-- 그룹아이디(mem_id열에 저장된 데이터들),
-- 그룹평균키(height열에 저장된 데이터들)
-- 데뷔날짜(debut_date열에 저장된 데이터들) 조회!
select mem_name, mem_id, height, debut_date from member
where  height >= 164
order by height desc;

-- 실습4. ORDER BY절과 WHERE조건절 함께 사용하기2
--       (정렬 조건 하나이상 설정가능)
-- 그룹 평균키(height열에 저장된 데이터들)가  큰(내림차순) 순서대로 조회하되,
--  같은 평균키를 가진 그룹들이 있으면, 데뷔일자가 빠른순서(오름차순)로 최종!! 정렬해서 조회 
select mem_name, mem_id, height, debut_date
from member
where height >= 164
order by height desc, debut_date asc;

-- -----------------------------------------------------------------------------
-- LIMIT 예약어 : 테이블 저장된 전체 행(row,레코드)중에서
--               원하는 행의 갯수를 정해서 조회할때 사용하는 예약어.
/*
	문법	
		SELECT * FROM 조회할_테이블명
        WHERE 조건식
        ORDER BY 정렬_기준_데이터가_저장된_열명  ASC 또는 DESC
        LIMIT 조회할_행의_갯수를_숫자로_작성;
*/
-- 실습5. member테이블에서 전체 행 데이터(레코드)들 중에서 3개의 행만 잘라서 조회 
select * from member
LIMIT 3; --     0, 3  같은 의미로 
		 -- index, 행갯수
         -- 0 index행 번호 위치의 조회될 행부터 시작해서 3개의 행을 잘라서 최종 조회해옴
-- LIMIT  조회할행의 index위치번호, 몇개의행을 조회할건지 행 갯수;

-- 실습6. member테이블에서 회원그룹평균키가 큰 순(desc)으로 정렬해서 조회하되,
--       정렬해서 조회한 결과 데이터들 중에서
--       3 index위치 행의 레코드 부터 2개의 행(레코드)만 잘라서 조회!
select * from member
order by height desc
limit 3, 2;
-- --------------------------------------------------------------------------
-- DISTINCT 예약어  : 조회할 열의 데이터들이 중복되서 같은이름의 데이터로 조회되면?
--                   중복된 데이터를 1개만 남기고 1개로만 조회시키는 예약어.
--                   요약 :  중복된 열의 데이터가 저장되어 있으면 하나로 조회하는 예약어.
/*
	문법 
		 SELECT DISTINCT 조회할열명
         FROM 조회할테이블명
         WHERE 조건식
         ORDER BY 정렬기준데이터의_열명  정렬방식
         LIMIT 숫자;
*/
-- 실습8. 모든 그룹회원의 사는 지역 조회 
select addr, mem_name
from member;

-- 실습8-1. ORDER BY절을 사용해 같은 지역에 사는 주소들을 기준으로 오름차순 정렬해 조회
select addr, mem_name
from member
order by addr ASC;

-- 실습8-2. DISITNCT 사용해서 열에 중복된 데이터를 하나로 통일해서 하나의 데이터만 조회
select distinct addr
from member
order by addr ASC;
-- -------------------------------------------------------------------------------
/*
	GROUP BY 절
    - GROUP BY절은 데이터베이스에서 데이터를 그룹으로 묶어서 조회하는데 사용되는 예약어.
    - 예를 들어, 같은 날짜에 해당하는 데이터들을 하나의 그룹으로 묶어 관리 할수 있다.
    - GROUP BY절은 보통  SUM, COUNT, AVG 같은 집계함수와 함께 작성해서 사용 해야 합니다.
    - 예를 들어, 각 카테고리별로 판매량의 합계를 구할때 사용합니다.
    - 문법
			SELECT 열명1, 집계함수명(열명2)
            FROM  조회할테이블명 
            GROUP BY 그룹으로묶을_같은데이터가_저장된_열명
            HAVING 조건식 
            ORDER BY 정렬기준열명 정렬방식
            LIMIT 숫자;
	
    -- 제공해 주는 집계함수들
	-- SUM() : 열명을 SUM(열명)로 지정하면 열에 저장된 데이터들을 합계를 하여 반환해 줍니다.
    -- AVG() : 열명을 AVG(열명)로 지정하면 열에 저장된 데이터들을 평균을 구하여 반환해 줍니다.
    -- MIN() : 열명을 MIN(열명)로 지정하면 열에 저장된 데이터들 중에서 최소 작은데이터를 반환해 줍니다.
	-- MAX() : 열명을 MAX(열명)로 지정하면 열에 저장된 데이터들 중에서 가장 큰 최대 데이터를 반환해 줍니다.
    -- COUNT(*) :  모든 열에 관한 행 갯수 반환 해 줍니다.
    -- COUNT(DISTINCT) : 햇의 갯수를 셉니다.(중복된 데이터 1개만 인정)
*/

select * from buy;
-- 실습9.
-- 'buy' 테이블에서 각 mem_id(구매한 그룹회원 아이디)별로 총 구매 수량을 계산해서 
--  계산한 총구매 수량과 각회원 그룹아이디 같이 조회

-- 순서1. 각 회원 그룹단위로 한번 상품 구매시 구매한 수량 조회 
select mem_id as '그룹아이디', amount as '한번 구매시 구매한 수량'
from buy;
-- 순서2. 각 회원 그룹 아이디 단위로 묶어서 한번만 조회된 그룹아이디로 표시 하되
--       (group by 그룹으로묶을_같은데이터가_저장된_열명) 을 이용해서 
--       그룹아이디 단위로 조회되게 묶어서 조회 시키자
/* 
select mem_id as '그룹아이디'
from buy;

로  조회 하면 아래와 같이 조회 결과 가 나온다.  
그런데 그룹 아이디가 중복 조회되어 나온다.
이유는 각 회원 그룹들은 상품 구매를 한번만 한것이 아니기 때문에 
여러 행의 정보중 그룹아이디 만 각각 조회되서 나온것이기때문에
만약  회원그룹 아이디 단위로  구매한 상품 가격들을 합쳐서  
구매한 총상품 구매 수량 구해서  회원 그룹 아이디별로 ~ 총구매 수량만 조회돼서 나오게 해야 한다면? 
group by mem_id; 를 끝에 작성해  
mem_id열에 세로 방향으로 저장된 아이디들을 하나의 회원그룹아이디 단위로 묶어서 하나만 조회되게 시켜야 
각 행의 각각 구매한 상품 수량을 합계한 총상품 구매수량 또한 같이 조회되서 나오게 할수 있을 것이다.
   
그룹아이디
APN
APN
APN
APN
BLK
BLK
BLK
GRL
MMU
MMU
MMU
MMU
*/
-- 순서3. group by mem_id; 를 끝에 작성해
--       mem_id열에 세로 방향으로 저장된 아이디를 하나의 그룹으로 묶어서 하나만 조회되게 시켜보자
select mem_id as '그룹아이디'
from buy
group by mem_id;   --   <------- 이 한줄을 추가 하니 아래의 조회 결과가 달라졌다.

-- 순서4. 'buy'테이블에서 각 mem_id(그룹 회원아이디)별로 총 구매 수량을 계산해서
--        계산한 총 구매 수량과 같이 조회하기 위해 추가! 
--        이때 SUM이라는 집계함수를 작성하여 amount열에 조회되는 모든 행 위치의 열값들을 추출해
--        +  모두 합계 한 회원 그룹 아이디 별 총 구매 수량을 조회하면 같이 보여줄수 있음
select mem_id as '그룹아이디', SUM(amount) as '총_구매수량'
from buy
group by mem_id; 

-- 실습11. 전체 회원그룹이 구매한 총 구매 수량의 평균을 구해서 조회된 결과를 보여주자.
select AVG(amount) as '전체 회원 그룹들이 구매한 상품 수량의 평균' from buy;

-- 실습12. 각~ 회원그룹들이 한번 구매시 몇개의 상품을 각각 구매했는지 평균 구매 갯수 조회
-- 참고. 각~ 회원그룹들을 식별할 유일한 고유값은 mem_id열에 저장된 그룹id를 그룹으로 묶어 주자
select mem_id as '회원그룹아이디',  AVG(amount) as '평균 구매 갯수'
from buy
group by mem_id;

-- 실습13. member테이블에 저장된 그룹회원의 전체 행(레코드, row)의 갯수 조회
select count(*) as '전체 행 갯수' from member;

-- 실습13-1. member테이블에서 연락처(phone1, phone2열에 저장된 데이터들)가 
--          저장되어 있는 그룹의 그룹회원의 레코드(행) 갯수만 조회!
 select count(phone1) '연락처가 저장되어 있는 그룹 행의 수' from member;
 
-- ------------------------------------------------------------------------------
-- HAVING 조건절 
--   		WHERE 조건절 대신 그룹으로 묶어준 데이터의 조건검사하는 구문 

-- 문법
--      SELECT 열명1, 집계함수(열명2) FROM 테이블명
--      GROUP BY 그룹으로묶을_같은데이터가_저장된_열명 
--      HAVING 조건식 
--      ORDER BY 정렬기준데이터가저장된_열명  정렬방식;

-- 실습14. buy테이블에서 조회합니다.
--        회원 그룹 아이디를 그룹으로 묶어서 
--        회원 그룹 아이디 별로 각각 총 구매금액과 그룹아이디열의 데이터 조회 
select mem_id as '회원 그룹아이디', SUM(price * amount) as '총 구매 금액'
from buy
group by mem_id;


-- 실습 14-1. 
-- 위 실습14.는 그룹아이디별로 총구매한 금액을 조회해서 보여줍니다
-- 만약 그룹아이디별로 총구매한 금액이 1000이상이면 사은품을 증정하려고한다면
-- 그룹 아이디별로 총구매한 금액이 1000이상인 그룹의 총구매금액, 그룹아이디를 조회합니다 
select mem_id as '회원 그룹 아이디', SUM(price * amount) as '총 구매 금액' 
from buy
group by mem_id
having  SUM(price * amount)   >=  1000;

-- 실습 14-2. 
-- 위 실습14는 그룹아이디별로 총구매한금액을 조회해서 보여줍니다. 
-- 만약 그룹아이디별로 총구매한 금액이 1000이상이면 사은품을 증정하려고 한다면
-- 그룹아이디별로 총구매한 금액이 1000이상인 그룹을 조회 해야 합니다.
-- 또한 총구매한 금액에 따라 사은품이 다를수 있기떄문에 
-- 총 구매 금액이 큰 순서대로(내림차순정렬) 하여 최종 조회해서 보여줌 
select mem_id as '회원 그룹 아이디', SUM(price * amount) as '총 구매 금액' 
from buy
group by mem_id
having  SUM(price * amount)   >=  1000
order by SUM(price * amount) desc;
-- ---------------------------------------------------------------------------------
-- 연습 **********************************************************************************
-- 1.  회원그룹수 (count)
--     회원그룹 테이블의 총 그룹회원(행,레코드) 수를 계산해서 조회    
SELECT COUNT(*) AS total_members FROM member;

-- 2. 평균 인원수(avg)
--    회원 그룹테이블의 그룹 평균 인원수 계산해서 조회
SELECT AVG(mem_number) AS arverage_members FROM member;

-- 3. 최대 평균키(max)
--    회원그룹 테이블에서 가장 키가 큰 그룹회원의 평균키 조회
SELECT MAX(height) AS tallest_member FROM member;

-- 4. 최소 평균키(min)
--    회원그룹 테이블에서 가장 키가 작은 회원그룹의 평균키 조회
SELECT MIN(height) AS shortest_member FROM member;

-- 5. 구매 수량의 총합(sum)
--    구매 테이블에서 모든 구매 수량의 총합 조회 
SELECT SUM(amount) AS total_amount FROM buy;

-- 6. 각 회원별 구매 수량의 총합
-- 각 회원별로 구매한 총 수량을 계산합니다. mem_id로 그룹화하여 각 회원의 총 구매 수량 조회 
SELECT mem_id, SUM(amount) AS total_amount
FROM buy
GROUP BY mem_id;

-- 7. 각 제품의 평균 가격(avg)
-- 구매한 각 제품별 단가(가격)의 평균을 계산해서 계산한 평균값 조회되게 하기.
-- 참고. 제품 이름으로 그룹화하여 평균 가격을 구합니다.
-- 		구매한 각 제품의 단가(가격)의 평균을 구하는 것입니다. 
--  	즉, 특정 제품이 여러 번 구매되었을 때, 
--  	그 제품의 가격을 모두 더한 후 구매 횟수로 나누어 평균 가격을 계산합니다.
SELECT prod_name,  AVG(price) AS average_price
FROM buy
GROUP BY prod_name;


-- 8. 특정 지역의 그룹 회원 수(count)
-- 각 사는 지역별 그룹명, 그룹회원 수 조회.         
 -- 참고. 지역 주소로 그룹화하여 각 지역의 회원그룹 수를 구합니다.
 SELECT addr,  mem_name, COUNT(*) AS total_members
 FROM member
 GROUP BY addr;
 
-- 9. 구매한 제품의 종류 수(count distinct)
-- 구매 테이블에서 구매한 제품의 종류 수를 계산합니다.
-- 구매 제품 이름에 중복을 제거하여 고유한 제품 수를 구합니다.
/*
전체적인 흐름  참고.
1.구매 데이터 조회: buy 테이블에서 모든 구매 정보를 가져옵니다.
2.중복 제거: prod_name 열에서 중복된 제품 이름을 제거하여 고유한 제품 이름만 남깁니다.
3. 고유 제품 수 계산: 남은 고유한 제품 이름의 수를 세어 unique_products라는 이름으로 결과를 반환합니다.
*/
select COUNT(distinct prod_name) AS unique_products  from buy;
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

-- 10. 구매 테이블에서 상품 분류별 총 구매 수량을 조회 하시오.
--    예 : 디지털 분류 전체 구매 수량,  패션 분류 전체 구매 수량 
/*
    풀이 설명
    1. buy 테이블에서 데이터를 조회한다.
    2. 상품 분류는 group_name 컬럼(열)에 들어 있다.
    3. 같은 상품 분류끼리 묶기 위해 GROUP BY group_name을 사용한다.
    4. 각 상품 분류별 구매 수량의 합계를 구하기 위해 SUM(amount)를 사용한다.
*/
SELECT 
	group_name,                  -- 상품 분류 
    SUM(amount) AS total_amount  -- 분류별 총 구매 수량 
FROM buy
GROUP BY group_name;


-- 11. 구매 테이블에서 상품 분류별 평균가격을 조회 하시오.
--     단, 상품 분류가 NULL인 데이터는 제외하시오.
/*
    풀이 설명
    1. 상품 분류는 group_name 컬럼이다.
    2. group_name이 NULL인 경우는 분류가 없는 데이터이므로 제외한다.
    3. WHERE group_name IS NOT NULL 조건으로 NULL을 제외한다.
    4. GROUP BY group_name으로 상품 분류별로 묶는다.
    5. AVG(price)로 각 분류별 평균 가격을 구한다.
*/
SELECT 
	 group_name,  			   -- 상품 분류 
     AVG(price) AS avg_price   -- 분류별 상품 가격
FROM buy
WHERE group_name IS NOT NULL
GROUP BY group_name;


-- 12. 구매 테이블에서 회원별 구매 건수를 조회 하시오.
--     구매 건수란 buy테이블에 저장된 구매 기록의 갯수를 의미 한다. 
/*
    풀이 설명
    1. 회원 아이디는 mem_id 컬럼(열)이다.
    2. 같은 회원끼리 묶기 위해 GROUP BY mem_id를 사용한다.
    3. COUNT(*)는 각 회원별 구매 기록 개수를 센다.
    4. SUM(amount)는 총 구매 수량이고, COUNT(*)는 구매한 기록의 개수이다.
       둘은 서로 다르다.
*/
SELECT
	mem_id,                 -- 회원그룹 아이디
    COUNT(*) AS order_count -- 회원별 구매 기록 수 
FROM buy
GROUP BY mem_id;


-- 13. 구매 테이블에서 회원별 총 구매 금액을 조회 하시오.
--     총 구매 금액은 가격(price) * 수량(amount)으로 계산하시오.
SELECT
	mem_id,        						-- 회원 그룹 아이디별 
    SUM(price * amount) as total_price  -- 회원 그룹 아이디별 총 구매 금액 
FROM buy
GROUP BY mem_id;


-- 14. 구매 테이블에서 상품별 총 판매 금액을 조회 하시오.
--     총 판매 금액은 가격(price) * 수량(amount)으로 계산하시오.
SELECT
	 prod_name,      					  -- 상품 이름 
     SUM(price * amount)  as total_price  -- 상품 이름 별 총 판매 금액
FROM buy
GROUP BY prod_name;

-- ----------------------------------------------------------------------------------

-- -----------------------------------------
-- 03-3절. 데이터 변경을 위한 SQL문
-- -----------------------------------------
/*
	주제 : 데이터베이스 내부에 만든 특정 테이블에 데이터를 추가(입력)/ 수정 / 삭제 하는 SQL문을 배우자 
    
		INSERT 문 : 테이블에 새로운 행 데이터를 추가(입력)해서 저장할 때 사용되는 SQL문 종류 중 하나 
        
        INSERT 문 작성 기본 문법
			
			   insert into 테이블명(추가할값이저장될_열명1,           열명2,           열명3)
						   values(   열명1에 추가할_값1, 열명2에 추가할값2, 열명3에 추가할값3);
                           
			   insert into 테이블명(열명1, 열명2, 열명3) 
						   values(값1,   값2,  값3);
*/
-- market_db 데이터베이스 사용하기 위해 선택
USE market_db;
/*
	테이블 생성 문법
    
		create table 생성할테이블명(
        
			생성할열명1   열1에저장할데이터유형,
            생성할열명2   열2에저장할데이터유형,
            .......
        );

*/
-- hongong1 이라는 이름의 테이블 생성
create table hongong1(	
	toy_id       INT,  -- 장난감 아이디 
	toy_name CHAR(4),  -- 장난감 이름 
    age          INT   -- 장난감 나이 
);
-- hongong1 테이블에 저장된 모든 열의 데이터 조회 
select * from hongong1;

-- hongong1 테이블에 하나의 행(row,레코드) 을 추가하여 저장 
insert into hongong1(toy_id, toy_name, age)
			  values(     1,    '우디',  25);

-- hongong1 테이블에 toy_id열과 toy_name열에만 데이터를 추가하여 저장할 값 넣어보자
insert into hongong1(toy_id, toy_name) values(2,  '버즈');

-- hongong1 테이블에 열명의 순서를 바꿔서 추가로 행을 저장
-- 주의 할점은 테이블명()사이에 작성한 열명의 순서에 맞게 values()사이에 저장할값 넣어서 추가해야 합니다. 
insert into hongong1(toy_name, age, toy_id) 
              values(   '제시',  20,      3);

-- hongong1 테이블에 (열명1, 열명2, 열명3) 을 생략하고 
-- values(열_추가값1, 열_추가값2, 열_추가값3) 구문만 작성해 새로운 행 데이터를 추가 할수 있다. 
-- 단! 주의 할점 은 테이블 생성시 작성한 열명 순서에 맞게 추가할값 들을 작성 해야 합니다. 
--                         toy_id, toy_name,  age
insert into hongong1 values(4    ,    '영구',  30);

/*
  AUTO_INCREMENT 예약어
	- 테이블을 새로 생성할때 열이름  뒤에 설정하는 예약어로 
      열 에 대한 값을 INSERT문장으로 추가하지 않아도 
      자동으로 1씩 증가되면서 추가가 되게 하는 예약어.
*/





















