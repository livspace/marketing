select

ct.display_name as "City",
date(prs.created_at) as "Date",
count(*) as "Total Leads",
sum(case when ps.weight>=100 then 1 else 0 end) as "Effective Leads",
sum(case when ps.weight>=250 then 1 else 0 end) as "Qualified Leads",
sum(case when ps.weight>=270 then 1 else 0 end) as "Pitch Sent",
sum(case when prss.project_id is not null then 1 else 0 end) as "Completed Leads",
count(distinct (case when date_diff('day', prs.created_at, pe.created_at) <=7 then prs.id end)) as "<=7",
sum(case when date_diff('day', prs.created_at, pe.created_at) <=14 and date_diff('day', prs.created_at, pe.created_at) > 7 then 1 end) as ">7 and <=14"

from launchpad_backend.projects prs 
left join (
select prs.id as "project_id" from launchpad_backend.projects prs
left join (select (case when (user_id SIMILAR TO 'CX%' OR user_id SIMILAR TO 'UX%') THEN REGEXP_SUBSTR(user_id, '[0-9]+', 1) else user_id END) as user_id from javascript.identifies group by user_id) as jp on prs.customer_id=jp.user_id

where jp.user_id is not null
group by prs.id
) prss on prss.project_id =prs.id
join launchpad_backend.cities ct on ct.id=prs.city_id

join launchpad_backend.project_stages ps on ps.id=prs.stage_id
left join (select project_id,min(created_at) as "created_at" from launchpad_backend.project_events where new_value=9 and event_type = 'STAGE_UPDATED' group by project_id) pe on pe.project_id = prs.id 


WHERE 
prs.created_at > current_date - interval '30 day'
AND (prs.lead_source_id not in (161,162,163,164,15) or prs.lead_source_id is null)


group by ct.display_name,date(prs.created_at)

order by ct.display_name asc,date(prs.created_at) asc
