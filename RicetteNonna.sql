create database RicetteNonna;

create table Libro (
CodiceLibro int Identity(1,1) constraint PK_LIBRO primary key,
Titolo nvarchar(50) not null, );

create table Ricetta (
CodiceRicetta int identity(1,1) constraint PK_RICETTA primary key,
Nome nvarchar(20) not null,
QuantePersone int not null check (QuantePersone >=0),
Preparazione nvarchar(300) not null,
Tempo int not null check (Tempo >=0),
CodiceLibro int not null constraint FK_LIBRO foreign key references Libro(CodiceLibro) );

create table Ingrediente (
CodiceIngrediente int identity(1,1) constraint PK_INGREDIENTE primary key,
Nome nvarchar(30) not null,
UnitaDiMisura nvarchar(10) not null );

create table RicettaIngrediente (
CodiceRicetta int not null constraint FK_RICETTA foreign key references Ricetta(CodiceRicetta),
CodiceIngrediente int not null constraint FK_INGREDIENTE foreign key references Ingrediente(CodiceIngrediente),
Quantità int not null check(Quantità>=0),
constraint PK_RICETTAINGREDIENTE primary key(CodiceRicetta, CodiceIngrediente) );


--1.Visualizzare tutta la lista degli ingredienti distinti.
--2.Visualizzare tutta la lista degli ingredienti distinti utilizzati in almeno una ricetta.
--3.Estrarre tutte le ricette che contengono l’ingrediente uova.
--4.Mostrare il titolo delle ricette che contengono almeno 4 uova
--5.Estrarre tutte le ricette dei libri di Tipologia=Secondi per 4 persone contenenti l’ingrediente carne
--6.Mostrare tutte le ricette che hanno un tempo di preparazione inferiore a 10 minuti.
--7.Mostrare il titolo del libro che contiene più ricette
--8.Visualizzare i Titoli dei libri ordinati rispetto al numero di ricette che contengono 
--(il libro che contiene più ricette deve essere visualizzato per primo, quello con meno ricette per ultimo) e, 
--a parità di numero ricette in ordine alfabetico su Titolo del libro.

--1.
insert Ingrediente values ('Farina', 'g'),
						  ('Sale', 'g'),
						  ('Olio', 'ml'),
						  ('Latte', 'ml'),
						  ('Cioccolato', 'g'),
						  ('Uova', 'g')

select distinct *
from Ingrediente

--2.
insert Libro values ('Ricette dei dolci')
insert Ricetta values ('Torta', 6, 'Vabbe, mischia gli ingredienti e cuoci in forno a 180°', 60, 1)
insert RicettaIngrediente values (1, 1, 100),
								 (1, 4, 100),
								 (1, 5, 50),
								 (1, 6, 2)

select distinct i.*
from RicettaIngrediente ri join Ingrediente i on i.CodiceIngrediente=ri.CodiceIngrediente
where ri.CodiceRicetta=1

--3.
insert Libro values ('Ricette dei primi')
insert Ricetta values ('Pasta all''uovo base', 4, 'Segui il tuo cuore', 120, 2)
insert RicettaIngrediente values (2, 1, 200),
								 (2, 2, 100),
								 (2, 3, 50),
								 (2, 6, 2)

select r.*
from Ricetta r join RicettaIngrediente ri on r.CodiceRicetta=ri.CodiceRicetta
               join Ingrediente i on i.CodiceIngrediente=ri.CodiceIngrediente
where i.Nome='Uova'

--4.
select r.Nome
from Ricetta r join RicettaIngrediente ri on r.CodiceRicetta=ri.CodiceRicetta
               join Ingrediente i on i.CodiceIngrediente=ri.CodiceIngrediente
where i.Nome='Uova' and ri.Quantità>=4 

--5.
insert Ingrediente values ('Manzo', 'g'),
						  ('Maiale', 'g'),
						  ('Zucchine', 'g'),
						  ('Soia', 'ml'),
						  ('Pomodori', 'g'),
						  ('Peperoni', 'g')

insert Libro values ('Ricette dei secondi')
insert Ricetta values ('Manzo alla diavola', 6, 'Segui il tuo cuore', 40, 3)
select * from Ingrediente                     
insert RicettaIngrediente values (3, 7, 200),
								 (3, 2, 5),
								 (3, 3, 10),
								 (3, 11, 100)
insert Ricetta values ('Maiale alle zucchine', 4, 'Segui il tuo cuore', 50, 3)
insert RicettaIngrediente values (4, 8, 200),
								 (4, 2, 5),
								 (4, 3, 10),
								 (4, 9, 200)

select r.*
from Ingrediente i join RicettaIngrediente ri on ri.CodiceIngrediente=i.CodiceIngrediente
                   join Ricetta r on r.CodiceRicetta=ri.CodiceRicetta
				   join Libro l on l.CodiceLibro=r.CodiceLibro
where l.Titolo like '%secondi' and r.QuantePersone>=4 and i.Nome='Manzo'

--6.
insert Ricetta values ('Uovo in padella', 2, 'Segui il tuo cuore', 7, 3)
insert RicettaIngrediente values (5, 6, 100),
								 (5, 2, 5)
								 
select r.*
from Ricetta r 
where r.Tempo<10

--7.
--creo una tabella vista
create view NewNumRicette (Titolo, TotRicette) 
as (select l.Titolo as Titolo, count(r.Nome) as 'TotRicette'
   from Libro l join Ricetta r on r.CodiceLibro=l.CodiceLibro
   group by l.Titolo)

select Titolo, TotRicette
from NewNumRicette
where TotRicette= (select max(TotRicette) from NewNumRicette)


--8.
select l.Titolo, count(r.Nome) as 'TotRicette'
from Libro l join Ricetta r on r.CodiceLibro=l.CodiceLibro
group by l.Titolo
order by count(r.Nome) desc, l.Titolo