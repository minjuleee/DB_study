-- outer join
-- 2023년 12월부터 2024년 12월까지
-- 개봉월별 건수를 출력하시오.

select	substr(open_date, 1, 6), count(*)
from	movie_n
where	open_date between '20231201' and '20241231'
;

with cal as (
	select '202312' as yyyymm from dual union all
	select '202401' as yyyymm from dual union all
	select '202402' as yyyymm from dual union all
	select '202403' as yyyymm from dual union all
	select '202404' as yyyymm from dual union all
	select '202405' as yyyymm from dual union all
	select '202406' as yyyymm from dual union all
	select '202407' as yyyymm from dual union all
	select '202408' as yyyymm from dual union all
	select '202409' as yyyymm from dual union all
	select '202410' as yyyymm from dual union all
	select '202411' as yyyymm from dual union all
	select '202412' as yyyymm from dual
)
select	c.yyyymm, sum(case when n.open_date is null then 0 else 1 end)
from	cal c left outer join movie_n n
				on c.yyyymm = substr(n.open_date, 1, 6)
group by c.yyyymm
;

with member as (
	select 'm1' as id, 1000 as amt from dual union all
	select 'm2' as id, 2000 as amt from dual union all
	select 'm3' as id, 3000 as amt from dual union all
	select 'm4' as id, 4000 as amt from dual union all
	select 'm5' as id, 5000 as amt from dual
)
select m.id, case when c.cls is null then '등급없음'
				else c.cls end as rate
from	member m left outer join member_cls c
				on m.amt between c.min_amt and c.max_amt 
order by m.id
;


-- subquery
select h.hptl_nm, h.addr
from	hptl_mast h
where	h.sido_cd = ( select sido_cd
						from sido_cd_dtl
 						where sido_cd_nm = '강원')
;

select h.hptl_nm, h.addr
from	hptl_mast h
		,( select sido_cd
			from sido_cd_dtl
			where sido_cd_nm = '강원') as sido
where	h.sido_cd = sido.sido_cd
;

-- scalar subquery
select	h.hptl_nm , c.siggu_cd_nm, h.addr
from	hptl_mast h
		, typ_cd_dtl t
		, sido_cd_dtl s
		, siggu_cd_dtl c
where	t.typ_cd_nm = '상급종합'
and		t.typ_cd = h.typ_cd
and		s.sido_cd_nm = '강원'
and		s.sido_cd = h.sido_cd
and		c.siggu_cd = h.siggu_cd
;

select	h.hptl_nm 
		,(select siggu_cd_nm
			from siggu_cd_dtl
			where siggu_cd = h.siggu_cd 
			limit 1) as siggu_cd_nm
		, h.addr
from	hptl_mast h
		, typ_cd_dtl t
		, sido_cd_dtl s
-- 		, siggu_cd_dtl c
where	t.typ_cd_nm = '상급종합'
and		t.typ_cd = h.typ_cd
and		s.sido_cd_nm = '강원' 
and		s.sido_cd = h.sido_cd
-- and		c.siggu_cd = h.siggu_cd
;

-- exists와 in
-- 의사 수가 0인 병원을 blacklist라고 생성
create table blacklist as
select	hptl_nm, sido_cd, siggu_cd
from	hptl_mast
where	doc_num = 0
;

-- 서울에 잇는 병원 중 blacklist에 존재하지 않는 병원
select 	count(*)
from	hptl_mast h
		, sido_cd_dtl s
where	s.sido_cd_nm = '서울'
AND		s.sido_cd = s.sido_cd 
and		not exists (select 1
					from blacklist
					where hptl_nm = h.hptl_nm)
and		(hptl_nm, siggu_cd) in (select hptl_nm, siggu_cd
								from	blacklist)
;

