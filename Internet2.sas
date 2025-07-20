libname dm1 "C:\Users\nikol\Documents\DATA MINING\PROJEKT";

*cisteni dat - objevujeme chybna pozorovani
- zda nektere hodnoty nejsou mimo svuj obor hodnot:;
*POCET CHYBEJICH HODNOT LZE ZJISTIT I PRES FCI MEANS, ALE JA CHCI ZJISTIT, JESTLI TAM NEJSOU NEJAKA ODLEHLA POZOROVANI (NESMYSLY)
na to mi ale staci udelat ten podrobny pruzkum jen u prom reg; 

*1) promenna reg;
proc sql;
select reg, count(*) as cetnost
from dm1.internet
group by reg;
quit;
* v tabulce jsou obsazena vsechna pozorovani, coz znamena, ze na tuto otazku odpovedeli vsichni respondenti (nejsou zadna chybejici pozorovani teto promenne
*zaroven vidime, ze jsou vsichni respondenti zarazeni do existujicich katgorii, tato promenna neobsahuje zadne nesmyslne hodnoty mimo svuj obor hodnot;


*3) hinc - jak najit id chybejich hodnot :) ;
proc sql;
select hinc, count(*) as cetnost
from dm1.internet
group by hinc;
quit;
*2 chybejici hodnoty;
proc sql;
select id, hinc
from dm1.internet
where hinc = .;
quit;
*id chybejicich hodnot je 518 a 2468;

proc means data=dm1.internet;
run; 

ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\nmiss.pdf" style=journal;
proc means data=dm1.internet n nmiss min max;
run; 
ods pdf close;
*ZAVER: ve sloupci Nmiss vidime, ktere promenne obsahuji i chybejici hodnoty a kolik jich je (2889-N)
*nejvice pozorovani chybi u prom pinc 2889-2403 = 486, ale to je asi zpusobeno tim, ze jsou to mladi lide bez vlastniho prijmu
*pomoci sloupcu min a max zjistim, jestli nekdo nenapsal napr 99, kdyz existuji jen kategorie od 1 do 6
(akorat u prom reg, q75_1 a q78_1 to takhle zjistit nejde)
*vidim, ze je zatim vse ok, jeste tedy kouknu na posledni 2 promenne;
proc sql;
select id, agecat, pinc
from dm1.internet
where (agecat=1 or agecat=2) and pinc=.;
quit;

proc sql;
select count(*)
from dm1.internet
where (agecat=1 or agecat=2) and pinc=.;
quit; * celkem 431 lidi z tech 486 co neuvedli pinc jsou ve veku do 24 let;

proc sql;
select id, agecat, pinc
from dm1.internet
where agecat<>1 and agecat<>2 and pinc=.;
quit;
proc sql;
select *
from dm1.internet
where hint = .;
quit; * chybejici pozorovani u hint zrejme nmaji zadne takove vysvetleni...


*30) q75_1 = minut na internetu denne-vsedni dny;
proc sql;
select q75_1, count(*) as cetnost
from dm1.internet
group by q75_1;
quit;
*vidime, ze nekolik respondentu(7) uvedlo hodnotu pres 1000, coz je velmi nepravdepodobne
(vice jak 18 hodin denne, 1440 = 24 hodin denne = 2 respondenti= defaultni hodnota???)

*31) q78_1 = minut na internetu denne - o vikendu;
proc sql;
select q78_1, count(*) as cetnost
from dm1.internet
group by q78_1;
quit;
*opet ty vysoke hodnoty ...;

*******************************************************;
*370 lidi uvedlo, ze nevyuziva internetove pripojeni
652 lidi nema PC ani notebook;
data kopie2;
set dm1.internet2;
internet=q74_1 + q74_2+q74_3+q74_4+q74_5+q74_6+q74_7+q74_8+q74_9;
hry_banko=(q74_4=1 and q74_5=1);
run;

proc sql;
select *
from kopie
where q65_13=0 and internet >0 ;
quit;

proc sql;
select count(*)
from kopie
where q65_13=0 and internet >0 ;
quit;*286 lidi nepouziva internetove pripojeni, ale zaroven alespon 1 sluzbu dostupnou na internetu - jakoze jsou mozn ana PC jen v praci???;

proc sql;
select count(*)
from kopie
where q65_13=0 and internet >0 and q78_1 >60;
quit;*ale to by pak asi nemeli byt vetsinou na internetu o vikendu???
a pritom tak pulka z nich travi na internetu o vikendu vic jak hodinu
ne 2. stranu mozna chodi do prace i o vikendu...
promenna pocet minut o vikendu je teda asi celkem zavadejici a nicnerikajici, 
jestli ji budu v projektu pouzivat, musim asi hodne pozorovani odstranit...
stejne je to i u tech dalsich polozek nize;

