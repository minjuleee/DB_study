-- Aggregate Function
select * from movie;

-- movie 테이블의 건수
select	count(*)
from 	movie
;

-- movie의 장르를 다 보여줘(중복 제외)
select	distinct genre
FROM	movie
;

-- movie 테이블에서 영화제목이 아바타로 시작하는 영의 개수를 구해봐
select count(*)
from	movie
WHERE	movie_name like '아바타%'
;

-- rating과 genre의 종류는 어떤 것들이 있는가?
-- distinct는 뒤에 나오는 모든 컬럼의 조합이 유니크한지 체크
select distinct rating, genre
from	movie
;

-- 장르는 총 몇 종류?
select count(distinct genre)
from	movie
;

-- 12세 이상 관람가인 영화의 장르는 몇 종류?
select count(distinct genre)
from	movie
where	rating >= 12
;

-- 다양한 집계 함수
SELECT 	min(rating), max(rating)
		, avg(rating), sum(rating)
		, variance(rating) as "분산"
		, round(std(rating), 1) as "표준편차(소수점1자리까지)"
from	movie
;

-- 다양한 SQL 연습
-- 1단계 데이터 준비 - movie껍데기만 가지고 오
create table movie_n as 
select *
from	movie
where	1 = 0
;

insert into movie_n values('무제01', '19991201', 12, 'romance');
insert into movie_n values('무제02', '19751001', 19, 'ani');
insert into movie_n values('무제03', '20011201', 15, 'musical');
insert into movie_n values('무제04', '19741201', 12, 'romance');
insert into movie_n values('무제05', '20101201', 15, 'ani');
insert into movie_n values('무제06', '20201201', 00, 'musical');
insert into movie_n values('무제07', '20231201', 12, 'romance');
insert into movie_n values('무제08', '20111201', 15, 'musical');
insert into movie_n values('무제09', '20151201', 19, 'ani');
insert into movie_n values('무제10', '20181201', 00, 'romance');

select count (*)
FROM 	movie_n
;

-- 장르를 대문자로 업데이트하시오.
update	movie_n
set		genre = upper(genre)
;


-- 개봉일자가 오래된 것부터 나열
select *
from	movie_n
order by	open_date
;

-- 등급을 오름차순, 등급이 같으면 개봉일자 내림차순으
select *
from	movie_n
order by rating, open_date DESC
;

-- 2000년 이후 영화는 '최신'
-- 이전 영화는 '고전'으로 표시되는 결과를 만드시오.
-- 영화제목, 개봉일, 최신구분을 출력하되
-- 개봉일 역순으로 배열하시오.
-- 1번 방법 - 추천!
select movie_name, open_date
	, case when open_date > '19991231' then '최신'
		else '고전' end as '최신구분'
from movie_n
order by open_date desc
;

-- 2번 방법
with mov as (
	select	movie_name, open_date, '최신' as '최신구분'
	from	movie_n
	where	open_date >='20000101'
	union all
	select	movie_name, open_date, '고전' as '최신구분'
	from	movie_n
	where	open_date < '20000101'
)
select *
FROM mov 
order by open_date desc
;

select *
from movie_n
;


















