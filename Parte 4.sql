--1. Vamos a seleccionar el nombre y apellido de los actores
 SELECT first_name, last_name FROM actor;
--2. Vamos a seleccionar el nombre completo del actor en una sola columna
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM actor;
--3. Selecciona los actores que su nombre empieza con "D"
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'D%';
--4. �Tenemos alg�n actor con el mismo nombre?
SELECT first_name, COUNT(*) AS count 
FROM actor 
GROUP BY first_name 
HAVING COUNT(*) > 1;
--5. �Cu�l es el costo m�ximo de renta de una pel�cula?
SELECT MAX(rental_rate) AS max_rental_cost FROM film;
--6. �Cu�les son las peliculas que fueron rentadas con ese costo?	
SELECT title, rental_rate 
FROM film 
WHERE rental_rate = (SELECT MAX(rental_rate) FROM film);
--7. �Cuant�s pel�culas hay por el tipo de audencia (rating)?
SELECT rating, COUNT(*) AS total_films 
FROM film 
GROUP BY rating;
--8. Selecciona las pel�culas que no tienen un rating R o NC-17
SELECT title, rating 
FROM film 
WHERE rating NOT IN ('R', 'NC-17');

--9. �Cuantos clientes hay en cada tienda?
SELECT store_id, COUNT(*) AS total_clientes 
FROM customer 
GROUP BY store_id;
--10. �Cu�l es la pelicula que mas veces se rento?
SELECT TOP 1 f.title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC;
--11. �Qu� peliculas no se han rentado?
SELECT f.title 
FROM film f 
WHERE NOT EXISTS (
    SELECT 1 
    FROM inventory i 
    JOIN rental r ON i.inventory_id = r.inventory_id 
    WHERE i.film_id = f.film_id
);
--12. �Qu� clientes no han rentado ninguna pel�cula?
SELECT f.title 
FROM film f 
WHERE NOT EXISTS (
    SELECT 1 
    FROM inventory i 
    JOIN rental r ON i.inventory_id = r.inventory_id 
    WHERE i.film_id = f.film_id
);
--13. �Qu� actores han actuado en m�s de 30 pel�culas?
SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS film_count
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(*) > 30;
--14. Muestra las ventas totales por tienda
SELECT i.store_id, SUM(CAST(p.amount AS DECIMAL(10, 2))) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY i.store_id;
--15. Muestra los clientes que rentaron una pelicula m�s de una vez
SELECT c.customer_id, c.first_name, c.last_name, f.title, COUNT(*) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, f.film_id, f.title
HAVING COUNT(*) > 1;	