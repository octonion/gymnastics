begin;

drop table if exists ncaa.individual_results;

create table ncaa.individual_results (
	team_id				integer,
	request_match_number		integer,
	match_number			integer,
	first_name			text,
	last_name			text,
	vault				float,
	uneven_bars			float,
	balance_beam			float,
	floor_exercise			float,
	all_around			float
);

copy ncaa.individual_results from '/tmp/individual_results.csv' csv;

commit;
