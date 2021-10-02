/* 1-What is The Number of movies in each movie genre ? */
WITH
categ
AS
  (
         SELECT film_cat.film_id,
                cat.name
         FROM   film_category film_cat
         JOIN   category cat
         ON     film_cat.category_id = cat.category_id),
  qren
AS
  (
         SELECT film.rental_duration ,
                film.title,
                category.name
         FROM   film
         JOIN   categ category
         ON     film.film_id = category.film_id )
  SELECT   name     AS genre,
           count(*) AS genre_count
  FROM     qren
  GROUP BY qren.name
  ORDER BY genre_count DESC;


  /* 2-What is Highest Earnings Movie Titles ? */
  SELECT   title       AS name ,
           count(*)    AS rentals_number ,
           sum(amount) AS earnings
  FROM     film
  JOIN     inventory
  ON       film.film_id = inventory.film_id
  JOIN     rental
  ON       inventory.inventory_id = rental.inventory_id
  JOIN     payment
  ON       rental.rental_id = payment.rental_id
  GROUP BY name
  ORDER BY earnings DESC
  LIMIT    10;


  /* 3-What is Highest Earnings Movie Genres ? */
  SELECT   category.name           AS genre,
           count(rental.rental_id) AS count_of_rentals,
           sum(payment.amount)     AS profit
  FROM     film_category
  JOIN     category
  ON       category.category_id = film_category.category_id
  JOIN     film
  ON       film_category.film_id = film.film_id
  JOIN     inventory AS inv
  ON       film.film_id = inv.film_id
  JOIN     rental
  ON       inv.inventory_id = rental.inventory_id
  JOIN     payment
  ON       rental.rental_id = payment.rental_id
  GROUP BY genre
  ORDER BY profit DESC ; 


           /* 4-What is the distribution of family films according to their length ? */
           WITH genre AS
           (
                  SELECT category_id,
                         name
                  FROM   category),
           quart AS
           (
                    SELECT   film_id,
                             ntile(4) over (ORDER BY rental_duration) AS quartile
                    FROM     film )
  SELECT   genre.name,
           quart.quartile,
           count(DISTINCT quart.film_id)
  FROM     genre
  JOIN     film_category
  ON       film_category.category_id = genre.category_id
  JOIN     quart
  ON       film_category.film_id = quart.film_id
  GROUP BY name,
           quartile
  ORDER BY name ,
           count DESC ; 
