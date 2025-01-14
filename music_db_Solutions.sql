CREATE DATABASE music_db;
use music_db;

-- Q1.who is the senior mosty employee based on job title

SELECT 
    *
FROM
    employee
ORDER BY levels DESC
LIMIT 1;

-- Q2.which countries has the most invoices
SELECT 
    billing_country, COUNT(invoice_id) AS invoice_count
FROM
    invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

-- Q3.what are the top 3 values of total invoice
SELECT 
    *
FROM
    invoice
ORDER BY total DESC
LIMIT 3;

-- Q4.Which city has the best customers ? we would like to throw a 
-- promotional music festival in the city we made the most money,write a query that
-- returns one city that has the highest  SUM of invoice total return the city name and 
-- sum of all invoice total;

SELECT 
    billing_city, ROUND(SUM(total), 2) AS total_sale
FROM
    invoice
GROUP BY billing_city
ORDER BY total_sale DESC
LIMIT 1;

-- Q5.who is the best customer ? the customer who has spent the most money
-- will be declared as the best customer ,write a query that returns the person
-- who has spent the most money

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.address,
    c.city,
    SUM(i.total) AS total
FROM
    customer AS c
        JOIN
    invoice AS i ON c.customer_id - i.customer_id
ORDER BY total DESC;

-- Q6.Write a query to return the email,first name,last name & genre of all rock music listners 
-- return your list ordered alphabetically by email starting with A

SELECT 
    c.email, c.first_name, c.last_name, g.name
FROM
    genre AS g
        JOIN
    track AS t ON g.genre_id = t.genre_id
        JOIN
    invoice_line AS il ON t.track_id = il.track_id
        JOIN
    invoice AS i ON il.invoice_id = i.invoice_id
        JOIN
    customer AS c ON i.customer_id = c.customer_id
WHERE
    g.name = 'rock'
GROUP BY first_name , last_name
ORDER BY email;

-- Q7.lets invite the artists who have written the most rock music
-- in our dataset,write a query that returns the artist name and total 
-- track count of the top 10 rock bands;

SELECT 
    art.artist_id, art.name, COUNT(art.artist_id) AS rock_count
FROM
    Genre AS g
        JOIN
    track AS t ON g.genre_id = t.genre_id
        JOIN
    album2 AS a ON a.album_id = t.album_id
        JOIN
    artist AS art ON art.artist_id = a.artist_id
WHERE
    g.name LIKE '%rock%'
GROUP BY art.artist_id
ORDER BY rock_count DESC;

-- Q8.return all the track names that have a song length longer than the average song length 
-- .return the name and milliseconds for the each track .order by the song length with the longest 
-- song listed first

SELECT * FROM music_db.track;

SELECT 
    track_id, name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS avg_track_length
        FROM
            track)
ORDER BY milliseconds DESC;

-- Q9.find how much amount spent by each customer on artists? write a 
-- query to return customer_name,artist_name,total_spent

SELECT 
    c.first_name,
    c.last_name,
    art.name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM
    Customer AS c
        JOIN
    invoice AS i ON c.customer_id = i.customer_id
        JOIN
    invoice_line AS il ON il.invoice_id = i.invoice_id
        JOIN
    track AS t ON il.track_id = t.track_id
        JOIN
    album2 AS a ON a.album_id = t.album_id
        JOIN
    artist AS art ON art.artist_id = a.album_id
GROUP BY c.first_name , c.last_name
ORDER BY total_spent DESC;

-- Q10.write a query to determine the customer that has spent the most
-- on music for each country,write a query that returns the country along with the 
-- top customer and how much they spent 

WITH CustomerSpending AS (
    SELECT 
        c.country,
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(i.total) AS total_spent
    FROM 
        customer AS c
    JOIN 
        invoice AS i
        ON c.customer_id = i.customer_id
    GROUP BY 
        c.country, c.customer_id, customer_name
),
MaxSpendingByCountry AS (
    SELECT 
        country,
        MAX(total_spent) AS max_spent
    FROM 
        CustomerSpending
    GROUP BY 
        country
)
SELECT 
    cs.country,
    cs.customer_name,
    ms.max_spent
FROM 
    CustomerSpending AS cs
JOIN 
    MaxSpendingByCountry AS ms
    ON cs.country = ms.country AND cs.total_spent = ms.max_spent
ORDER BY 
    cs.country;