proc sql;
select count(*)
from kopie
where q65_13=1 and q65_17=0 and q65_18=0;
quit; *388 lidi nema notebook ani pocitac, ale vyuziva internetove pripojeni 
jak je tohle mozny?!?!?! jakoze maji internet jen v mobilu???
nebo mozna spis ze ti respondenti uvazovali tak, ze maji internet v praci, tudiz maji internetove pripojeni
nebo to brali tak, ze nemaji vlastni PC, ale internet v dome ano;
proc sql;
select count(*)
from kopie
where q65_13=0 and q40_23<>6;
quit;*255 lidi nema intenet, ale zaroven aspon obcas surfuje - zase teda sai jen v praci
*(115 lidi nema internet a nesurfuje);

proc sql;
select count(*)
from kopie
where internet=0 and q65_13=1;
quit;*110 lidi nvyuziva zadnou ze sluzeb,
26 lidi nevyuziva sluzby a zaroven ma internet

NA TEHLE 26 LIDI SE JESTE PODIVAM DETAILNEJI!!!
*+kdyz uvedli pocet minu 1 nebo 2, nemysleli nahodou hodiny??;


proc sql;
select count(*)
from kopie
where internet=0 and q40_23=6 and q65_13=1;
quit;*77 lidi nepouziva zadne ty sluzby a zaroven nesurfuje
z nich ale 11 ma internet!! - asi teda ostatni doma ho jen pouzivaji??
NA TEHLE 11 SE TAKY JESTE PODIVAT (vek...)!!!;

*******!!!!!!!!!!!!!!!!!!!************************;
proc sql;
select count(*)
from kopie
where internet=0 and q75_1>30;
quit;*vztah mezi minutama a vyuzivanim sluzeb
13 lidi nevyuziva zadne sluzby a zaroven je na netu denne pres pul hodiny!!
KONTROLA!;

*vsedni dny X vikendy 
denne < vikend -> o vikendu travi na netu nadprumerne casu
-> asi prace X volny cas;
proc sql;
select count(*)
from kopie
where q75_1 < (q78_1);
quit;


*dale zkoumat:
Existují i „skoro“ duplicity – dva podobné, ale ne pøesnì totožné záznamy o
tomtéž subjektu. = multikolinearita??? asi ne tohle...;
* - tady bych mohla prozkoumat vztah mezi surfovanim  aminutama na internetu?
;
*mozna by bylo fajn prevest data z minut na hodiny, pro lepsi predstavu;
*******************************************************************;

**************dle demo kategorii**************************;
proc means data=dm1.internet;
var q75_1;
class reg;
run;
*class sex;
*Kdo tam travi (nej)vic casu? A u ktereho pohlavi/regionu
je vetsi variabilitaèasu? Co to znamena?
;
proc means data=dm1.internet;
var q75_1;
class reg sex;
run;
*********************************************************;

proc univariate data=dm1.internet2;
var q74_1--q74_9;
run;
*class sex reg...;

*Pridani histogramu + odhad hustoty;
proc univariate data=dm1.internet;
var q75_1;
histogram;
run;
*hooodne zesikmeny, velký pravý chvost
*qqplot
ppplot...;
*Histogram a odhady hustoty;
proc sgplot data=dm1.internet;
histogram q75_1;
density q75_1;
run;

*Boxplot;
ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\box1.pdf" style=journal;
proc sgplot data=dm1.internet2;
vbox q75_1/ group=agecat;
run;
ods pdf close;

ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\box1.pdf" style=journal;
proc sgplot data=dm1.internet;
vbox q75_1;
run;
proc sgplot data=dm1.internet;
vbox q78_1;
run;
ods pdf close;


proc sgplot data=dm1.internet;
vbox q75_1 / group=sex;
run;

data dm1.internet2;
set dm1.internet;
where q75_1 < 1000 and q78_1 < 1000;
run;*celkem se smazalo 20 pozorovani;


*II.) Analyza kategorialnich promennych;

*Tabulka cetnosti q7;
proc tabulate data=dm1.internet;
class q74_1;
table q74_1;
run;

*Kontingencni tabulka;
proc tabulate data=dm1.internet2;
class q74_9 marits;
table q74_9,marits ;
run;
proc tabulate data=dm1.internet2;
class q74_9 marits;
table q74_9,marits ;
run;

*Graf cetnosti;
proc gchart data=kopie;
vbar internet;
run;

*Graf relativnich cetnosti;
proc gchart data=kopie;
vbar internet / type=percent;
run;
ods graphics on;
proc freq data=kopie;
tables internet/nocum plots=freqplot(scale=percent);
run;
ods graphics off;

proc sql;
select agecat as Vìková_kategorie, count(*) as Bankovnictví
from kopie
where q74_5=1
group by agecat;
quit;
proc sql;
select agecat as Vìková_kategorie, count(*) as Hraní_her
from kopie
where q74_4=1
group by agecat;
quit;
proc sql;
select agecat as Vìková_kategorie, count(*) as Hry_bankovnictví
from kopie
where q74_5=1 and q74_4=1
group by agecat;
quit;
proc freq data=kopie2;
tables agecat*internet / norow nocol;
run;
proc freq data=kopie2;
tables agecat*internet;
run;
proc freq data=kopie2;
tables agecat*hry_banko / norow nocol;
run;

