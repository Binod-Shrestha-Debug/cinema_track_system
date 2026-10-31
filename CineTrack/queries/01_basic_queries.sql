SELECT * FROM movies;

SELECT title, rating
FROM movies
WHERE rating > 8
ORDER BY rating DESC;

SELECT title, release_year
FROM movies
WHERE release_year > 2024;

SELECT title, duration_minutes
FROM movies
WHERE duration_minutes BETWEEN 120 AND 150;

SELECT *
FROM movies
WHERE title ILIKE '%mission%';

SELECT DISTINCT language FROM movies;
