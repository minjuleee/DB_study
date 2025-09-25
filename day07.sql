-- rating별로 영화 수 구하기
-- 영화 수가 2개 초과인 rating만 출력
-- ~별 > group by
with cstat as (
	select rating, count(*) as cnt
	from movie_n
	group by rating
)
select *
from	cstat 
where	cnt > 2
;

-- having 절을 사용할 때할
select rating, count(*)
from movie_n
group by rating
having	count(*) > 2 
;

-- rating별, 개봉연도별 영화 수 구하기
-- 개수가 많은 것부터, 개수가 동일하면 개봉연도가 최신부터
select rating
		, substr(open_date, 1, 4) open_year
		, count(*)
FROM	movie_n
group by rating, open_year
order by count(*) desc, open_year desc
;

-- 2000년 이전 작품은 고전, 2000년 이후 작품은 최신으로 분류하고
-- 고전, 최신이 각각 몇 개인지 구하기
select case when open_date >= '20000101' then '최신'
			else '고전' end as gubun
			, count(*)
from	movie_n
group by 1
-- group by gubun
;

-- Challenge(Difficulty : Hard)
-- 영화 통계를 구하되,
-- 2000년 이전, 2000년대, 2010년대, 2020년대의 개수를 구하시오.
select case when open_date < '20001231' then '2000년 이전'
			when open_date between '20000101' and '20091231' then '2000년대'
			when open_date between '20100101' and '20191231' then '2010년대'
			when open_date between '20200101' and '20291231' then '2020년대'
			else '기타' end as gubun
			, count(*)
from	movie_n
group by gubun
order by gubun
;

-- difficulty : GOD
-- 가로로 출력되도록 작성하시오.
-- 2000년 이전	2000년대		2010년대		2020년대
--		   3		  1			  4			  2
select genre, sum(case when open_date < '20000101'
				then 1
				else 0 END) as '2000년 이전'
		, sum(case when open_date between '20100101' and '20191231'
				then 1
				else 0 END) as '2010년'
		, sum(case when open_date between '20200101' and '20291231'
				then 1
				else 0 END) as '2020년'
from	movie_n
group by genre
;
-- 2번째 방
SELECT count(if(open_date <= '19991231', 1, 0)) as '2000년대 이전'
	, count(if(open_date between '20000101' and '20091231', 1, 0)) as '2000년대 이전'
	, count(if(open_date between '20100101' and '20191231', 1, 0)) as '2010년대 이전'
	, count(if(open_date between '20200101' and '20291231', 1, 0)) as '2020년대 이전'
from	movie_n
;


-- 병원 데이터 실습
-- 1. data load 확인
select *
from	hptl_mast
limit 10
;

select count(*)
from	hptl_mast
;
-- 77,139건

-- 3. secu_key_cd 컬럼 삭제
alter table hptl_mast drop column secu_key_cd;

-- 4. Welcome Drink
-- 병원 이름이 서울로 시작하는 병원의 비율은?
-- 내가 푼
select (
select count(*)
FROM 	hptl_mast
where 	hptl_nm like '서울%'
) / count(*) * 100
from	hptl_mast
;

-- 강사님 정답
select round(sum(case when hptl_nm like '서울%' 
			then 1 else 0 end) / count(*) * 100, 2)
		as ratio
from	hptl_mast
-- where	sido_cd_nm = '서울' // 서울에 있는 곳 중 (옵션) 
;




