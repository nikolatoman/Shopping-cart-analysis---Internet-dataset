libname dm1 "C:\Users\nikol\Documents\DATA MINING\PROJEKT";

*cisteni dat - objevujeme chybna pozorovani
- zda nektere hodnoty nejsou mimo svuj obor hodnot:;
*POCET CHYBEJICH HODNOT LZE ZJISTIT I TAKTO, ALE JA CHCI ZJISTIT, JESTLI TAM NEJSOU NEJAKA ODLEHLA POZOROVANI (NESMYSLY)
na to mi ale staci udelat ten podrobny pruzkum jen u prom reg; 
proc means data=dm1.internet;
run; 
*1) promenna reg;
proc sql;
select reg, count(*) as cetnost
from dm1.internet
group by reg;
quit;
* v tabulce jsou obsazena vsechna pozorovani, coz znamena, ze na tuto otazku odpovedeli vsichni respondenti (nejsou zadna chybejici pozorovani teto promenne
*zaroven vidime, ze jsou vsichni respondenti zarazeni do existujicich katgorii, tato promenna neobsahuje zadne nesmyslne hodnoty mimo svuj obor hodnot, (defaultni?);

*2) prom vb;
proc sql;
select vb, count(*) as cetnost
from dm1.internet
group by vb;
quit;
*stejny (tj. dobry) vysledek - zadny blbiny ani chybejici hodnoty;

*3) hinc;
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

*4) hmem;
proc sql;
select hmem, count(*) as cetnost
from dm1.internet
group by hmem;
quit;
* hodnoty od 1 do 11 - asi tedy ok;
proc sql;
select id, hmem
from dm1.internet
where hmem = .;
quit;
*4 chybejici hodnoty s id 518, 597, 2144, 2468;

*5) hint;
proc sql;
select hint, count(*) as cetnost
from dm1.internet
group by hint;
quit;
* hodnoty od 1 do 5 - ok;
proc sql;
select id, hint
from dm1.internet
where hint = .;
quit;
*25 chybejicich hodnoty s id ...;

*6) fixline;
proc sql;
select fixline, count(*) as cetnost
from dm1.internet
group by fixline;
quit;
* hodnoty 1 a 2 - ok (ano/ne);
proc sql;
select id, fixline
from dm1.internet
where fixline = .;
quit;
*2 chyb. hodn, id chybejicich hodnot je 518 a 2468;

*7) hcar;
proc sql;
select hcar, count(*) as cetnost
from dm1.internet
group by hcar;
quit;
* hodnoty od 1 do 3 - ok;
proc sql;
select id, hcar
from dm1.internet
where hcar = .;
quit;
*2 chyb. hodn, id chybejicich hodnot je 518 a 2468;

*8) sex;
proc sql;
select sex, count(*) as cetnost
from dm1.internet
group by sex;
quit;
* hodnoty 1 a 2 - ok;
* zadne chyb pozorovani;

*9) agecat;
proc sql;
select agecat, count(*) as cetnost
from dm1.internet
group by agecat;
quit;
* hodnoty od 1 do 6 - ok;
* zadne chyb pozorovani;

*10) marits;
proc sql;
select marits, count(*) as cetnost
from dm1.internet
group by marits;
quit;
* hodnoty od 1 do 5 - ok;
* zadne chyb pozorovani;

*11) red;

*12) empst;


*13) hhead;


*14) pinc;


*15) sim;


*16) seg_Is;


*17) q74#1;


*18) q74#2;


*19) q74#3;


*20) q74#4;


*21) q74#5;


*22) q74#6;


*23) q74#7;


*24) q74#8;


*25) q74#9;


*26) q65#13;


*27) q65#17;


*28) q65#18;


*29) q40_23;


*30) q75_1;


*31) q78_1;