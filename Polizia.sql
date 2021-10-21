

/*
Creare il database "POLIZIA" per gestire l'associazione tra agenti di polizia e le aree 
metropolitane che devono pattugliare (può essere che un agente venga assegnato a più aree. 
Un’area è sorvegliata da almeno un agente)
Entità coinvolte in questo esercizio:
AGENTE DI POLIZIA:
- nome (stringa obbligatoria di massimo 30 caratteri)
- cognome (stringa obbligatoria di massimo 50 caratteri)
- codice fiscale (stringa di 16 caratteri obbligatoria)
- data di nascita (data obbligatoria. Deve essere maggiorenne)
- anni di servizio (valore numerico valorizzato con gli effettivi anni di servizio)

AREA METROPOLITANA
- codice area (stringa alfabetica di 5 caratteri che identifica l'area (non è l'id))
- alto rischio (valore che può assumere "0" o "1" a seconda se l'area è considerata ad alto rischio)
individuare la soluzione più adatta a livello di tabelle e creare tutte le relazioni necessarie.
IMPLEMENTARE I SEGUENTI VINCOLI:
-gli id devono essere auto incrementali
-l'agente di polizia deve essere maggiorenne
-il codice fiscale non può essere duplicato

visualizzare l'elenco degli agenti che lavorano in "aree ad alto rischio" e hanno meno di 3 anni di servizio
visualizzare il numero di agenti assegnati per ogni area geografica (numero agenti e codice area)*/

create database Polizia;

create table Agente (
IDAgente int IDENTITY(1,1) constraint PK_ATTORE primary key,
Nome nvarchar (30) not null,
Cognome nvarchar(30) not null,
CodiceFiscale nvarchar(16) unique not null,
DataNascita date not null check ((DATEPART(YEAR, SYSDATETIME()))-(DATEPART(YEAR, DataNascita))>=18),
AnniServizio int not null check(AnniServizio>0) );

Create table AreaMetropolitana (
IDArea int IDENTITY (1,1) constraint PK_AREA primary key,
CodiceArea nvarchar(10) not null,
AltoRischio int not null check (AltoRischio=0 or AltoRischio=1) );

create table AreaAgente (
IDAgente int not null constraint FK_AGENTE foreign key references Agente(IDAgente),
IDArea int not null constraint FK_AREA foreign key references AreaMetropolitana(IDArea),
constraint PK_AREAGENTE primary key(IDAgente, IDArea) );

insert Agente values ('Matteo', 'Mura', 'MRAMTT87H23C254Z', '1987-08-23', 5),
                     ('Andrea', 'Cocco', 'NDRCCC92C11A371Y', '1992-03-11', 3),
					 ('Benedetta', 'Rossi', 'BDTRSS89H65C187A', '1989-08-25', 7)

insert AreaMetropolitana values ('AAA123', 0),
                                ('AAA124', 1),
								('ABA111', 0),
								('CAA122', 0),
								('BAA113', 1)
insert AreaAgente values (1,2),
                         (2,1),
						 (3,3),
						 (3,4),
						 (1,5)

/*
1. Visualizzare l'elenco degli agenti che lavorano in "aree ad alto rischio" e hanno meno di 3 anni di servizio
2. Visualizzare il numero di agenti assegnati per ogni area geografica (numero agenti e codice area) */

--1.
select a.* 
from Agente a join AreaAgente aa on a.IDAgente=aa.IDAgente
              join AreaMetropolitana am on aa.IDArea=am.IDArea
where am.AltoRischio=1 and a.AnniServizio<3

--2.
select count(a.IDAgente) as 'NumAgenti', am.CodiceArea
from Agente a join AreaAgente aa on a.IDAgente=aa.IDAgente
              join AreaMetropolitana am on am.IDArea=aa.IDArea
group by am.CodiceArea