*Mnohorozmerna exploratorni analyza;
*Vypis korelacni matice;
proc corr data=dm1.internet2 noprob nosimple best=6;
var agecat marits red q74_1 -- q78_1;
run;
proc corr data=dm1.internet2 noprob nosimple best=9;
var agecat q74_1 -- q78_1;
run;

proc corr data=kopie noprob nosimple best=6;
run;
proc corr data=kopie noprob nosimple;
var agecat internet;
run;
proc corr data=kopie noprob nosimple;
var agecat internet q65_13--q78_1;
run;
proc tabulate data=kopie;
class agecat internet;
table agecat,internet ;
run;
proc tabulate data=kopie;
class agecat q40_23;
table agecat,q40_23 ;
run;
proc tabulate data=kopie;
class agecat q78_1;
table agecat,q78_1 ;
run;
*Vypis 3 nejvice korelovanych promennych pro kazdou promennou;
*zajimave pro nas: agecat a q40_23;
*mezi dummy promennymi vzdy vcelku silna zavislost kolem +-0,4;
*nejvetsi zavislost jje mezi q75_1 a q78_1 = 0,6488;


proc sql;
select q75_1, q78_1
from dm1.internet2
where agecat=1;
quit;
data dm1.internet_age1;
set dm1.internet2;
where agecat=1;
run;
data dm1.internet_age2;
set dm1.internet2;
where agecat=2;
run;
data dm1.internet_age3;
set dm1.internet2;
where agecat=3;
run;
data dm1.internet_age4;
set dm1.internet2;
where agecat=4;
run;
data dm1.internet_age5;
set dm1.internet2;
where agecat=5;
run;
data dm1.internet_age6;
set dm1.internet2;
where agecat=6;
run;




ods graphics on;
proc corresp data=dm1.internet2 dim=2 all;
tables agecat, q40_23;
run;
ods graphics off;


*Spusteni makra pro vykresleni korelogramu;
ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\correlogram.pdf" style=journal;
%corrgram(data=dm1.internet_age1, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
ods pdf close;

ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\correlogramy_age.pdf" style=journal;
%corrgram(data=dm1.internet_age1, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
%corrgram(data=dm1.internet_age2, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
%corrgram(data=dm1.internet_age3, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
%corrgram(data=dm1.internet_age4, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
%corrgram(data=dm1.internet_age5, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
%corrgram(data=dm1.internet_age6, var=marits red q40_23--q78_1, fill=S E N,alabel=90 0);
ods pdf close;


*nejde;
ods graphics on;
proc corr data=dm1.internet2 plots=all noprob nosimple nocorr;
run;
ods graphics off;


*scatter plot mi nejde...;
proc sgscatter data=dm1.internet;
matrix q75_1--q78_1/group=agecat;*nebo matrix _numeric_;
run;
proc sgplot data=dm1.internet;
scatter x=q75_1  y=q78_1 /group=agecat;
run;

*chyby v datech, dummy promennych, najit zakonitosti meezi tim...;

******NEJÈASTÌJŠÍ SLUŽBY:**********;






data dm1.internet_tran;
set dm1.internet;
keep id q74_1 q74_2 q74_3 q74_4 q74_5 q74_6 q74_7 q74_8 q74_9 q65_13 q65_17 q65_18;
run;

ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\internet_tran.pdf" style=journal;
proc print data=dm1.internet_tran label noobs;
run;
ods pdf close;

proc import out=dm1.data_final datafile="C:\Users\nikol\Documents\DATA MINING\PROJEKT\internet_trans_final.csv" replace dbms=csv;
run;



data dm1.internet_age_bez;
set dm1.internet;
keep id agecat q74_1 q74_2 q74_3 q74_4 q74_5 q74_6 q74_7 q74_8 q74_9;
run;

ods pdf file="C:\Users\nikol\Documents\DATA MINING\PROJEKT\internet_age_bez.pdf" style=journal;
proc print data=dm1.internet_age_bez label noobs;
run;
ods pdf close;


proc import out=dm1.data_final datafile="C:\Users\nikol\Documents\DATA MINING\PROJEKT\internet_trans_final.csv" replace dbms=csv;
run;

*rel cetnosti sluzeb;
proc gchart data=dm1.internet_bez_final;
vbar item / type=percent;
run;

ods graphics on;
proc freq data=dm1.internet_bez_final;
tables item/nocum plots=freqplot(scale=percent);
run;
ods graphics off;

ods graphics on;
proc freq data=dm1.pc_ntb_final;
tables v2/nocum plots=freqplot(scale=percent);
run;
ods graphics off;


proc freq data=dm1.internet2;
table q74_1*q74_2*q74_3*q74_4*q74_5*q74_6*q74_7*q74_8*q74_9/norow nocol nopercent expected chisq;
run;
