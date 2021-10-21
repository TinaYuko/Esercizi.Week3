
create database Libreria;

create table Autore (
IDAutore int identity(1,1) constraint PK_AUTORE primary key,
Nome nvarchar(50) not null,
AnnoNascita Date not null,
AnnoMorte Date,
Nazione nvarchar(20) not null );

create table Romanzo (
IDRomanzo int identity(1,1) constraint PK_ROMANZO primary key,
Titolo nvarchar(20) not null, 
AnnoPubblicazione Date not null,
IDAutore int not null constraint FK_AUTORE foreign key references Autore(IDAutore) );

create table Personaggio (
IDPersonaggio int identity(1,1) constraint PK_PERSONAGGIO primary key,
Nome nvarchar(30),
Sesso nvarchar(20) check(Sesso='Femmina' or Sesso='Maschio' or Sesso='Non Identificato'),
Ruolo nvarchar(30) );

create table RomanzoPersonaggio (
IDRomanzo int not null constraint FK_ROMANZO foreign key references Romanzo(IDRomanzo),
IDPersonaggio int not null constraint FK_PERSONAGGIO foreign key references Personaggio(IDPersonaggio) 
constraint PK_ROMANZOPERSONAGGIO primary key(IDRomanzo, IDPersonaggio) );

insert Autore values ('Alessandro Manzoni','1870-10-21', '1930-02-11', 'Italia'),
                     ('Nenno Checov','1850-05-30', '1900-11-20', 'Russia'),
					 ('Dante Alighieri','1980-10-21', null, 'Italia'),
					 ('Diego de la Vega','1700-01-17', '1745-02-11', 'Spagna')

insert Personaggio values ('Nenna Bellinetta', 'Femmina', 'Protagonista'),
                          ('Nenno Spavaldo', 'Maschio', 'Secondario'),
						  ('Tizia Principessa', 'Femmina', 'Protagonista'),
						  ('Alieno X', 'Non Identificato', 'Antagonista'),
						  ('Nennino Potino', 'Maschio', 'Protagonista')
insert Romanzo values ('Acciaio bianco', '1750-11-25',4),
					  ('Andando al mare', '2012-01-14',3),
					  ('Viaggio al centro', '1930-07-19',2),
					  ('Sfiorando lei', '1920-08-21',2),
					  ('I promessi scopi', '1900-11-25',1),
					  ('La divina commedia', '2020-02-05',3)

insert RomanzoPersonaggio values (4,1),
                                 (4,3),
								 (5,3),
								 (5,4),
								 (5,2),
								 (6,5),
								 (6,1),
								 (6,2),
								 (7,4),
								 (7,5),
								 (8,3),
								 (8,1),
								 (8,4),
								 (9,5),
								 (9,3)

--1- Il titolo dei romanzi del 19° secolo
select r.Titolo
from Romanzo r
where r.AnnoPubblicazione between '1800-01-01' and '1900-01-01'

--2- Il titolo, l’autore e l’anno di pubblicazione dei romanzi di autori russi, ordinati per autore e, per lo stesso autore,
--ordinati per anno di pubblicazione

select r.Titolo, r.AnnoPubblicazione
from Romanzo r join Autore a on a.IDAutore=r.IDAutore
where a.Nazione='Russia'
order by a.Nome, r.AnnoPubblicazione

--3- I personaggi principali (ruolo =”Protagonista”) dei romanzi di autori viventi.

select p.*
from Personaggio p join RomanzoPersonaggio rp on rp.IDPersonaggio=p.IDPersonaggio
                   join Romanzo r on r.IDRomanzo=rp.IDRomanzo
				   join Autore a on a.IDAutore=r.IDAutore
where p.Ruolo='Protagonista' and a.AnnoMorte is null

--4- Per ogni autore italiano, l’anno del primo e dell’ultimo romanzo.
create view Italiani (Autore, Titolo, Anno)
as (
select a.Nome, r.Titolo, r.AnnoPubblicazione
from Autore a join Romanzo r on r.IDAutore=a.IDAutore
where a.Nazione='Italia' )

select i.Autore, min(i.Anno) as 'Primo libro', max(i.Anno) as 'Ultimo libro'
from Italiani i
group by i.Autore

--5- I nomi dei personaggi che compaiono in più di un romanzo, ed il numero dei romanzi nei quali compaiono
select p.Nome, count(p.Nome) as 'TotApparizioni', p.IDPersonaggio
from Personaggio p join RomanzoPersonaggio rp on rp.IDPersonaggio=p.IDPersonaggio
                   join Romanzo r on r.IDRomanzo=rp.IDRomanzo
group by p.Nome, p.IDPersonaggio
having count(p.Nome)>1

--6- Il titolo dei romanzi i cui personaggi principali sono tutti femminili.
select distinct r.Titolo
from Romanzo r join RomanzoPersonaggio rp on rp.IDRomanzo=r.IDRomanzo
               join Personaggio p on p.IDPersonaggio=rp.IDPersonaggio
where p.Ruolo='Protagonista' and p.Sesso='Femmina'

--7– Mostrare il titolo di un romanzo e di fianco un’etichetta che stabilisce che si tratta di un romanzo ‘Antico’ 
--se il suo anno di pubblicazione è precedente al 1800, neoclassico se l’anno di pubblicazione è nel secolo 1900, 
--moderno se oltre gli anni 2000

select r.Titolo, r.AnnoPubblicazione,
case
when r.AnnoPubblicazione<'1800-01-01' then 'Romanzo Antico'
when r.AnnoPubblicazione between '1900-01-01' and '1999-12-31' then 'Romanzo Neoclassico'
when r.AnnoPubblicazione>'2000-01-01' then 'Romanzo Moderno'
else 'Romanzo Normale'
end as [Tipologia Romanzo]
from Romanzo r