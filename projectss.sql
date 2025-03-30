-- Advance SQL Project  -- Spotify Datasets
DROP DATABASE IF EXISTS spotify_db;

CREATE TABLE Spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
-- EDA-: Explortary Data Analysis
SELECT COUNT(*) FROM Spotify;

SELECT DISTINCT album_type FROM Spotify;

SELECT  duration_min FROM Spotify;

SELECT MAX( duration_min) FROM Spotify;


SELECT MIN( duration_min) FROM Spotify;


SELECT * FROM Spotify
WHERE   duration_min =0;

DELETE FROM Spotify 
WHERE  duration_min =0;
SELECT * FROM Spotify
WHERE   duration_min =0;

SELECT DISTINCT channel FROM Spotify;

SELECT DISTINCT most_played_on FROM Spotify;

\*
--------------------------------
-- DATA ANALYSIS -EASY CATEGORY
--------------------------------

Q1.Retrieve the names of all tracks that have more than 1 billion stream.
Q2.List all albums along with their respective artist.
Q3.Get the total number of comments for tracks where licensed = TRUE.
Q4.Find all tracks that belong to the album type single.
Q5.Count the total number of tracks by each artist.
*\
Q1.Retrieve the names of all tracks that have more than 1 billion stream.  
  SELECT * FROM Spotify
   WHERE stream > 1000000000;

 Q2.List all albums along with their respective artist.
  SELECT 
      album, artist
	  FROM Spotify;

Q3.Get the total number of comments for tracks where licensed = TRUE.
  SELECT
    SUM(comments) as total_comments
	FROM Spotify
	WHERE licensed = 'True';

Q4.Find all tracks that belong to the album type single.
 SELECT * FROM Spotify
  WHERE album_type = 'single';

 Q5.Count the total number of tracks by each artist.
   SELECT 
       artist,
	    COUNT(*)  AS total_no_songs
		FROM Spotify
		GROUP BY artist;
\*		
-----------------		
 -- MIDDLE LEVEL	  
-----------------
*\
Q1.Calculate the average danceability of tracks in each album.
Q2.Find the top 5 tracks with the highest energy values.
Q3.List all tracks along with their views and likes where official_video = TRUE.
Q4.For each album, calculate the total views of all associated tracks.
Q5.Retrieve the track names that have been streamed on Spotify more than YouTube.

Q1.Calculate the average danceability of tracks in each album.
  SELECT 
    album,
	avg(danceability) as avg_danceability
	FROM Spotify
	GROUP BY 1;

Q2.Find the top 5 tracks with the highest energy values.  
     SELECT 
	 track,
	        max(energy)
	FROM Spotify
	GROUP BY 1
    ORDER BY 2 DESC
	LIMIT  5;

Q3.List all tracks along with their views and likes where official_video = TRUE.
    SELECT 
         track,
	  SUM(views) as total_views,
	  SUM(likes) as total_likes
	   FROM Spotify
	  WHERE official_video = 'True'
	  GROUP BY 1;

Q4.For each album, calculate the total views of all associated tracks.
 SELECT 
     album,
	 track,
 SUM(views) 
 FROM Spotify 
 GROUP BY 1,2;

Q5.Retrieve the track names that have been streamed on Spotify more than YouTube.
    SELECT * FROM (
    SELECT
        track,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS stream_on_youtube,
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS stream_on_spotify
    FROM spotify
    GROUP BY track
) AS t1
WHERE stream_on_spotify > stream_on_youtube
AND stream_on_youtube <> 0;

----------------------
 -- Advance level 
----------------------
\*
Q1.Find the top 3 most-viewed tracks for each artist using window functions.
Q2.Write a query to find tracks where the liveness score is above the average.
Q3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
/*

Q1.Find the top 3 most-viewed tracks for each artist using window functions.
  -- each artists and totsl view for each track
  -- track with highest views for each artist (we need top )
  -- dense rank
  -- cte and filder rank<=3
  -- cte(common table expression)
  WITH ranking_artist
   AS
    (SELECT 
	   track,
	   artist,
	   SUM(views) AS total_views,
	   DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views)DESC) as rank
   FROM Spotify
      GROUP BY 1,2
	  ORDER BY 1,3 DESC 
)
 SELECT * FROM ranking_artist
 WHERE rank <=3;

 Q2.Write a query to find tracks where the liveness score is above the average.
 --- SELECT AVG(liveness) FROM Spotify --0.19
  SELECT 
  track
  artist,
  liveness
  FROM Spotify 
  WHERE  liveness >  0.19;

Q3.Use a WITH clause to calculate the difference between 
--the highest and lowest energy values for tracks in each album.
 WITH cte
 AS
 (SELECT    
       album,
	   MAX(energy)  as highest_energy,
       MIN(energy)  as lowest_energy 
 FROM Spotify
 GROUP BY 1
 ) 
  SELECT 
     album,
        highest_energy - lowest_energy   as energy_diff
		FROM cte;
   

	
	
	
	
	  

	  
	 
