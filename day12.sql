-- SQL Exercise
select * from stadium;
select * from team;
select * from schedule;

-- 1. scheudle 테이블에서 3줄의 데이터만 살펴보시오.
select *
from schedule
limit 3
;

-- 2. scheudle의 총 건수를 구하시오.
select count(*)
from schedule
;

-- 3. 2012년 7월의 shedule은 몇 개인지?
select count(*)
from SCHEDULE
where SCHE_DATE BETWEEN '20120701' and '20120731'
;

-- 4. 각 팀별 경기 수를 구하시오(홈팀으로 경기할 때)
select hometeam_id
		, (select team_name from team 
			where team_id = s.HOMETEAM_ID ) as '팀 이름'
		, count(*) as '경기수'
from schedule s
group by HOMETEAM_ID 
;

-- 5. 원정팀(away)이 승리한 경기의개수를 구하시오.
select count(*) as '원정팀이 승리한 경기 수'
from schedule
where AWAY_SCORE > HOME_SCORE 
;

-- 6. 원정팀이 이긴 경기의 경기일자, 승리팀, 패배팀을 구하시오.
-- 승리팀과 패배팀은 코드로 표시하시오.
SELECT SCHE_DATE as '경기 일자'
		, AWAYTEAM_ID as '승리팀'
		, HOMETEAM_ID as '패배팀'
from schedule
where AWAY_SCORE > HOME_SCORE 
order by SCHE_DATE 
;


-- 7. 원정팀이 이긴 경기의 경기일자, 승리팀, 패배팀을 구하시오.
-- 승리팀과 패배팀은 팀명으로 표시하시오.
SELECT SCHE_DATE as '경기 일자'
		, (select team_name from team 
			where team_id = s.AWAYTEAM_ID ) as '승리팀'
		, (select team_name from team 
			where team_id = s.HOMETEAM_ID ) as '패배팀'
from schedule s
where AWAY_SCORE > HOME_SCORE 
order by SCHE_DATE 
;	


-- 8. 홈 원정 구분없이 가장 많이 경기를 한 팀과 경기수를 구하시오.
--    경기가 이미 종료된 것만 대상(gubun = 'Y')
with schedule_tot as (
	select	hometeam_id as team_id
	from	SCHEDULE
	where	gubun = 'Y'
	union all
	select	awayteam_id as team_id
	from SCHEDULE
	where	gubun = 'Y'
)
select	team_id, count(*)
from	schedule_tot
group by team_id 
order by count(*) desc
limit 1
;


-- 9. 전체 경기 중 홈팀이 승리한 경기의 비율, 무승부인 비율, 
--    원정팀이 승리한 경기의 비율을 구하시오. 단, 경기가 끝난 것 대상
with tot as (
	select	count(*) as total_cnt
	FROM 	SCHEDULE
	where	gubun = 'Y'
),
home_win as (
	select	count(*) as win_cnt
	from	SCHEDULE
	where	gubun = 'Y'
	and		home_score > away_score
),
home_away as (
	select	count(*) as draw_cnt
	from	SCHEDULE
	where	gubun = 'Y'
	and		home_score = away_score
),
home_lose as (
	select	count(*) as lose_cnt
	from	SCHEDULE
	where	gubun = 'Y'
	and		home_score < away_score
)
select	round((home_win.win_cnt/tot.total_cnt) * 100, 2) as '홈팀 승리율'
		, round((home_away.draw_cnt/tot.total_cnt) * 100, 2) as '무승부 비율'
		, round((home_lose.lose_cnt/tot.total_cnt) * 100, 2) as '원정팀 승리율'
from	tot, home_win, home_away, home_lose
;

-- 강사님 풀이
with tot_game as (
	select	count(*) as tot
	from	schedule
	where	gubun = 'Y'
)
select (select count(*)
		from	schedule
		where	home_score > away_score and gubun = 'Y') / tot * 100
		as home_win
		, (select count(*)
		from	schedule
		where	home_score = away_score and gubun = 'Y') / tot * 100
		as draw
		, (select count(*)
		from	schedule
		where	home_score < away_score and gubun = 'Y') / tot * 100
		as away_win 
from	tot_game
;

select
		round(sum(case when home_score > away_score then 1 else 0 end) / count(*) * 100) hw
		, round(sum(case when home_score = away_score then 1 else 0 end) / count(*) * 100) dw
		, round(sum(case when home_score < away_score then 1 else 0 end) / count(*) * 100) aw
from	schedule
where	gubun = 'Y'
;

-- 10. 경기일자, 홈팀 이름, 원정팀 이름을 구하고 마지막 컬럼(res) 에 
--		홈팀이 3점차 이상으로 이긴 경우 "대승리"
--		홈팀이 2점차 이하로 이긴 경우 "승리"
--		비긴 경우 "무승부"
--		진 경우 "망신"
select	sche_date as '경기일자'
		, (select team_name from team where team_id = s.hometeam_id) as Home
		, (select team_name from team where team_id = s.awayteam_id) as Away
		, case when home_score > away_score + 2 then "대승리"
				when home_score > away_score then "승리"
				when home_score = away_score then "무승부"
				else "망신" end as res
from 	schedule s
where	gubun = 'Y'
;


-- 11. 10번 결과를 바탕으로
--		대승리, 승리, 무승부, 망신이 각각 몇 경기인지 구하시오.
--		단, 결과 정렬은 대승리 > 승리 > 무승부 > 망신 순으로 하시오.
with base as (
	select distinct awayteam_id as team_id from schedule
	union
	select distinct hometeam_id as team_id from schedule
), wstats as (
	select case when away_score > home_score then awayteam_id
				else hometeam_id end as team_id
	from schedule
	where gubun = 'Y'
	and	away_score <> home_score
), lstats as (
	select case when away_score < home_score then awayteam_id
				else hometeam_id end as team_id
	FROM schedule
	where gubun = 'Y'
	and	away_score <> home_score
)
select	(select team_name from team where team_id = b.team_id) team_name
		, (select count(*) from wstats where team_id = b.team_id) wcnt
		, (select count(*) from lstats where team_id = b.team_id) lcnt
		, (select count(*) from wstats where team_id = b.team_id) /
		((select count(*) from wstats where team_id = b.team_id) 
			+ (select count(*) from lstats where team_id = b.team_id)) * 100 as wratio
from	base b
order by wratio desc
;







