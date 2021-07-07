truncate table f_id_seed;
drop table f_id_seed;

create table f_id_seed(
	seq_id		number(19)		primary key,
	seed		char(5)
);

CREATE OR REPLACE FUNCTION get_id(intSeed NUMBER) RETURN char
IS
	ret char(5);
BEGIN
	select seed into ret from f_id_seed where seq_id = intSeed;
	RETURN ret;
END;

select get_id(15) from dual;