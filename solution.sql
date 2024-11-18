SELECT *
FROM   crime_scene_report
WHERE  date=20180115
AND    city="sql city";

/*The first witness lives at the last house on "Northwestern Dr".
The second witness, named Annabel, lives somewhere on "Franklin Ave".*/
SELECT   *
FROM     person
WHERE    address_street_name="Northwestern Dr"
ORDER BY address_number DESC limit 1;

--14887 Morty Schapiro 118009 4919 Northwestern Dr 111564949
SELECT *
FROM   person
WHERE  address_street_name="franklin ave"
AND    Lower(NAME) LIKE '%annabel%';

--16371 Annabel Miller 490173 103 Franklin Ave 318771143
SELECT *
FROM   interview
WHERE  person_id=16371
OR     person_id=14887;

/*14887 I heard a gunshot and then saw a man run out.
He had a "Get Fit Now Gym" bag.
The membership number on the bag started with "48Z".
Only gold members have those bags.
The man got into a car with a plate that included "H42W".
16371 I saw the murder happen, and I recognized the killer from my gym
when I was working out last week on January the 9th.*/
SELECT *
FROM   get_fit_now_check_in
WHERE  membership_id LIKE '48Z%'
AND    check_in_date='20180109';

/*
48Z7A 20180109 1600 1730
48Z55 20180109 1530 1700
*/
SELECT *
FROM   get_fit_now_member
WHERE  id = '48Z7A'
OR     id='48Z55';

--67318 Jeremy Bowers, 28819 Joe Germuska
SELECT *
FROM   drivers_license
WHERE  plate_number LIKE '%H42W%';

--183779,423327,664760
SELECT *
FROM   person
WHERE  id = 67318
OR     id=28819
AND    (
              license_id=183779
       OR     license_id=423327
       OR     license_id=664760;
       
       --Final Solution
       ;WITH gym_evidence AS
       (
                  SELECT     *
                  FROM       get_fit_now_member AS gf
                  INNER JOIN person             AS p
                  ON         p.id=gf.person_id
                  WHERE      membership_status='gold'
                  AND        gf.id LIKE '48Z%') 
	, car_evidence AS
       (
              SELECT *
              FROM   drivers_license
              WHERE  plate_number LIKE '%H42W%')
       SELECT     NAME,
                  g.person_id
       FROM       car_evidence AS c
       INNER JOIN gym_evidence AS g
       ON         g.license_id=c.id;
       
       --Jeremy Bowers 67318SELECT *
       FROM   interview
       WHERE  person_id=67318;
       
       /*
I was hired by a woman with a lot of money.
I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
She has red hair and she drives a Tesla Model S.
I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/
       --Finding the Master Mind
WITH leads AS ( WITH suspects AS( WITH concert AS
       (
                SELECT   event_name ,
                         date ,
                         person_id ,
                         Count(event_id) AS attendances
                FROM     facebook_event_checkin
                WHERE    event_name= "sql symphony concert"
                AND      date LIKE '201712%'
                GROUP BY event_name,
                         person_id
                HAVING   attendances=3 )
       SELECT     person_id ,
                  license_id ,
                  NAME ,
                  ssn
       FROM       concert AS c
       INNER JOIN person  AS p
       ON         p.id=c.person_id )
SELECT     *
FROM       suspects        AS s
INNER JOIN drivers_license AS d
ON         d.id=s.license_id
WHERE      Lower(hair_color)='red'
AND        Lower(gender)='female'
AND        Lower(car_make)='tesla'
AND        Lower(car_model)='model s'
AND        height BETWEEN 65 AND        67 )
SELECT     *
FROM       leads  AS l
INNER JOIN income AS i
ON         i.ssn=l.ssn