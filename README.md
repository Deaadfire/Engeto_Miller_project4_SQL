# Engeto_Miller_project4_SQL
Tento projekt má za úkol připravit potřebné podklady pro zodpovězení několika výzkumných otázek ohledně dostupnosti potravin  
na základě průměrných příjmů za vymezené časové období v České republice.    

Infomace o mzdách a cenách vybraných potravit pochází z **Portálu otevřených dat ČR**.  
Data pro mzdy jsou dostupné v rozpětí let 2000-2021, pro ceny potravin poté pouze pro 2006-2018.  
Pro zodpovězení otázek, týkající se zároveň mezd a cen, je směrodatné období 2006-2018, kdy jsou dostupná data pro obě kategorie.  

## Výzkumné otázky ##
Pro zodpovězení zkoumaných výzkumných otázek slouží dodatečné SQL skripty, které jsou dostupné v souboru **Miller_SQL_questions.sql**.  
Pro lepší přehlednost / pochopení dat může každá otázka obsahovat více než jen 1 skript.    

### Přehled otázek ###
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?  

### Otázka č. 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? ###  
Pomocné skripty:
- Otázka č. 1, skript č. 1
- Otázka č. 1, skript č. 2  

První skript nám ukazuje seznam všech odvětví a kolikrát se za sledované obdbobí 2000-2021 průměrná mzda meziročně zvedla a kolikrát klesla.  
Můžeme vidět, že v drtivé většině má každé odvětví tendenci meziročně růst. "Nejhůře" na tom je odvětví Těžba a dobývání, které kleslo celkově 4x za 21 let.  
<img width="936" height="396" alt="Q1_s1" src="https://github.com/user-attachments/assets/0807ccd6-c2a9-41b0-94c6-53085357ee1a" />  

Druhý skript nám pak přesně ukazuje jaké odvětví a v jakém roce mělo meziroční pokles mezd. Můžeme si všimnout, že největší pád byl v roce 2013, kde celkově 11 odvětví zaznamenalo meziroční pokles mezd s největším dopadem na Peněžnictví a pojišťovnictví
<img width="838" height="600" alt="Q2_s2" src="https://github.com/user-attachments/assets/1643c242-119b-4ee6-8ff5-aa901187a724" />  

**Závěrem:**  
Mzdy rostou stabilně ve všech odvětvích jen s malými odchylky. Ze zkoumaných 21 let mělo nejčetnější propad mezd odvětví Těžba a dobývání a to 4x.   
Nejhorší rok pro vývoj mezd byl pak 2013, kdy meziročně kleslo 11 odvětví.  


### Otázka č. 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? ###
Pomocné skripty:
- Otázka č. 2, skript č. 1

Tento skript nám již přímo ukazuje požadovaný výsledek - požadované období, chléb a mléko, průměrný plat pro všechny odvětví za daný rok, průměrné ceny za daný rok a počet litrů mléka / kilo chleba, které si lze za danou mzdu s danou cenou koupit.  
Jak bylo zmíněno na začátku, období, které je společné pro mzdy a ceny je 2006-2018, proto bereme přímo tyto dva roky.
<img width="974" height="105" alt="Q2_s1" src="https://github.com/user-attachments/assets/e8be31c5-8da3-4813-a9e9-dc514b163f70" />


**Závěrem:**  
Za první srovnatelné období (rok 2006) si lze koupit 1,287.16 KG chleba a 1,437.46 litrů mléka.  
Za poslední srovnatelné obdboí (rok 2018) si lze koupit 1,342.32 KG chleba a 1,641.77 litrů mléka.  
Byly brány průměrné mzdy všech odvětví a průměrné ceny produktů za celý rok. Výsledky zaokrouhleny na 2 desetinná místa pro přehlednost.  

### Otázka č. 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? ###
Pomocné skripty:
- Otázka č. 3, skript č. 1
- Otázka č. 3, skript č. 2

