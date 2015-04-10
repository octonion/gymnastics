select t.team_name,
first_name,
last_name,
avg(vault)::numeric(4,3),
count(*) as n
from ncaa.individual_results ir
join ncaa.teams t
  on (t.team_id)=(ir.team_id)
group by t.team_name,first_name,last_name
order by avg(vault) desc nulls last;
