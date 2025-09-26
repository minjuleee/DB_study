-- 정규화 연습
-- hptl_mast
-- hptl_mast는 현재 PK가 없지만 hptl_nm이 PK라고 하더라도
-- PK가 단일컬럼이기 때문에 진부분 집합이 없다 -> 2차 정규화 대상 X
-- 3차 정규화 대상 -> typ_cd로 결정되는 typ_cd_nm
-- 3차 정규화 대상 -> sido_cd로 결정되는 sido_cd_nm
-- 3차 정규화 대상 -> siggu_cd로 결정되는 siggu_cd_nm

-- 사전 테스트
-- typ_cd의 종류와 그에 따른 typ_cd_nm을 모두 출력하시오.
select distinct typ_cd, typ_cd_nm
FROM hptl_mast
;

select typ_cd, typ_cd_nm
from	hptl_mast
group by typ_cd, typ_cd_nm 
;

-- typ_cd와 typ_cd_nm을 보관하는
-- typ_cd_dtl을 만드시오.
create table typ_cd_dtl as
select distinct typ_cd, typ_cd_nm
from	hptl_mast
;

-- sido_cd_dtl, siggu_cd_dtl
create table sido_cd_dtl as
select distinct sido_cd, sido_cd_nm
from hptl_mast
;

create table siggu_cd_dtl as
select distinct siggu_cd, siggu_cd_nm
from hptl_mast
;

select * FROM typ_cd_dtl;
select * FROM sido_cd_dtl;
select * FROM siggu_cd_dtl;

-- 작업 전 테이블은 반드시 백업
-- 실제 백업은 CTAS보다는 export를 사용
create table hptl_mast_bak as
select *
from hptl_mast
;

-- 컬럼 drop
alter table hptl_mast drop column typ_cd_nm;
alter table hptl_mast drop column sido_cd_nm;
alter table hptl_mast drop column siggu_cd_nm;

-- 테이블 확인
select * from hptl_mast;

select count(*)
from hptl_mast
where hptl_nm like '%사랑%치과%'
;

-- join
-- table 2개 생성
create table acc_sum
(
	id	varchar(10),
	amt	int(15)
);
insert into acc_sum values('m1', 2874);
insert into acc_sum values('m2', 4221);

select * from acc_sum;

create table member_cls
(
	cls		varchar(10),
	min_amt	int(15),
	max_amt	int(15)
);
insert into member_cls values('black', 2500, 2999);
insert into member_cls values('red', 3000, 5000);

select * from member_cls;

-- m1이라는 회원은 무슨 등급인지 구하시오.
select	s.id, c.cls
from	acc_sum s, member_cls c
where	s.amt between c.min_amt and c.max_amt
;

-- join 조건 없이 의도적으로 catesian product를 발생시키는 경
with ye as (
	select '2023' as yyyy from dual
	union all
	select '2024' as ya from dual
	union all
	select '2025' from dual
), mon as (
	select '01' as mm from dual union all
	select '02' as mm from dual union all
	select '03' as mm from dual union all
	select '04' as mm from dual union all
	select '05' as mm from dual union all
	select '06' as mm from dual union all
	select '07' as mm from dual union all
	select '08' as mm from dual union all
	select '09' as mm from dual union all
	select '10' as mm from dual union all
	select '11' as mm from dual union all
	select '12' as mm from dual
)
select concat(ye.yyyy, mon.mm) as yyyymm
from	ye, mon 
order by yyyymm 
;


-- 정규화 3단계를 통해 테이블이 분할되었다.
-- 강원도에 있는 상급종합 병원의 병원명, 시군구명, 주소를 구하시오.
-- bak 테이블은 이용하지 마시오.
-- hptl_mast, typ_cd_dtl, sido_cd_dtl, siggu_cd-dtl
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

select * 
from hptl_mast
;




