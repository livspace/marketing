select

ct.display_name as "City",
date(prs.created_at) as "Date",
count(*) as "Total Leads",
sum(case when ps.weight>100 then 1 else 0 end) as "Effective Leads",
sum(case when ps.weight>250 then 1 else 0 end) as "Qualified Leads",
sum(case when ps.weight>270 then 1 else 0 end) as "Pitch Sent"

from launchpad_backend.projects prs 

join launchpad_backend.cities ct on ct.id=prs.city_id

join launchpad_backend.project_stages ps on ps.id=prs.stage_id

WHERE 
date(prs.created_at) 
BETWEEN date(date_add(now(), INTERVAL -30 day))
AND date(date_add(now(), INTERVAL -1 day))
AND (prs.lead_source_id not in (161,162,163,164,15) or prs.lead_source_id is null)


group by ct.display_name,date(prs.created_at)
