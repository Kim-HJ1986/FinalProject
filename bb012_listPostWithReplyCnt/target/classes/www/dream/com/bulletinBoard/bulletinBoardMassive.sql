select *
  from s_post;
  
  
insert into s_post(id, board_id, writer_id, title, content)			
select get_id(seq_post_id.nextval), board_id, writer_id, title, content
  from s_post;

  
인덱스가 있는 컬럼을 그대로 사용하면 DB가 인덱스를 활용해 주는데
그 값을 강제적으로 바꾸면 인덱스를 활용하지 못하여 내부적으로
모든 데이터를 읽고 DB안의 메모리에서 정렬을 완료한다.
이 때 엄청난 시간이 소요된다.

select *
  from s_post order by id || 'rrr';


인라인을 통해 보완한 방법.
select *
from(
    select p.*, ROWNUM rn
      from s_post p
     where rownum <= 20
     order by id desc) p
where rn > 10


select p.*, w.name w_name, w.descrim w_descrim
	  from (
	  	  select p.*, rownum rn
	  		from s_post p
	  	   where board_id = 3
	  	     and rownum <= 5*10
	  	   order by id desc
	       ) p, s_party w
	 where p.rn > 40
	   and p.writer_id = w.user_id

delete from sm_ht2post
 where hashtag_id = 47;
 
 
select id
  from s_hashtag
 where hashtag = '객체';


insert into sm_ht2post(hashtag_id, post_id, occur_cnt)
select h.id, p.id, 1
  from s_hashtag h, s_post p
 where h.hashtag = '객체';
 
