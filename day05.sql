select *
from	movie
;

-- 1. case when
-- 장르를 한글로 만들어 출력하시오.
-- Horror>공포, Drama>드라마, Fantasy> 판타지로 변경하
-- 영화이름과 한글장르를 출력하시오.
select movie_name
	, case when genre = 'Horro' then '공포'
			when genre = 'Drama' then '드라마'
			when genre = 'Fantasy' then '판타지'
			else '기타' end as 'KOR_GENRE'
from	movie
;

-- open_date가 2020년 이전이면 '고전'
-- 				2024년이면 '최신'
--				2024년 이후이면 '미래'
-- 로 구분하여 영화제목과 구분을 출력하시오.
select movie_name
	, case when open_date < '20200101' then '고전'
			when open_date like '2024%' then '최신'
			when open_date > '20241231' then '미래'
			else '기타' end as '구분'
from	movie
;

-- 2. with절의 활용
WITH old_movie as
(
	select 	movie_name, genre
	from	movie
	WHERE	open_date < '20200101'
), old_action_movie AS 
(
	select *
	from	old_movie 
	where	genre = 'Action'
), old_drama_movie AS 
(
	SELECT  *
	from	old_movie 
	WHERE	genre = 'Drama'
),
select *
from	old_movie om
where	om.genre = 'Action'
;

WITH old_movie as
(
	select 	*
	from	movie
	WHERE	open_date < '20200101'
), comedy_movie as
(
	select *
	FROM	movie
	where 	genre = 'Comedy'
), old_old_movie as
(
	select *
	from	old_movie
	where	open_date < '19500101'
)
select *
from	old_movie 
union	-- 중복된 항목은 없앤 합집합 cf. union all
select *
from	comedy_movie
;

-- 3. Built-in Functions
-- (1) Single Row Function
-- numberic
select abs(-88.99)
		, ceil(-4.9), ceil(4.9)
		, round(33.897, 2)
		, round(33.897, -1)
		, round(33.897, -2)
from dual
;

-- text
select lower('Maria'), upper('Heidi')
from	dual
;
select movie_name, length(movie_name)	-- 한글은 3글자로 인식
from	movie
;
select movie_name
	, substr(open_date, 1 ,4) as "개봉연도"
	, substr(open_date, 5, 4) as "개봉일자"
	, concat(substr(open_date, 5, 2),'월'
			,substr(open_date, 7, 2),'일') as '알아보기쉬운개봉일'
	, case when substr(open_date, 5, 2) < '10'
			then concat(substr(open_date, 6, 1),'월'
						,substr(open_date, 7, 2),'일')
			else concat(substr(open_date, 5, 2),'월'
						,substr(open_date, 7, 2),'일')
			end as "알아보기쉬운개봉일자2"
from	movie 
;

-- substr에서 두 번째 인자를 주지 않은 경우 끝까지
select substr('Worlds 7 Wonders', 4)
from	dual
;
-- 음수인 경우 우측부
select substr('Worlds 7 Wonders', -4)
from	dual
;

-- to_char, to_date
-- to_date : oracle, str_to_date : mysql
select 	movie_name
		, open_date
		, str_to_date(open_date, '%Y%m%d')
from	movie
;

-- 아바타6의 개봉일을 100일 후로 하면 언제겠는가?
select	open_date
		, str_to_date(open_date, '%Y%m%d')
		, to_char(date_add(str_to_date(open_date, '%Y%m%d')
					, interval 100 day), 'yyyymmdd') as final
from	movie
where	movie_name = '아바타6'
;

-- 위처럼 100일 후로 진짜 업데이트하시오.
update	movie
set		open_date = to_char(date_add(str_to_date(open_date, '%Y%m%d')
					, interval 100 day), 'yyyymmdd')
where	movie_name = '아바타6'
;

select *
from movie
;







