-- DB 살아잇는 확인 
select 1 from dual;

-- 이름에 특수문자가 포함되는 경우
insert into movie(movie_name) values('Day\'s Dream');
insert into movie(movie_name) values('Day\'s Dream2');

-- value도 표준 문법으로 동작함 
insert into movie(movie_name) VALUE ("Day's Dream4");

-- 테이블의 모든 데이터를 지우는 방법
truncate table movie;

-- truncate table이 risky한 경우
-- 빈 테이블 생성을 함(원 테이블고 동일한 레이아웃) -> 나중에 2의 방법 소개 
-- 테이블 exchange 

insert into movie values('파묘', '20240222', 12, 'Horror');
insert into movie values('오리엔트특급살', '20171119', 12, 'Drama');
insert into movie(movie_name, genre) values('반칙의제왕', 'Comedy');

select *
from movie
where 1 = 1
-- and  감독은 누구?
-- and 주연배우는 누구?
-- and 개봉일은 언제?
;

-- SQL 기본 작성법 - 주석 한방에 돼서 
select movie_name
	, open_date
	, genre
from movie
;


