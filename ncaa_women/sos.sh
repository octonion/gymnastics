#!/bin/bash

psql gymnastics -c "drop table if exists ncaa.results;"

psql gymnastics -f sos/standardized_results.sql

psql gymnastics -c "vacuum full verbose analyze ncaa.results;"

psql gymnastics -c "drop table if exists ncaa._parameter_levels;"
psql gymnastics -c "drop table if exists ncaa._basic_factors;"

R --vanilla -f sos/lmer.R

psql gymnastics -c "vacuum full verbose analyze ncaa._parameter_levels;"
psql gymnastics -c "vacuum full verbose analyze ncaa._basic_factors;"

psql gymnastics -f sos/normalize_factors.sql
psql gymnastics -c "vacuum full verbose analyze ncaa._factors;"

psql gymnastics -f sos/schedule_factors.sql
psql gymnastics -c "vacuum full verbose analyze ncaa._schedule_factors;"

psql gymnastics -f sos/current_ranking.sql > sos/current_ranking.txt

psql gymnastics -f sos/connectivity.sql > sos/connectivity.txt

psql gymnastics -f sos/division_ranking.sql > sos/division_ranking.txt

psql gymnastics -f sos/test_predictions.sql > sos/test_predictions.txt
