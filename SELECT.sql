--  Название и продолжительность самого длительного трека.
SELECT track_name, duration  FROM Track
WHERE duration = (SELECT MAX(duration) FROM Track);


--  Название треков, продолжительность которых не менее 3,5 минут.
SELECT track_name FROM Track
WHERE duration >= 3.5 * 60;


--  Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT collection_name FROM Collection
WHERE collection_year BETWEEN 2018 AND 2020;


--  Исполнители, чьё имя состоит из одного слова.
SELECT * FROM Performers
WHERE performer_name NOT LIKE '% %';


--  Название треков, которые содержат слово «мой» или «my».
SELECT track_name FROM Track
WHERE string_to_array(lower(track_name), ' ') && ARRAY['мой', 'мой %', '% мой', '%мой%', 'my', '% my', 'my %', '%my%'];


--Количество исполнителей в каждом жанре
select genre_name, count(id_artist_ag) from musical_genre
join PerformersGenre on musical_genre.MusicalGenreID = PerformersGenre.MusicalGenreID_ag
group by genre_name

--Количество треков, вошедших в альбомы 2019-2020 годов
select count(AlbumName) from Track
join albumList on Track.AlbumListID_t = albumList.AlbumListID
where release_year >= '20190101' and release_year <= '20201231'

--Средняя продолжительность треков по каждому альбому
select AlbumName, avg(duration) from Track
join albumList on Track.AlbumListID_t = albumList.AlbumListID
group by AlbumName

--Все исполнители, которые не выпустили альбомы в 2020 году
select performer_name from Performers
join PerformersAlbum on Performers.PerformersID = Performers.PerformersID_aa
join albumList on albumList.AlbumListID = PerformersAlbum.AlbumListID_aa
where release_year not between '20200101' and '20201231'
group by performer_name

--Названия сборников, в которых присутствует конкретный исполнитель (выбрана Taylor Swift)
select collection_name from Collection
join TrackCollection on CTrackCollection.CollectionID_ct = Collection.CollectionID
join Track on TrackCollection.TrackID_ct = Track.TrackID
join albumList on Track.AlbumListID_t = albumList.AlbumListID
join PerformersAlbum on PerformersAlbum.AlbumListID_aa = albumList.AlbumListID
join Performers on PerformersAlbum.PerformersID_aa = Performers.PerformersID
where performer_name = 'Taylor Swift'
group by collection_name

--Название альбомов, в которых присутствуют исполнители более 1 жанра
select AlbumName, count(genre_name) from albumList
join PerformersAlbum on albumList.AlbumListID = PerformersAlbum.AlbumListID_aa
join Performers on PerformersAlbum.PerformersID_aa = Performers.PerformersID
join PerformersGenre on Performers.PerformersID = PerformersGenre.PerformersID_ag
join musical_genre on musical_genre.MusicalGenreID = PerformersGenre.MusicalGenreID_ag
group by AlbumName
having count(genre_name) > 1

--Наименование треков, которые не входят в сборники
select track_name from Track
left join TrackCollection on Track.TrackID = TrackCollection.TrackID_ct
where CollectionID_ct is null

--Исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
select performer_name, duration from Track
join albumList on Track.AlbumListID_t = albumList.AlbumListID
join PerformersAlbum on PerformersAlbum.AlbumListID_aa = albumList.AlbumListID
join Performers on PerformersAlbum.PerformersID_aa = Performers.PerformersID
where duration = (select min(duration) from track)


select AlbumName, count(track_name) from Track
join albumList on Track.AlbumListID_t = albumList.AlbumListID
group by AlbumName

--Название альбомов, содержащих наименьшее количество треков
select distinct AlbumName from albumList
left join Track on Track.AlbumListID_t = albumList.AlbumListID
where Track.AlbumListID_t in (
    select AlbumListID_t from Track
    group by AlbumListID_t
    having count(AlbumListID_t) = (
         select count(TrackID)
         from Track
         group by AlbumListID_t
         order by count
         limit 1
)
)
--