První skript nám ukazuje seznam všech kategorií, průměrnou meziroční změnu v procentech a počet let, kdy meziroční změnu šlo získat.  
Dle dat vyšlo, že nejpomaleji zdražuje Cukr krystal s průměrnou meziroční změnou -1.92, tedy zápornou. Což znamená, že v průměru produkt nezdražuje, ale naopak zlevňuje.  
Na první pohled poté dle dat nejrychleji zdražují Papriky, ovšem k ověření nám poslouží druhý skript.  
Dále díky sloupci years_counted, tedy počtu let, kdy šlo meziroční změnu získat, si můžeme všimnout, že pro Jakostní víno bílé máme neúplná data - pouze 3 meziroční změny místo 12. Výsledek bude tedy dost možná velmi zkreslený.  
<img width="588" height="548" alt="Q3_s1" src="https://github.com/user-attachments/assets/73b72537-6c53-46cf-977d-fc6d430e6a8a" />

Druhý skript je pak čistě pro ověření správnosti výsledků, ukazuje průměrnou cenu všech potravin za všechny sledované roky.  
Můžeme vidět, že Cukr krystal začínal v roce 2006 na ceně 21.73 Kč a skončil v roce 2018 na ceně 15.75 Kč - což potvrzuje, že v průměru meziročně zlevňuje.  
Pro Jakostní víno bíle máme pak pouze data v období let 2015-2018, což potvrzuje neúplnost dat pro tento produkt.  
Když se podíváme i na Papriky, zda opravdu zdražují nejrychleji, můžeme si všimnout obrovského nárůstu v ceně mezi rokem 2006 (cena 35.31 Kč) a 2007 (cena 68.79 Kč), procentuálně pak nárůst o 95 %. V dalších letech pak cena spíše osciluje. Proto je finální průměr hodně zkreslený a neodpovídá skutečnosti. Pokud by se tento extrém vyřadil, výsledek Paprik by byl mnohem jiný.  
<img width="475" height="279" alt="Q3_s2_1" src="https://github.com/user-attachments/assets/6b3c9ca4-b41e-4426-8633-500b6586739a" />  
<img width="478" height="275" alt="Q3_s2_2" src="https://github.com/user-attachments/assets/326c9ad2-3c89-4eaf-b8f8-7bc36dc34fc0" />


**Závěrem:**  
Nejpomaleji zdražuje kategorie potravin Cukr krystal s průměrnou meziroční změnou o -1.92 %.  
Kategorie Jakostní víno bíle má dostupné data pouze pro 4 roky.  


### Otázka č. 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? ###
Pomocné skripty:
- Otázka č. 3, skript č. 1

Tento skript nám pro dané roky ukazuje průměrné mzdy, průměrné ceny, průměrné meziroční změny mezd, průměrné meziroční změny cen a meziroční rozdíl mezi změnami cen a mezd.  
Z výsledků vyplývá, že nejvyšší rozdíl mezi nárůstem cen a nárůstem (poklesem) mezd byl v roce 2013, kdy průměrně mzdy meziročně klesly o 1.56 % a ceny potravin narostly o 5.1 %. Jedná se ale jen o rozdíl 6.66 %.
Naopak v roce 2009 byl největší rozdíl z opačné strany, kdy mzdy vzrostly o 3.16 % a ceny klesly o 6.41 %, což dává rozdíl -9.58 %.  
Je potřeba ještě podotknout produkt Jakostní víno bílé, u kterého jsme zjistili, že obsahuje pouze data pro 4 roky, což může ovlivnit výslednou průměrnou cenu všech potravin za dané roky. Nicméně celkový počet kategorií v našem "potravinovém koši" je 27 a cena Vína nevybočuje z průměru až tak závažně, takže váha této odchylky nebude signifikantní.
<img width="1196" height="263" alt="Q4_s1" src="https://github.com/user-attachments/assets/707cad0d-f12f-4124-881b-b90398a484cd" />  

**Závěřem:**  
Ne, neexistuje rok, kdy by byl meziroční nárůst cen potravin vyšší než 10 % oproti nárůstu mezd.  
Nejvyšší zjištěný rozdíl byl v roce 2016 a činil 6.66 %.  
Naopak nejvyšší rozdíl nárůstu mezd proti nárůstu cen potravin byl v roce 2009 a činil 9.58 %.  


### Otázka č. 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?  ###
Pomocné skripty:
- Otázka č. 5, skript č. 1
- Otázka č. 5, skript č. 2
