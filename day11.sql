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