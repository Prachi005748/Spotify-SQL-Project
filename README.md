# Spotify Data Analysis Using SQL

## Project Overview
This project performs an in-depth **Exploratory Data Analysis (EDA)** and **Data Analysis** on a **Spotify dataset** using SQL. The dataset includes information about artists, tracks, albums, streams, views, likes, and various song attributes like energy, danceability, and liveness.

## Technologies Used
- **SQL** (Structured Query Language)
- **MySQL** / **PostgreSQL** (Can be used interchangeably)
- **GitHub** (For version control)

## Database Schema
The project utilizes a **single table** named `Spotify` with the following columns:

```sql
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
```

## Exploratory Data Analysis (EDA)
### Key Queries:
- **Total Records in Dataset**
  ```sql
  SELECT COUNT(*) FROM Spotify;
  ```
- **Unique Album Types**
  ```sql
  SELECT DISTINCT album_type FROM Spotify;
  ```
- **Find Max & Min Duration**
  ```sql
  SELECT MAX(duration_min) FROM Spotify;
  SELECT MIN(duration_min) FROM Spotify;
  ```
- **Find & Remove Tracks with Zero Duration**
  ```sql
  DELETE FROM Spotify WHERE duration_min = 0;
  ```

## Data Analysis Queries
### **Easy Level**
1. **Retrieve tracks with more than 1 billion streams**
   ```sql
   SELECT * FROM Spotify WHERE stream > 1000000000;
   ```
2. **List all albums along with their respective artists**
   ```sql
   SELECT album, artist FROM Spotify;
   ```
3. **Get the total number of comments for licensed tracks**
   ```sql
   SELECT SUM(comments) AS total_comments FROM Spotify WHERE licensed = TRUE;
   ```
4. **Find tracks belonging to the album type 'single'**
   ```sql
   SELECT * FROM Spotify WHERE album_type = 'single';
   ```
5. **Count the total number of tracks by each artist**
   ```sql
   SELECT artist, COUNT(*) AS total_no_songs FROM Spotify GROUP BY artist;
   ```

### **Middle Level**
1. **Calculate the average danceability of tracks in each album**
   ```sql
   SELECT album, AVG(danceability) AS avg_danceability FROM Spotify GROUP BY album;
   ```
2. **Find the top 5 tracks with the highest energy values**
   ```sql
   SELECT track, MAX(energy) FROM Spotify GROUP BY track ORDER BY MAX(energy) DESC LIMIT 5;
   ```
3. **List all tracks with their views and likes where official video is TRUE**
   ```sql
   SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM Spotify WHERE official_video = TRUE GROUP BY track;
   ```
4. **Calculate total views for each album**
   ```sql
   SELECT album, SUM(views) AS total_views FROM Spotify GROUP BY album;
   ```
5. **Retrieve tracks streamed more on Spotify than YouTube**
   ```sql
   SELECT * FROM (
       SELECT track,
              COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS stream_on_youtube,
              COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS stream_on_spotify
       FROM Spotify
       GROUP BY track
   ) AS t1
   WHERE stream_on_spotify > stream_on_youtube AND stream_on_youtube <> 0;
   ```

### **Advanced Level**
1. **Find the top 3 most-viewed tracks for each artist using window functions**
   ```sql
   WITH ranking_artist AS (
       SELECT track, artist, SUM(views) AS total_views,
              DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
       FROM Spotify
       GROUP BY track, artist
   )
   SELECT * FROM ranking_artist WHERE rank <= 3;
   ```
2. **Find tracks where the liveness score is above the average**
   ```sql
   SELECT track, artist, liveness FROM Spotify WHERE liveness > (SELECT AVG(liveness) FROM Spotify);
   ```
3. **Calculate the difference between the highest and lowest energy values per album using WITH clause**
   ```sql
   WITH energy_stats AS (
       SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy FROM Spotify GROUP BY album
   )
   SELECT album, highest_energy - lowest_energy AS energy_diff FROM energy_stats;
   ```


## Author
[Prachi Paliwal](https://www.linkedin.com/in/saksham-srivastava-343088255/)  
GitHub: [Prachi Paliwal](https://github.com/Prachi005748)  
Email: princhukumar123456@gmail.com

---
This project serves as an excellent case study for SQL-based **Exploratory Data Analysis (EDA)** and **Data Analysis** with advanced SQL queries. 🚀

