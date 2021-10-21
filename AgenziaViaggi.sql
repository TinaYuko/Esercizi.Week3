create database AgenziaViaggi;

create table Responsabile (
CodiceResponsabile int identity(1,1) constraint PK_RESPONSABILE primary key,
NomeCognome varchar(30) not null,
NumTelefono int not null check(NumTelefono>=0) );

create table Itinerario (
CodiceItinerario int identity(1,1) constraint PK_ITINERARIO primary key,
Descrizione nvarchar(100) not null,
Durata int not null check (Durata >=0),
Prezzo decimal not null check (Prezzo >=0) );

create table Gita (
CodiceGita int identity(1,1) constraint PK_GITA primary key,
DataPartenza datetime not null,
CodiceResponsabile int not null constraint FK_RESPONSABILE foreign key references Responsabile(CodiceResponsabile),
CodiceItinerario int not null constraint FK_ITINERARIO foreign key references Itinerario(CodiceItinerario) );

create table Partecipante (
CodicePartecipante int identity (1,1) constraint PK_PARTECIPANTE primary key,
NomeCognome nvarchar(30) not null,
DataNascita datetime not null,
Indirizzo nvarchar(30) not null,
Citta nvarchar(30) not null );

create table GitaPartecipante(
CodiceGita int not null constraint FK_GITA foreign key references Gita(CodiceGita),
CodicePartecipante int not null constraint FK_PARTECIPANTE foreign key references Partecipante(CodicePartecipante),

CodiceGitaPartecipante int constraint PK_GITAPARTECIPANTE primary key (CodiceGita, CodicePartecipante) );

create table Tappa (
CodiceTappa int identity(1,1) constraint PK_TAPPA primary key,
CittaDaVisitare nvarchar(30) not null,
TempoPermanenza int not null check (TempoPermanenza >=0) );

create table TappaItinerario (
CodiceTappa int constraint FK_TAPPA foreign key references Tappa(CodiceTappa),
CodiceItinerario int constraint FK_ITINERARIO_Tappa foreign key references Itinerario(CodiceItinerario),

CodiceTappaItinerario int constraint PK_TAPPAITINERARIO primary key (CodiceTappa, CodiceItinerario) );


/* 
1. Mostrare tutti i dati dei partecipanti di Roma
2. Mostrare i dati degli itinerari con prezzo superiore ai 500 euro o durata superiore ai 7 giorni
3. Selezionare la data di partenza delle gite il cui itinerario ha un prezzo superiore ai 100 euro
4. Mostrare nome, cognome e numero di telefono dei responsabili delle gite inpartenza il 3 Aprile 2022
5. Mostrare i dati degli itinerari ordinati per prezzo e per durata
6. Mostrare i dati degli itinerari con durata massima e minima
7. Mostrare le gite in partenza tra il 1 Gennaio 2021 ed il 31 Dicembre 2021*/

--1.
Insert Partecipante values ('Mario Rossi', '1976-10-23','Via Genovesi 17', 'Roma'),
                           ('Lucia Romani', '1990-07-13','Via Sardegna 45b', 'Roma'),
						   ('Marta Minghi', '1989-01-25','Via Amalfi 28', 'Civitavecchia'),
						   ('Enzo Bini', '1966-03-27','Via Napoli 3', 'Tivoli');
select p.NomeCognome, p.Citta
from Partecipante p
where Citta='Roma'

--2.
insert Itinerario values ('Passeggiata su quel Ramo del lago di Como', 300, 175.90),
                         ('Visita la costiera Ovest della Sardegna', 600, 450.90),
						 ('Trekking al parchetto dietro casa', 120, 15.90),
						 ('Giretto al Mcdonald''s', 110, 25.90);
select i.*
from Itinerario i
where i.Prezzo>500 or i.Durata>350

--3.
insert Responsabile values ('Gino ilPostino', 3476754),
                           ('Salvo Acasa', 3216785),
						   ('Amedeo Minghi', 3470054),
						   ('Mirko Menevado', 3289045);
insert Gita values ('2021-10-23 10:00',2,1),
                   ('2021-10-27 5:00',3,2),
				   ('2021-12-23 17:00',4,3),
				   ('2022-01-17 9:00',5,4);

select i.prezzo, g.DataPartenza
from Gita g join Itinerario i on i.CodiceItinerario=g.CodiceItinerario
group by i.Prezzo, g.DataPartenza
having i.Prezzo>100


--4.
select r.NomeCognome, r.NumTelefono 
from Responsabile r join Gita g on g.CodiceResponsabile=r.CodiceResponsabile
where g.DataPartenza='2022-04-03'

--5.
select *
from Itinerario
order by Itinerario.Prezzo, Itinerario.Durata

--7.
select *
from Gita g
where g.DataPartenza between '2021-01-01' and '2021-12-31'


--6.
select i.Descrizione, i.Durata
from Itinerario i
where i.Durata= (select max(Durata) from Itinerario)
	union  
select i.Descrizione, i.Durata
from Itinerario i
where i.Durata= (select min(Durata) from Itinerario)



--case
--classifica degli itinerari

select i.Descrizione, i.Durata, i.Prezzo,
case
when i.Prezzo<100 or i.Durata<180 then 'Gita dei burdi'
when i.Prezzo>=400 or i.Durata>500 then 'Gita scetti scetti'
else 'Gita normale'
end as [Tipo Itinerario]
from Itinerario i






















