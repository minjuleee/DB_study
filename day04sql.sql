-- 결과 건수를 제한할 때 ex) 데이터의 내용 확인할 때 주로 사용
select *
from movie 
limit 10  -- oracle인 경우 where rownum <= 10
;

-- where절
select *
from movie 
where	(open_date >= '20240101'
and		open_date != '99991231')
or 		genre = 'Drama'
;

-- update 문장
-- 반칙의 제왕이 드디어 20250914에 개봉하기로 함
-- select *
-- from movie
update	movie
set		open_date = '20250914'
where	movie_name = '반칙의제왕'
;

-- 관객등급이 12인 영화를 찾아서 10으로 변경하시오.
update	movie
set		rating = 10
where	rating = 12
;

insert into movie(movie_name, open_date)
values('베테랑2', '20240913');

-- delete
-- genre가 없는 영화를 지우고 싶다.
-- SELECT *
-- from movie
-- where genre = '' -- null을 선택하지 못함
-- where genre = '[NULL]' -- null을 선택하지 못함
delete from movie
where genre is null
-- where genre is not null
;

insert into movie
values('아바타3', '20241003', 12, 'Fantasy');
insert into movie
values('아바타4', '20261003', 12, 'Fantasy');
insert into movie
values('아바타5', '20281003', 9, 'Fantasy');
insert into movie
values('아바타6', '20301003', 0, 'Fantasy');

-- rating이 12부터 19인 것
select * 
from movie
where rating >= 12
and rating <= 19
;

-- concat
select concat('나는 생각한다. ', '고로 존재한다.') from dual;

-- Fantasy 장르의 영화명과 개봉일자, 등급을
-- '|' 구분자로 구분하여 하나로 출력하시오.
select	concat(movie_name, '|',
				open_date, '|', 
				rating, '|',genre) as "제공데이터"
from	movie
where	genre = 'Fantasy'
;

-- create table
create TABLE movie2
(
	movie_name	varchar(100)	not null,
	open_date	varchar(8)		default '99991231'
);

-- insert into select
-- 아바타4만 제외하고 데이터를 가져와보기
insert	into movie2
select	movie_name, open_date
from	movie 
where	movie_name != '아바타4'
;

-- CTAS
-- create table as select
-- 1) 아바타4 데이터만 가지고 movie3 테이블을 생성하시오.
create table movie3 as
select *
from	movie
where	movie_name = '아바타4'
;

-- 2) movie2의 컬럼만 가지고 테이블을 생성하시오(movie4)
-- 데이터 불필요
create table movie4 as
select *
from 	movie2
where	1 = 0
;

-- alias
-- 관객등급이 있는 영화의 평균관람가 연령과 영화 개수를 구하시오
select avg(m.r) as "평균관람가 연령"
		, count(*) as "영화 개수"
from (
		SELECT movie_name as mn
			, rating as r
		from	movie 
		where	rating is not null
	) as m
;

select *
from movie4
;



