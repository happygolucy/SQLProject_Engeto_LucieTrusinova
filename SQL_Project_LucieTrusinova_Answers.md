Pro účely naší analýzy byly vytvořeny 2 tabulky: první s daty pro roky 2006 až 2018 o výši mezd podle odvětví pracovního oboru a cen potravin podle jejich kategorií v České republice, druhá s daty o evropských státech.  

**Otazka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Mzdy napříč léty rostou ve všech odvětvích, v mnoha případech ovšem můžeme sledovat také pokles mezi individuálními roky napříč různými odvětvími. Celkem takových případů zaznamenáváme 23, přičemž největší pokles se zaznamenal z roku 2012 na rok 2013 v oboru Peněžnictví a pojišťovnictví o 8,91%.  
Naopak největší růst sledujeme v roce 2008 v oboru Těžba a dobývání, kde sledujeme procentuální růst 13,81% oproti předešlému roku.   
Celkově napříč celým sledovaným odvětvím vidíme největší procentuální růst mzdy v odvětví Zdravotní a sociální péče, kde mzda stoupla od roku 2006 až 2018 o 76,94%.

První jsem vytvořila view, kde jsem z původní tabulky vytáhla pouze potřebné informace pro tuto otazku a dále jednoduchými selecty a joiny porovnavala data mezi jednotlivými roky. Nejdulezitejsi je pro me druhý select, kde ukazuji procentualni rust a take select třetí, kde sleduji celkový růst napříč odvětvími za pomoci agregačních funkcí. 

**Otazka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

K této otázce je zapotřebí pouze primární tabulka, ze které jsem schopna extrahovat data pro potřebné roky \- tedy ceny Mléka polotučného pasterovaného a Chlebu konzumního kmínového v letech 2006 a 2018\. Zároveň jsem vybrala informace o mzdach ve stejnych letech a jednoduchou kalkulací zjistila, že s průměrnou mzdou v roce 2006 mohl člověk nakoupit buďto 1287 kilo chleba za cenu 16,12Kč za kilo, nebo 1437 litrů mléka za 14,44Kč za litr. V roce 2018 by chleba mohl člověk koupí až 1342 kilo při ceně 24.24Kč za kilo a  1642 litrů mléka při ceně 19.82Kč za litr . 

Průměrná mzda v roce 2006 by pak byla 20753.79Kč a v roce 2018 32535.86Kč.

**Otazka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Nejnižší průměrný procentuální růst sledujeme u banánů žlutých, kde cena průměrně roste o pouhých 0,81%. Ovšem můžeme najít také dva druhý potravin, kde cena dokonce průměrně klesá. jedná se o cukr krystalový, kde cena klesla o 1,92% a rajská jablka červená kulatá s poklesem 0,74%. 

Největší pokles ceny mezi jednotlivými roky sledujeme v roce 2007 pro rajská jablka červená kulatá, kde od roku 2006 cena klesla o neuvěřitelných 30,28%. Nejnižší sledovaný nárůst hodnoty je ovšem z roku 2009, kde od roku 2008 vzrostla cena rostlinného roztíratelného tuku o pouhých 0,01%.

Pro zjištění této odpovědi byly využity dva selecty \- první pro zjištění skutečného růstu, nebo poklesu, ceny napříč jednotlivými roky i potravinovými druhy oproti předešlému roku. Vidime zde i procentuální vyjádření změny oproti předchozímu roku. Druhý select poté ukáže průměrný růst či pokles napříč celým sledovaným obdobím, kde byl také využít limit, tak abychom videli pouze tři nejnižší hodnoty, odpovídající udajum potřebným pro zodpovězení otázky.  
**Otazka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

S jistotou můžeme říct, že takový scénář nenastal. V roce 2013 sledujeme procentuální nárůst cen ve výši 5,1% v porovnání s poklesem mezd 1,56% oproti předešlému roku. To se rovná celkovému rozdílu 6,66%, což je ovšem největší zaznamenaný rozdíl ve sledovaném období pro růst cen. 

Pro zodpovězení otázky byly vytvořeny dvě views: první pro získání dat o průměrné mzdě mezi všemi odvětvími a cenách všech kategorií potravin napříč jednotlivými roky, a druhou pro (především procentuální) srovnání růstu mezd i cen oproti poslednímu roku pro což využiji dřívější view.  Vše je vždy zaokrouhlování na 2 desetinná místa. V neposlední řadě selectem vytáhnu z druhého view data o procentuálním růstu cen i mezd napříč léty a srovnám jejich rozdíl.

**Otazka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Z tabulky lze usoudit, že růst/pokles HDP vždy nutně neovlivňuje výši cen a mezd v České republice. Například v roce 2009 sledujeme pokles HDP o 4,66% oproti roku 2008, přesto ceny potravin v dalších dvou letech rostly. Mzdy přitom v roce poté klesly pouze o 1,95%.

Z opačného konce, v roce 2015 sledujeme nárust HDP z roku 2014 o 5,39%, ovšem následující rok cena potravin klesla a teprve v roce 2017 sledujeme růst ceny potravin o 9,63%, zatímco mzdy alespoň mírně rostly napříč téměř celým sledovaným obdobím. 

Bylo vytvořeno view pro sledování HDP pouze České republiky, kde jsme zároveň sledovali jeho nárůst či pokles oproti předešlému roku. View také ukazuje procentuální rozdíl oproti předešlému roku.  Selectem poté vyberu data o procentuálních rozdílech cen a mezd z view vytvořeného v rámci otázky číslo 4 a zároveň vyberu data z nově vytvořeného view pro data o HDP. Díky tomu jsem schopna vidět procentuální posun oproti předešlému roku pro výši mezd, cen i HDP. 