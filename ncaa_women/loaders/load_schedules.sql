begin;

drop table if exists ncaa.schedules;

create table ncaa.schedules (
        request_team_id		integer,
	match_number		integer,
	team_meet_url		text,
	team_id			integer,
	date_month		integer,
	date_day		integer,
	date_year		integer,
        team_name		text,
	team_score		float,
	home_away		text,
	opponent		text,
	opponent_score		float,
	attendance		text,
	judges_url		text,
	primary key (team_id,match_number)
);

copy ncaa.schedules from '/tmp/schedules.csv' with delimiter as ',' csv;

commit;
