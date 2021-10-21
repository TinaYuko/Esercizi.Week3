--commenti una sola riga
/* per più righe*/


create database Cinema;

create table Attore (
CodiceAttore int IDENTITY(1,1) constraint PK_ATTORE primary key,
Nome nvarchar(30) not null,
Nazionalita nvarchar(20) not null,
DataNascita DateTime);

create table Sala (
CodiceSala int IDENTITY(1,1) constraint PK_SALA primary key,
Nome nvarchar(30) not null,
PostiTotali int not null check (PostiTotali >=0),);

create table Film (
CodiceFilm int IDENTITY(1,1) constraint PK_FILM primary key,
Titolo nvarchar(50) not null,
Genere nvarchar (20) not null,
Durata int not null check(Durata >=0),);

alter table Film add constraint CHK_GENERE check (Genere= 'Fantasy' or Genere= 'Horror' or Genere= 'Comedy');

create table FilmAttore(
CodiceFilm int not null,
CodiceAttore int not null,
Cachet decimal(9,2) check (Cachet >=0),
constraint FK_FILM foreign key (CodiceFilm) references Film(CodiceFilm),
constraint FK_ATTORE foreign key (CodiceAttore) references Attore(CodiceAttore),
constraint PK_FILMATTORE primary key (CodiceFilm, CodiceAttore) );

create table Programmazione (
CodiceProgrammazione int identity(1,1) primary key,
DataOra datetime not null,
PostiDisponibili int  not null, check (PostiDisponibili >=0),
CodiceFilm int not null constraint FK_FILM_Progr foreign key references Film(CodiceFilm),
CodiceSala int not null constraint FK_SALA_Progr foreign key references Sala(CodiceSala), );

create table Prenotazione (
CodicePrenotazione int identity(1,1) primary key,
Email nvarchar(30) not null,
PostiDaPrenotare int not null check(PostiDaPrenotare >=0),
CodiceProgrammazione int not null constraint FK_PROGRAMMAZIONE_Prenot foreign key references Programmazione(CodiceProgrammazione) );



