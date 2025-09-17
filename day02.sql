-- table creation
create table movie
(
	movie_name	varchar(100),
	open_date	varchar(8) default '99991231',
	rating		int(2)
);

-- movie_name에 pk 설정 
alter table movie add constraint movie_pk
primary key (movie_name);

-- 데이터 넣기 
insert into movie(movie_name) values('귀멸의칼날');
insert into movie(movie_name) values('매트릭스');
insert into movie(movie_name) values('좀비딸');

-- 전체 출력 
select *
from	movie;

-- 오류 : pk에 null 입력 불가 
insert into movie(movie_name, open_date)
valuse (null, '20251231');

-- 오류 : pk로 인한 영화이름 중복 오류 
insert into movie(movie_name)
values('귀멸의칼날');

-- 장르(genre)를 추가해달라고 함
alter table movie add column genre varchar(20);

-- rating을 100세 관람가를 위해 3자리로 변경해달라고 함
alter table movie modify column rating int(3);