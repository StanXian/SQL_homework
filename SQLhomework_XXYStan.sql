-- 1a
USE sakila;
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT CONCAT(UPPER(first_name), " ", UPPER(last_name))
AS actor_name 
FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
From actor WHERE first_name = "Joe";

-- 2b
SELECT actor_id, first_name, last_name 
FROM actor WHERE last_name LIKE '%GEN%';

-- 2C
SELECT actor_id, last_name, first_name
FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c
UPDATE actor
SET first_name  = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name  = 'GROUCHO'
WHERE first_name = 'HARPO';

-- 5a
DESCRIBE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON address.address_id=staff.address_id;

-- 6b
SELECT staff.first_name, SUM(payment.amount)
FROM staff
JOIN payment ON payment.staff_id=staff.staff_id
GROUP BY staff.first_name;

-- 6c
SELECT film.title, SUM(film_actor.film_id)
FROM film
JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title;

-- 6d
SELECT * FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title LIKE 'Hunchback Impossible';

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_paid_amount
FROM customer c
JOIN payment p USING(customer_id)
GROUP BY (p.customer_id)
ORDER BY (c.last_name) ASC
LIMIT 19;

-- 7a
SELECT film_id, title, language_id FROM film
WHERE (
	film.title LIKE 'K%' OR film.title LIKE 'Q%')
	AND language_id IN (
		SELECT language_id
        FROM language
        WHERE name = 'English'
);

-- 7b
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
			WHERE title = 'Alone Trip')
);

-- 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d
SELECT title
FROM film 
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'Family')
);

-- 7e
SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f
SELECT customer.store_id, SUM(payment.amount) AS total_payment
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY store_id;

-- 7g
SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country coun
ON ci.country_id = coun.country_id;

-- 7h
SELECT category.name, COUNT(payment.amount) AS 'total_amount'
FROM inventory
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY COUNT(payment.amount) DESC 
LIMIT 5;

-- 8a
CREATE VIEW t5_genre AS
SELECT category.name, COUNT(payment.amount) AS 'total_amount'
FROM inventory
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY COUNT(payment.amount) DESC LIMIT 5;
    
-- 8b
SELECT * FROM t5_genre;

-- 8c
DROP VIEW t5_genre;