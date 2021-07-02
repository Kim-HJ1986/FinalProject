create table s_hashtag(
	id				number(9)			primary key,
	super_id		number(9)			references s_hashtag(id),
	hashtag			varchar2(100),
	description		varchar2(1000)
);

create table sm_ht2post(
	hashtag_id		number(9),
	post_id			varchar2(4000),
	occur_cnt		number(9),
	primary key(hashtag_id, post_id)
);

create table s_post(
	id				varchar2(4000)		primary key,	
	board_id		number(9)			REFERENCES s_board(id),
	writer_id		varchar2(10)		REFERENCES s_party(user_id),
	title			varchar2(100),
	content			varchar2(4000),
	read_cnt		number(9)			default 0,
	like_cnt		number(9)			default 0,
	dislike_cnt		number(9)			default 0,
	reg_dt			timestamp			default sysdate not null,
	upt_dt			timestamp			default sysdate not null
);


--검색어 기반 게시글 조회
--검색어 예시 : 장난 객체
select id
  from s_hashtag
 where hashtag in('지향', '객체')

--검색어 '장난', '객체'로 이 단어가 적용된 게시글 id를 찾으시오 
select distinct post_id
  from sm_ht2post
 where hashtag_id in (
 	   select id
  		 from s_hashtag
	    where hashtag in('지향', '객체'));
	    
--상기 문제를 join으로 만들기
select distinct post_id
  from s_hashtag w,  sm_ht2post m
 where w.hashtag in('지향', '객체')
   and w.id = m.hashtag_id;
	    
--검색어 "지향, 객체"로 이 단어가 적용된 게시글과 작성자 정보를 찾아서
--해당 페이지의 내용을 최신 작성글 순서로 출력하시오.
select distinct p.*, w.*
  from s_hashtag h, sm_ht2post m, s_post p, s_party w
 where h.hashtag in ('지향', '객체')
   and h.id = m.hashtag_id
   and m.post_id = p.id
   and p.writer_id = w.user_id
 ORDER BY p.id DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


--단어 사이의 상속 구조를 이용한 강력 검색 기능
insert into s_hashtag(id, hashtag)
	values(-1001, 'element');
insert into s_hashtag(id, hashtag)
	values(-1000, 'feature');

update s_hashtag
   set super_id = -1001
   where id = -1000;
   
update s_hashtag
   set super_id = -1000
   where id in(47, 48);
   
--단어 'element'를 s_hashtag에서 검색하면 그 결과는 {'element','feature', '객체', '지향'}이다.
select hashtag, id
  from s_hashtag
  start with hashtag in ('element', '객체', '지향')
  CONNECT BY PRIOR id = super_id;
  
--검색어 'element 객체 지향'으로 단어가 계층적으로 적용된 게시글과 작성자 정보를 찾아서
--해당 페이지의 내용을 최신 작성글 순서로 출력하시오 

select distinct p.*, w.*
  from  s_party w, s_hashtag h, sm_ht2post m, s_post p
 where h.id in  (
 	select id
 	  from s_hashtag
  	start with hashtag in ('element', '객체', '지향', '강사') 
	 CONNECT BY PRIOR ID = super_id)
  and h.id = m.hashtag_id
  and m.post_id = p.id
  and p.writer_id = w.user_id
 order by p.id desc
 OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY
 
--갯수세기 
select count(distinct p.id) 
		  from s_hashtag h, sm_ht2post m, s_post p
	 	 where h.id in  (
	 		select id
	 	      from s_hashtag
	         start with hashtag in ('element', '객체', '지향', '강사') 
		   CONNECT BY PRIOR ID = super_id)
		  and h.id = m.hashtag_id
		  and m.post_id = p.id
		  and p.board_id = 3
 
 
 
 
 
  
  
  
  
  
  