-- Analytic Function
-- nice to know
select hptl_nm
	, doc_num
	, rank() over(order by doc_num desc) as "전체등수(rank)"
	, rank() over(partition by sido_cd 
				order by doc_num desc) as "지역내등수"
	, dense_rank() over(order by doc_num desc) as "전체등수(dense_rank)"
	, row_number() over(order by doc_num desc) as "전체등수(row_number)"
	, sum(doc_num) over(partition by sido_cd) as "시도내의사수"
	, sum(doc_num) over(order by doc_num desc
						rows between unbounded preceding
							and		current row) as "누적의사수"
	, avg(doc_num) over(order by doc_num desc
						rows between 2 preceding
							and		2 following) as "5개병원평균"
	, lead(doc_num) over(order by doc_num desc) as "Lead"
	, lag(doc_num) over(order by doc_num desc) as "Lag_num"
	, lag(doc_num) over(order by doc_num desc) - doc_num as "의사수차이"
from hptl_mast
;

-- 각 지역별 의사 수가 가장 많은 병원을 3개씩 구하시오.
	select hptl_nm
		, (select sido_cd_nm
			from sido_cd_dtl
			where sido_cd = b.sido_cd) as "시도명"
		, doc_num
from	base b
where rn <= 3
;

-- sequence
-- cache는 순서가 보장될 필요는 없이 중복만 막고자 할 때 부하 분산가능
create sequence seq_test nocache;

select nextval(seq_test)	-- seq_test.next_val(oracle)
	, hptl_nm
from hptl_mast
limit 10;


-- view
create view big_hptl as
select hptl_nm, typ_cd, addr, doc_num
from hptl_mast
where doc_num > 500
;

select *
from big_hptl
where addr like '경기%'
;

create view hptl_regen as
SELECT	h.hptl_nm
		, t.typ_cd_nm
		, s.sido_cd_nm
		, h.addr
		, h.hptl_url 
from	hptl_mast h
		, typ_cd_dtl t
		, sido_cd_dtl s
WHERE 	h.typ_cd = t.typ_cd
and 	h.sido_cd = s.sido_cd
;

select * 
FROM  hptl_regen
where sido_cd_nm = '서울'
;

-- SQL Exercise
-- 병원 이름에 한의원이 들어가는 병원 중
-- 동일한 이름의 병원이 우리나라에 있는 병원들의 리스트
-- 병원 설립일이 2000년 이전인 병원 


select *
from hptl_mast h
where hptl_nm like '%한의원%'
and open_date < '20000101'
and exists (
					select 1
					from hptl_mast
					where hptl_nm = h.hptl_nm
					AND addr <> h.addr
					and tel_no <> h.tel_no
				)
;

with multiple as (
	select hptl_nm, count(*) cnt
	from hptl_mast
	group by hptl_nm
	having cnt > 1
)
select *
from	hptl_mast h
where	hptl_nm like '%한의원%'
and open_date < '20000101'
and exists (select 1
			from	multiple 
			where hptl_nm = h.hptl_nm)
;

with multiple as (
	select hptl_nm, count(*) cnt
	from hptl_mast
	group by hptl_nm
	having cnt > 1
)
select h.*
from hptl_mast h
	, multiple m
where hptl_nm like '%한의원%'
and open_date < '20000101'
and h.hptl_nm = m.hptl_nm
;

select *
from hptl_mast
;

select * from team;
select * from schedule;