--Inserimento dati
--insert into NomeTabella values (elenco dei valori da inserire nell'ordine delle colonne)
insert Film values ('Il signore degli anelli', 'Fantasy', 180);
insert Film values ('It', 'Horror', 110),
                   ('Tutti pazzi per Mary', 'Comedy', 140);

insert into Attore values ('Viggo Mortensen', 'Americana', '1975-10-25'),
                          ('Ben Stiller', 'Americana', '1964-06-11');

insert into FilmAttore values (3,1, 200000.58);
insert into FilmAttore values (5,2, 80500.00);

insert into Sala values ('Sala 6', 180),
                        ('Sala 7', 220);

insert into Programmazione values ('2021-11-22 21:00', 45, 3,2);
insert into Prenotazione values ('martina.mattana@hotmail.it', 2, 1);

--update
--ovvero, aggiornamento di dati già immessi
-- update nometabella set 
update Film set Durata=126 where CodiceFilm=4;

--delete 
--delete from nometabella where... 
delete from Film where CodiceFilm=1;

--select
select * from Film; --per selezionare tutta la tabella
select Titolo, Genere from Film; -- per un sottoinsieme di campi 
select distinct Genere from Film; --per vedere solo un campo distinto

--alias
select Titolo as [Titolo del Film]
from Film;

select f.Titolo
from Film as f --as è opzionale

select*from Film;
select*from Attore;
select*from FilmAttore;
select*from Sala;
select*from Programmazione;
select*from Prenotazione;


insert into Film values ('Dott. Dolittle', 'Comedy', 120),
                        ('Lo Hobbit', 'Fantasy', 175);

--Selezionare titolo e genere dei film su un film in particolare
select Titolo, Genere
from Film
where Titolo like 'Il signore%'
-- il segno % considera anche gli spazi, si usa per sostituire una stringa 

--Distinct
--Selezionare tutti i genere dei film (distinti)
select distinct Genere from Film 
--Selezionare tutti i film Comedy con durata inferiore a 130 min
select*from Film where Genere='Comedy' and Durata<130
--Selezionare tutti i film comedy o con durata inferiore a 130 min
select*from Film where Genere='Comedy' or Durata<150;
--Selezionare i dati del film per cui esiste una programmazione 
select Film.*
from Film, Programmazione
where Programmazione.CodiceFilm=Film.CodiceFilm

insert into Programmazione values ('2021-12-17 21:00', 57, 6,2);

--join, stessa cosa di where
select Film.*
from Film join Programmazione on Programmazione.CodiceFilm=Film.CodiceFilm

--left join
select *
from Film left join Programmazione on Programmazione.CodiceFilm=Film.CodiceFilm
--outer join
select *
from Film full outer join Programmazione on Programmazione.CodiceFilm=Film.CodiceFilm

--order by
select* from Film order by Titolo desc

select*from Film order by Genere, Durata desc

--selezionare Titolo, genere, data e ora di programmazione e posti disponibili
select f.Titolo, f.Genere, p.DataOra as [Data e Ora di Programmazione], p.PostiDisponibili
from Film as f join Programmazione as p on f.CodiceFilm=p.CodiceFilm

--selezionare il titolo dei film per cui è prevista una programmazione nella sala 7
--con where
select f.Titolo
from Film f, Programmazione p, Sala s
where f.CodiceFilm=p.CodiceFilm and s.CodiceSala=p.CodiceSala and s.Nome='Sala 7'
--con join
select f.Titolo
from Film f join Programmazione p on f.CodiceFilm=p.CodiceFilm
            join Sala s on s.CodiceSala=p.CodiceSala
where s.Nome='Sala 7'

--Query di riepilogo
select*
from Film f full outer join Programmazione p on f.CodiceFilm=p.CodiceFilm
            full outer join Sala s on s.CodiceSala=p.CodiceSala
			full outer join Prenotazione pr on pr.CodiceProgrammazione=p.CodiceProgrammazione
			full outer join FilmAttore fa on fa.CodiceFilm=f.CodiceFilm
			full outer join Attore a on a.CodiceAttore=fa.CodiceAttore


--Esercitazione
--1. Mostrare tutti gli attori del film Il signore degli anelli in ordine alfabetico crescente
--2. Mostrare Nome, nazionalità e cachet percepito dagli attori di Tutti pazzi per Mary in ordine decrescente per cachet percepito.
--3. Mostrare tutti gli attori dei film programmati nella sala 7.
--4. Mostrare quanti posti disponibili ci sono nella programmazione di oggi alle 17:00 del film Tutti pazzi per Mary.
--5. Mostrare gli attori (nome e data di nascita) dei soli film proiettati oggi nella sala 7 se i posti disponibili sono maggiori di 30 e se il cachet percepito è superiore a 1000 euro

insert into FilmAttore values (3,2, 100230.00);
insert into FilmAttore values (5,1, 100500.50);
insert into Programmazione values ('2021-10-20 17:00', 35, 5,1)
insert into Attore values ('Harrison Ford', 'Americana', '1954-04-10')
insert into Attore values ('Meryl Streep', 'Americana', '1961-07-10')
insert into FilmAttore values (3,3, 200230.00);
insert into FilmAttore values (5,4, 300500.50);



--1
select a.Nome 
from Attore a join FilmAttore fa on a.CodiceAttore=fa.CodiceAttore
              join Film f on f.CodiceFilm=fa.CodiceFilm
where f.Titolo='Il signore degli anelli'
order by Nome
--2
select a.Nome, a.Nazionalita, fa.Cachet
from Attore a join FilmAttore fa on a.CodiceAttore=fa.CodiceAttore
              join Film f on f.CodiceFilm=fa.CodiceFilm
where f.Titolo='Tutti pazzi per Mary' 
order by fa.Cachet desc
--3
select a.*
from Attore a join FilmAttore fa on a.CodiceAttore=fa.CodiceAttore
			  join Film f on f.CodiceFilm=fa.CodiceFilm
              join Programmazione p on p.CodiceFilm=f.CodiceFilm 
			  join Sala s on s.CodiceSala=p.CodiceSala
where s.Nome='Sala 7'
--4
select p.PostiDisponibili
from Programmazione p join Film f on f.CodiceFilm=p.CodiceFilm
where f.Titolo='Tutti pazzi per Mary' 
--in sostituzione di p.dataora='2021-10-20 17:00'
--metto tutto questo casino perché se me lo chiedono domani non sarà più 20 Ottobre eheh
and DATEPART(DAYOFYEAR, SYSDATETIME())=DATEPART(DAYOFYEAR, p.DataOra)
and DATEPART(HOUR, p.DataOra)=17
and DATEPART(MINUTE,p.DataOra)=0

--5
select a.Nome, a.DataNascita
from Attore a join FilmAttore fa on a.CodiceAttore=fa.CodiceAttore
              join Film f on f.CodiceFilm=fa.CodiceFilm
              join Programmazione p on p.CodiceFilm=f.CodiceFilm 
			  join Sala s on s.CodiceSala=p.CodiceSala
where s.Nome='Sala 7' and p.PostiDisponibili>30 and fa.Cachet>1000 
and DATEPART(DAYOFYEAR, SYSDATETIME())=DATEPART(DAYOFYEAR, p.DataOra)

--In
--Per specificare più valori in una clausola where o nel check
-- anziché where genere=storico or genere =horror
--where genere in(storico, horror)
select*
from Film
where Genere in ('Fantasy', 'Comedy')

--between
select *
from Programmazione
-- anziché where Dataora >='2021-06-01' and DataOra<='2021-12-30'
where DataOra between '2021-06-01' and '2021-12-30'

insert Sala values ('Sala 8', 180);
--group by
--raggruppa righe con gli stessi valori
--es.numero programmazioni nelle sale
select s.CodiceSala, s.Nome, COUNT(p.CodiceProgrammazione) as 'NumProgrammazioni'
from Programmazione p right join Sala s on s.CodiceSala=p.CodiceSala
group by s.CodiceSala, s.Nome

--es2. mostrare durata massima, minima e media dei film per genere
select Genere, MAX(Durata) as 'Max', MIN(Durata) as 'Min', AVG(Durata) as 'Media'
from Film f
group by Genere

--having viene implementata perché non è possibile usare where dopo group by
--visualizzare le sale con il numero di programmazione che hanno una media di posti disponibili maggiore di 30
select s.Nome, COUNT(p.CodiceProgrammazione) as 'NumProgrammazioni'
from Sala s left join Programmazione p on p.CodiceSala=s.CodiceSala
group by s.Nome
having AVG(p.PostiDisponibili)>30

insert Prenotazione values ('martina@gmail.com',5, 2),
                           ('mattana@live.it', 7, 1),
						   ('m.mattana@hotmail.it', 2, 3);
--somma dei posti prenotati per programmazione
select p.CodiceProgrammazione, SUM(pr.PostiDaPrenotare) as 'PostiPrenotati'
from Prenotazione pr join Programmazione p on pr.CodiceProgrammazione=p.CodiceProgrammazione
group by p.CodiceProgrammazione







