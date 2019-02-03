use sakila;

#1a. first and last names from the table actor
Select first_name, last_name From actor;

#1b. Display the first and last name of each actor in a signle column in upper calse letters.  Column name Actor
Select UPPER(Concat(first_name, ' ', last_name)) from actor;

#2a Find the ID numner, first name, last name of an actor of whom you know only the first name Joe
Select actor_id, first_name, last_name from actor where first_name = "Joe";

#2b Find all actors who last name contains  the letters GEN
Select * from actor where last_name like '%GEN%';

#2c Fina all the actos whose late name contains the letter LT.  Order rows by last name, first name in that order
Select * from actor where last_name like '%LI%' order by last_name, first_name;

#2d using IN, display country id and coutnry coumns of the countries: Afghanastan, Bangladesh, China
Select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China')

#3a You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant)
ALTER TABLE actor 
add column description_actor VARCHAR(25) after first_name;

Alter Table actor
modify column discription_actor BLOB;

#3b delete the added column
Alter Table actor
Drop Column description_actor;

#4a list the last name of actors, as well as how many actors have that last name
Select last_name, COUNT(last_name) as "Count of Actors"
from actor group by last_name;

#4b list the name of actors and the number of actors who have that last name, but only for those with at least 2 actors
Select last_name, COUNT(last_name) as 'count_of_actors'
from actor group by last_name having count_of_actors >=2; 

#4c Replace Groucho Harpo with Harpo Williams
Update actor
Set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

#4d change it back
Update actor
Set first_name = 'GROUCHO' where first_name = 'HARPO' and last_name = 'WILLIAMS';

#5a recreate the schema for address
describe sakila.address;

#6a use join to display first and last name as well as the address of each staff member
Select first_name, last_name, address from staff s 
join address a on s.address_id = a.address_id;

#6b use joint to display the total amount run up by each staff member in August 2005
Select payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
from staff inner join payment on staff.staff_id = payment.staff_id and payment_date like '2005-08%';

#6c list each file and the number of actors who are listed for that film
select f.title as 'Film Title', count(fa.actor_id) as 'Count of Actors'
from film_actor fa 
inner join film f
on fa.film_id = f.film_id
group by f.title;

#6d how many copies of the film hunchback impossible exist
select title,(select count(*) from inventory  where film.film_id = inventory.film_id)
as 'Number of COpies' from film where title = "Hunchback Impossible";

#6e list the total paid by each customer, list customers alphabetically by last name 
SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.last_name;

#7a movie titles with letters K and Q
SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

#7b what actors appear in alone trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

#7c Canadian customer information
SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

#7d What movies are family films 
SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

#7e most freqently rented movies 
SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

#7f how much business, in dollars each store brought in
SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

#7g display store id, city and country
SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

#7h top five genres
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

#8a Create a view of the item above 
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS

SELECT 
    name, SUM(p.amount) AS gross_revenue
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        RIGHT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

#8b display the view above
SELECT * FROM top_five_genres;

#8c delete the view
DROP VIEW top_five_genres;









