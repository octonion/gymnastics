#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'gymnastics';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb gymnastics;"
   eval $cmd
fi

psql gymnastics -f schema/create_schema.sql

cp csv/teams.csv /tmp/teams.csv
psql gymnastics -f loaders/load_teams.sql
rm /tmp/teams.csv

cp csv/schedules.csv /tmp/schedules.csv
rpl -q "-" "" /tmp/schedules.csv
rpl -q '""' '' /tmp/schedules.csv
psql gymnastics -f loaders/load_schedules.sql
rm /tmp/schedules.csv

cp csv/individual_results.csv /tmp/individual_results.csv
rpl -q "-" "" /tmp/individual_results.csv
rpl -q '""' '' /tmp/individual_results.csv
psql gymnastics -f loaders/load_individual_results.sql
rm /tmp/individual_results.csv

#tail -q -n+2 csv/ncaa_games_*.csv > /tmp/ncaa_games.csv
#psql gymnastics -f loaders/load_ncaa_games.sql
#rm /tmp/ncaa_games.csv

#cat ncaa/ncaa_players_*.csv > /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ".," "," /tmp/ncaa_statistics.csv
#rpl ".0," "," /tmp/ncaa_statistics.csv
#rpl ".00," "," /tmp/ncaa_statistics.csv
#rpl ".000," "," /tmp/ncaa_statistics.csv
#rpl -e ",-\n" ",\n" /tmp/ncaa_statistics.csv
#psql gymnastics -f load_ncaa_statistics.sql
#rm /tmp/ncaa_statistics.csv

#psql gymnastics -f create_ncaa_players.sql
