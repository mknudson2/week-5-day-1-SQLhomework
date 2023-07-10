--Question 1: How many actors are there with the last name 'Wahlberg'?
SELECT count(last_name)
FROM actor
GROUP BY last_name 
Having last_name = 'Wahlberg';



--Question 2: How many payments were made between $3.99 and $5.99?
SELECT DISTINCT amount, count(payment_id) 
FROM payment 
GROUP BY amount  
HAVING amount BETWEEN 3.99 AND 5.99;



--Question 3: What film does the store have the most of? (search in inventory)
	--store 1
SELECT film.film_id, film.title, COUNT(inventory.film_id) AS total_copies --id WHERE our COLUMNS ARE coming FROM; CREATE variable FOR count FUNCTION result
FROM inventory --beginning location
JOIN film ON inventory.film_id = film.film_id --id JOIN CONDITION AS BOTH film AND inventory SHARE film_id, so MAPPING film info onto inventory
WHERE inventory.store_id = '1' --ID store TO focus ON AS store 1 (store 2 below)
GROUP BY film.film_id, film.title --GROUP BY film title AND ID TO state which film IS held most.
ORDER BY total_copies DESC --sort items IN descending ORDER so highest occurence IS AT the top
LIMIT 1; --limits display TO one ROW so ONLY the item WITH the highest occurence IS shown.

	--store 2: mirrors what was done for store 1
SELECT film.film_id, film.title, COUNT(inventory.film_id) AS total_copies
FROM inventory 
JOIN film ON inventory.film_id = film.film_id
WHERE inventory.store_id = '2'
GROUP BY film.film_id, film.title
ORDER BY total_copies DESC
LIMIT 1;



--Question 4: How many customers have the last name 'William'?  --> None are so named, although there is a Williams.
SELECT first_name, last_name, count(last_name)
FROM customer
GROUP BY first_name, last_name 
HAVING last_name = 'William';



--Question 5: What store employee (get the id) sold the most rentals? --staff_id 1
	--the below two represent (respectively) getting the staff_id with the most rentals and then another function to get the name.
SELECT staff_id, count(rental_id)
FROM rental
GROUP BY staff_id; 

SELECT first_name, last_name, staff_id
FROM staff;
		
	--Q5.the below function joins the info from the two lists to create a more user-friendly answer
SELECT staff.staff_id, staff.first_name, staff.last_name, rental.total_rentals --points TO SPECIFIC COLUMNS IN the specified TABLES (separated by .)
FROM staff 
JOIN (   --joining the results OF the count FUNCTION WITH the info FROM the staff TABLE TO give us the name, NOT just the staff_id, who rented the most
    SELECT staff_id, COUNT(rental_id) AS total_rentals --ALL IN parentheses IN ORDER TO keep the FUNCTION whole,  AND run it AS a part OF the larger FUNCTION 
    FROM rental
    GROUP BY staff_id
) rental ON staff.staff_id = rental.staff_id  --dictates the common COLUMN that IS used AS the JOIN CONDITION (an intersection)
ORDER BY rental.total_rentals DESC --puts the highest number FIRST 
LIMIT 1; --learned that you can LIMIT the amount OF ROWS shown IN SQL, her SET TO 1 TO ensure that ONLY the top performer would be listed.




--Question 6: How many different district names are there? --> 603
SELECT DISTINCT count(district)
FROM address;



--Question 7: What film has the most actors in it? (use film_actor table and get film_id) --> film_id 508 had 15 actors
SELECT film_id, count(film_id)
FROM film_actor
GROUP BY film_id 
ORDER BY count(film_id) DESC ;



--Question 8: From store_id 1, how many customers have a last name ending with ‘es’? (use customer table) --> 21. IT took me a minute to realize that using 
				--group by and HAVING was what was causing me to return the count of each distinct name that met the -es condition as opposed to the total.
SELECT count(last_name)
FROM customer 
WHERE last_name LIKE '%es';




--Question 9: How many payment amounts (4.99, 5.99, etc.) had a number of rentals above 250 for customers with ids between 380 and 430? (use group by and having > 250)
	--This one took a fair bit of figuring out and experimenting to solve. 

SELECT payment.amount, COUNT(payment.amount) AS pay_amounts --id the COLUMNS we will be pulling FROM AND providing a variable
FROM payment 
	--the information needed comes FROM three tables, with the rental table being the intermediary that allows the information to be shared/bridged between all the 
	--necessary tables. The two JOIN lines use rental_id as the join condition to join the payment and rental tables providing, respectively, the amount (2.99,
	--4.99, etc.) and the rental_id and the customer_id (to meet the criteria of only evaluating customers with ids between 380 and 430).
	--The next line brings the customer_id connection from customer to rental to provide the full range of information needed through the creation of one whole 
	--temporary Franken-table!
JOIN rental ON payment.rental_id = rental.rental_id 
JOIN customer ON rental.customer_id = customer.customer_id
WHERE customer.customer_id BETWEEN 380 AND 430 --SETS parameters TO ONLY look AT those VALUES which belong TO customers WITH ids FROM 380 -430.
GROUP BY payment.amount --GROUP this BY amount AS the prompt asks specifically AT which amounts are the FOLLOWING criteria met
HAVING COUNT(rental.rental_id) > 250; --LAST FILTER that states ONLY those rental ids whose value exceeds 250 should be considered





--Question 10: Within the film table, how many rating categories are there? And what rating has the most movies total?
SELECT DISTINCT rating, count(rating)
FROM film f 
GROUP BY rating 
ORDER BY count(rating) DESC ;

		--The code below provides the total number of categories (5), while the above code lists the different rating categories with the total films in each 
		--in descending order so the rating with the highest total is on top.
SELECT count(DISTINCT rating) AS categories_total
FROM film ;