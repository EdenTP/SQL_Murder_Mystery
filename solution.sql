select 
  * 
from 
  crime_scene_report;
where 
  date = 20180115 
  and city = "SQL City";
/*The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".*/
select 
  * 
from 
  person 
where 
  address_street_name = "Northwestern Dr" 
order by 
  address_number desc 
limit 
  1;
--14887  Morty Schapiro  118009  4919  Northwestern Dr  111564949
select 
  * 
from 
  person 
where 
  address_street_name = "Franklin Ave" 
  and name like '%Annabel%';
--16371  Annabel Miller  490173  103  Franklin Ave  318771143
select 
  * 
from 
  interview 
where 
  person_id = 16371 
  or person_id = 14887;
/*14887  I heard a gunshot and then saw a man run out. 
He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". 
Only gold members have those bags. 
The man got into a car with a plate that included "H42W".
16371  I saw the murder happen, and I recognized the killer from my gym
when I was working out last week on January the 9th.*/
select 
  * 
from 
  get_fit_now_check_in 
where 
  membership_id like '48Z%' 
  and check_in_date = '20180109';
/*
48Z7A  20180109  1600  1730
48Z55  20180109  1530  1700
*/
select 
  * 
from 
  get_fit_now_member 
where 
  id = '48Z7A' 
  or id = '48Z55';
--67318 Jeremy Bowers, 28819 Joe Germuska
select 
  * 
from 
  drivers_license 
where 
  plate_number like '%H42W%';
--183779,423327,664760
select 
  * 
from 
  person 
where 
  id = 67318 
  or id = 28819 
  and (
    license_id = 183779 
    or license_id = 423327 
    or license_id = 664760;
--Final Solution
with gym_evidence as (
  select 
    * 
  from 
    get_fit_now_member as gf 
    inner join person as p on p.id = gf.person_id 
  where 
    membership_status = 'gold' 
    and gf.id like '48Z%'
), 
car_evidence as (
  select 
    * 
  from 
    drivers_license 
  where 
    plate_number like '%H42W%'
) 
select 
  name, 
  g.person_id 
from 
  car_evidence as c 
  inner join gym_evidence as g on g.license_id = c.id;
--Jeremy Bowers  67318
select 
  * 
from 
  interview 
where 
  person_id = 67318;
/*
I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/
--Finding the Master Mind
with leads as (
  with suspects as(
    with concert as (
      select 
        event_name, 
        date, 
        person_id, 
        count(event_id) as attendances 
      from 
        facebook_event_checkin 
      where 
        event_name = "SQL Symphony Concert" 
        and date like '201712%' 
      group by 
        event_name, 
        person_id 
      having 
        attendances = 3
    ) 
    select 
      person_id, 
      license_id, 
      name, 
      ssn 
    from 
      concert as c 
      inner join person as p on p.id = c.person_id
  ) 
  select 
    * 
  from 
    suspects as s 
    inner join drivers_license as d on d.id = s.license_id 
  where 
    lower(hair_color)= 'red' 
    and lower(gender)= 'female' 
    and lower(car_make)= 'tesla' 
    and lower(car_model)= 'model s' 
    and height between 65 
    and 67
), 
average_income as (
  select 
    'Miranda Priestly', 
    avg(annual_income) as avg_income 
  from 
    income
) 
select 
  name, 
  annual_income, 
  round(annual_income / avg_income, 2) as xAvg_Income
from 
  leads as l 
  inner join income as i on i.ssn = l.ssn 
  inner join average_income on 'Miranda Priestly' = l.name

--Miranda Priestly	310000	5.82
