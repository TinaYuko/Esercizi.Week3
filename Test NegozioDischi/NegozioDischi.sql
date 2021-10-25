create database NegozioDischi

create table Band (
IDBand int IDENTITY(1,1) constraint PK_BAND primary key,
Nome nvarchar(50) not null,
NumComponenti int not null );

create table Brano (
IDBrano int IDENTITY (1,1) constraint PK_BRANO primary key,
Titolo nvarchar (50) not null,
Durata int not null, );

create table Album (
IDAlbum int IDENTITY (1,1) constraint PK_ALBUM primary key,
TitoloAlbum nvarchar (50) not null,
AnnoUscita date not null,
CasaDiscografica nvarchar (30) not null,
Genere nvarchar (10) not null check(Genere IN ('Classico','Jazz','Pop','Rock','Metal')),
Distribuzione nvarchar(10) not null check (Distribuzione IN ('CD','Vinile','Streaming')),
IDBand int not null constraint FK_BAND foreign key references Band(IDBand),
CONSTRAINT UK_ALBUM UNIQUE (TitoloAlbum,AnnoUscita,CasaDiscografica,Genere,Distribuzione));

create table BranoxAlbum (
IDBrano int not null constraint FK_BRANO foreign key references Brano(IDBrano),
IDAlbum int not null constraint FK_Album foreign key references Album(IDAlbum),
constraint PK_BRANOXALBUM primary key (IDBrano, IDAlbum) );

--Aggiungo attributi a caso alle tabelle
insert Brano values ('Finché la barca va', 180),
                    ('Hanno ucciso l''uomo ragno', 165),
					('Tanti auguri a te', 110),
					('Con te partirò', 210),
					('Beggin', 200),
					('My immortal', 190),
					('Wake me up before u go', 235),
					('Thunderstorm', 190),
					('Imagine', 185),
					('Let it go', 180),
					('Sigla Pokemon', 120),
					('Volare', 110),
					('That''s life', 180),
					('Nanneddu meu', 100),
					('Never enough', 200)
insert brano values ('Canzone sconosciuta che non andrà da nessuna parte', 110)

insert Band values ('Orietta Berti&Band', 4),
                   ('AC/DC', 5),
				   ('Maneskin', 5),
				   ('883', 4),
				   ('Queen', 7),
				   ('Zio Peppino duo', 2),
				   ('The Giornalisti', 4),
				   ('Beatles', 4)

insert Album values ('Troppo bello sto album', '1980-10-23', 'Sony', 'Rock','CD', 6),
                    ('The greatest hits', '1998-11-03', 'Sony', 'Jazz','Vinile', 5),
					('Christmas days', '2000-12-15', 'MGM', 'Pop','CD', 8),
					('Summer hit', '2015-06-12', 'RJK', 'Pop','Streaming', 7),
					('Yellow Submarine', '1963-05-18', 'Sony', 'Rock','CD', 8),
					('Best of ACDC', '1990-03-13', 'MGM', 'Metal','CD', 2),
					('Classic FM', '1930-01-30', 'MGM', 'Classico','Vinile', 4),
					('Siamo troppo toghi', '2020-03-29', 'Sony', 'Rock','CD', 3),
					('Best of Orietta', '2018-07-15', 'RJK', 'Pop','Streaming', 1),
					('Tutte le maschere', '2003-02-21', 'Sony', 'Jazz','Vinile', 4)

insert BranoxAlbum values (1,9),
                          (6,9),
                          (3,9),
						  (2,7),
						  (4,7),
						  (7,3),
						  (10,3),
						  (14,1),
						  (13,1),
						  (15,2),
						  (11,2),
						  (12,4),
						  (1,4),
						  (9,5),
						  (8,6),
						  (5,8),
						  (11,8),
						  (12,10),
						  (5,10),
						  (2,9)

--1) Scrivere una query che restituisca i titoli degli album degli “883” in ordine alfabetico;
select a.TitoloAlbum
from Album a join Band b on b.IDBand=a.IDBand
where b.Nome='883'
order by a.TitoloAlbum

--2) Selezionare tutti gli album della casa discografica “Sony Music” relativi all’anno 2020;
select a.*
from Album a
where a.CasaDiscografica='Sony' and DATEPART(YEAR, a.AnnoUscita)=2020

--3) Scrivere una query che restituisca tutti i titoli delle canzoni dei “Maneskin” appartenenti
--ad album pubblicati prima del 2019;
select b.Titolo
from Brano b join BranoxAlbum ba on ba.IDBrano=b.IDBrano
             join Album a on a.IDAlbum=ba.IDAlbum
			 join Band bd on bd.IDBand=a.IDBand
where bd.Nome='Maneskin' and DATEPART(YEAR, a.AnnoUscita)<2019

--4) Individuare tutti gli album in cui è contenuta la canzone “Imagine”;
select a.*
from Album a join BranoxAlbum ba on ba.IDAlbum=a.IDAlbum
             join Brano b on b.IDBrano=ba.IDBrano
where b.Titolo='Imagine'

--5) Restituire il numero totale di canzoni eseguite dalla band “The Giornalisti”;
select count(b.IDBrano) as [TotCanzoni dei The Giornalisti]
from Brano b join BranoxAlbum ba on ba.IDBrano=b.IDBrano
             join Album a on a.IDAlbum=ba.IDAlbum
			 join Band bd on bd.IDBand=a.IDBand
where bd.Nome='The Giornalisti'

--6) Contare per ogni album, la “durata totale” cioè la somma dei secondi dei suoi brani
select a.TitoloAlbum, sum(b.Durata) as [Durata Complessiva]
from Album a join BranoxAlbum ba on ba.IDAlbum=a.IDAlbum
             join Brano b on b.IDBrano=ba.IDBrano
group by a.TitoloAlbum

--7) Mostrare i brani (distinti) degli “883” che durano più di 3 minuti (in alternativa usare i
--secondi quindi 180 s).
select distinct b.*
from Brano b join BranoxAlbum ba on ba.IDBrano=b.IDBrano
             join Album a on a.IDAlbum=ba.IDAlbum
			 join Band bd on bd.IDBand=a.IDBand
where bd.Nome='883' and b.Durata>180

--8) Mostrare tutte le Band il cui nome inizia per “M” e finisce per “n”.
select bd.*
from Band bd
where bd.Nome like 'M%n'

--9) Mostrare il titolo dell’Album e di fianco un’etichetta che stabilisce che si tratta di un
--Album:
--‘Very Old’ se il suo anno di uscita è precedente al 1980,
--‘New Entry’ se l’anno di uscita è il 2021,
--‘Recente’ se il suo anno di uscita è compreso tra il 2010 e 2020,
--‘Old’ altrimenti.
select a.TitoloAlbum,
case
when DATEPART(YEAR, a.AnnoUscita)<1980  then 'Very Old'
when DATEPART(YEAR, a.AnnoUscita)>2021 then 'New Entry'
when a.AnnoUscita between '2010-01-01' and '2020-12-31' then 'Recente'
else 'Old'
end as [Tipo Album]
from Album a;

--10) Mostrare i brani non contenuti in nessun album.select b.*from Brano b 
where b.Titolo not in (select b.Titolo
                       from Brano b join BranoxAlbum ba on ba.IDBrano=b.IDBrano)