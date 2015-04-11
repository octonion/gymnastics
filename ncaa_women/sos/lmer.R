sink("diagnostics/score.txt")

library(RPostgreSQL)

#library(betareg)
#library(lmtest)
library(lme4)

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname="gymnastics")

query <- dbSendQuery(con, "
select
t.team_name||'/'||ir.first_name||' '||ir.last_name as name,
s.home_away as field,
ir.match_number,
ir.all_around as score
from ncaa.individual_results ir
join ncaa.schedules s
  on (s.team_id,s.match_number)=(ir.team_id,ir.match_number)
join ncaa.teams t
  on (t.team_id)=(ir.team_id)
where vault is not null
;")

games <- fetch(query,n=-1)

dim(games)

games$match_number <- as.factor(games$match_number)

fit <- lmer(log(score) ~ field+(1|name)+(1|match_number), data=games)

fit
summary(fit)
fixef(fit)
ranef(fit)
#lrtest(fit0,fit)
#waldtest(fit0,fit)
