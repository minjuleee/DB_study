-- lpad, rpad
-- 
select 10, lpad(10, 15, 0)
from	dual;

-- movie_n 테이블의 rating을 display하되,
-- 3자리 미만이면 0을 넣어서 3자리로 맞추시오.
select	lpad(rating, 3, 0)
		, concat(rpad(movie_name, 20, ' '), ';', open_date) as date
from	movie_n
;

-- 영화제목과 개봉일을 출력하되
-- 개봉일은 극비이니 연도+****의 형태로 출력하시오.
select movie_name
-- 	, concat(substr(open_date, 1, 4), '****') as date
-- 	, rpad(substr(open_date, 1, 4), 8, '*') as date
	, concat(rpad(open_date, 4), '****') as date
from	movie_n
;

-- replace
-- 
with sample as (
	select '도더리가 그건 네 자유지 라고 말했다.' as txt
	from	dual
)
select	replace(txt, '그건 네 자유지', 'That is your freezone')
		as modified_txt
from	sample;

-- 실습
-- 강원도에 있는 병원의 이름을 출력하되
-- 대학교 -> univ.로 변경해서 구하시오.
-- 20개의 병원만 출력하시오.
select hptl_nm
		, replace(hptl_nm, '대학', 'univ.') as new_nm
from	hptl_mast
limit	20
;

-- 실습과제
-- 첫 줄에는 서울에 있는 총 병원 수
-- 두 번째 줄에는 서울에 있는 병원의 평균 의사 수
-- 세 번째 줄부터는 서울에 있는 병원이름과 의사 수
select '서울의 병원 수' as title
		, count(*)
from	hptl_mast
where	sido_cd_nm = '서울'
union all
select	'평균 의사 수' as title
		, avg(doc_num)
from	hptl_mast
where	sido_cd_nm = '서울'
union all
SELECT '--------------------------', '-----------------'
from dual
union all
SELECT hptl_nm, doc_num
FROM hptl_mast
where sido_cd_nm = '서울'
;

-- 실습과제(GOD)
-- sido_cd_nm별 병원 수를 구하고, 병원 수가 많은 것부터 나열하고
-- 마지막 컬럼에는 최대 병원수를 가진 시도 대비 비율을 출력하시오.
SELECT sido_cd_nm as "병원 수"
	, COUNT(*)
from 	hptl_mast
group by sido_cd_nm 
order by count(*) desc
;
union all
select 

with cnt_by_sido as (
	select sido_cd_nm, count(*) as cnt
	from	hptl_mast
	group by sido_cd_nm
), max_by_sido as (
	select max(cnt) as cnt
	from	cnt_by_sido
)
select 	sido_cd_nm
		, cnt
		, concat(ROUND(cnt / (select cnt from max_by_sido) * 100, 1), '%') ratio
from	cnt_by_sido 
order by cnt desc
;











