--A recap on subqueries:
--Subqueries are SQL queries that can run on their own, but give an output that's
--helpful for getting the right solution for the outer query. 

-- Example: Return all transactions where the amount is greater than average
--Hmmm... maybe this?
SELECT * 
FROM payment
WHERE amount > AVG(amount);
-- NOPE! DOESN'T RUN: "ERROR:  aggregate functions are not allowed in WHERE clause"

-- What about HAVING?
SELECT *
FROM payment
HAVING amount > AVG(amount);
-- NOPE! "ERROR:  column "payment.amount" must appear in the GROUP BY clause..."
-- And we're not grouping anything, so that won't work either!

Sooo... Subquery!
SELECT *
FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);
-- It runs! NOTE that the subquery returns 1 number, 
-- So "WHERE amount > (SELECT AVG(amount) FROM payment)"
-- Is the same as "WHERE amount > 4.2"
-- This is a very useful application of subqueries.


-- ANOTHER EXAMPLE: Getting 1 value from a subquery
-- Eg. Let's say you wanted all purchases with the staff ID that has serviced the fewest transactions.
-- ie. the staff_id with the smallest COUNT(*)

SELECT *
FROM payment
WHERE staff_id = (SELECT staff_id
				 FROM payment
				 GROUP BY staff_id
				 ORDER BY COUNT(*); -- this subquery lists staff_id's in order of number of transactions, but returns 2 values
                  
-- ERROR:  syntax error at or near ";" -- Wow, doesn't give you any clue what's wrong
-- what's wrong is the subquery returns the values staff_id: 1,2
-- but the "WHERE staff_id =" is expecting just ONE number
-- so use "LIMIT 1" at the end of the subquery
SELECT *
FROM payment
WHERE staff_id = (SELECT staff_id
				 FROM payment
				 GROUP BY staff_id
				 ORDER BY COUNT(*)
				 LIMIT 1); -- add 'LIMIT 1', now it runs!

                  
-- EXERCISES - each one has an 'a' and a 'b' part. The 'a' part is the subquery for the 'b' part.
-- 1a) What is the average length of all the films?
-- 1b) Return all films with shorter than average length.


-- 2a) What is the smallest rental rate	in the database?
-- 2b) Return all films with the lowest rental rate (using a WHERE claus)


-- 3a) What is the average payment amount in the database?
-- 3b) Return all payments with below average payment amounts


-- 4a) What is the customer ID who made the earliest payment?		  
-- 4b) Return all purchases from the longest standing customer				

-- 5a) What rating ('PG', 'G', etc) has the least films?
-- 5b) Return all films that have the rating that is biggest category 
-- (ie. rating with the highest count of films)