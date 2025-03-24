
-- 問1
-- 国名を全て抽出してください。
select name from countries;

-- 問2
-- ヨーロッパに属する国をすべて抽出してください。
select * from countries where continent = 'Europe';

-- 問3
-- ヨーロッパ以外に属する国をすべて抽出してください。
select * from countries where continent != 'Europe';

-- 問4
-- 人口が10万人以上の国をすべて抽出してください。
select * from countries where population > 100000;

-- 問5
-- 平均寿命が56歳から76歳の国をすべて抽出してください。
select * from countries where 56 <= life_expectancy and life_expectancy <= 76;

-- 問6
-- 国コードがNLB,ALB,DZAのもの市区町村をすべて抽出してください。
select * from cities where country_code in ('NLB','ALB','DZA');

-- 問7
-- 独立独立記念日がない国をすべて抽出してください。
select * from countries where indep_year is null;

-- 問8
-- 独立独立記念日がある国をすべて抽出してください。
select * from countries where indep_year is not null;

-- 問9
-- 名前の末尾が「ia」で終わる国を抽出してください。
select * from countries where rtrim(name) ilike '%ia';

-- 問10
-- 名前の中に「st」が含まれる国を抽出してください。
select * from countries where name ilike '%st%';

-- 問11
-- 名前が「an」で始まる国を抽出してください。
select * from countries where name ilike 'an%';

-- 問12
-- 全国の中から独立記念日が1990年より前または人口が10万人より多い国を全て抽出してください。
select * from countries where indep_year < 1990 or population > 100000;

-- 問13
-- コードがDZAもしくはALBかつ独立記念日が1990年より前の国を全て抽出してください。
select * from countries where code in ('DZA', 'ALB') and indep_year < 1990;

-- 問14
-- 全ての地方をグループ化せずに表示してください。
select region from countries;

-- 問15
-- 国名と人口を以下のように表示させてください。シングルクォートに注意してください。
-- 「Arubaの人口は103000人です」
select concat(name, 'の人口は', population, '人です') population_message from countries;

-- 問16
-- 平均寿命が短い順に国名を表示させてください。ただしNULLは表示させないでください。
select * from countries where life_expectancy is not null order by life_expectancy;

-- 問17
-- 平均寿命が長い順に国名を表示させてください。ただしNULLは表示させないでください。
select * from countries where life_expectancy is not null order by life_expectancy desc;

-- 問18
-- 平均寿命が長い順、独立記念日が新しい順に国を表示させてください。
select * from countries order by life_expectancy desc, indep_year desc;

-- 問19
-- 全ての国の国コードの一文字目と国名を表示させてください。
select substring(code, 1, 1) first_letter_of_code, name country_name from countries;

-- 問20
-- 国名が長いものから順に国名と国名の長さを出力してください。
select name, length(name) name_length from countries order by length(name) desc;

-- 問21
-- 全ての地方の平均寿命、平均人口を表示してください。(NULLも表示)
select region, avg(life_expectancy) avg_life, avg(population) avg_population from countries group by region order by region;

-- 問22
-- 全ての地方の最長寿命、最大人口を表示してください。(NULLも表示)
select region, max(life_expectancy) max_life, max(population) max_population from countries group by region order by region;

-- 問23
-- アジア大陸の中で最小の表面積を表示してください
select min(surface_area) min_surface from countries where continent = 'Asia';

-- 問24
-- アジア大陸の表面積の合計を表示してください。
select sum(surface_area) sum_surface from countries where continent = 'Asia';

-- 問25
-- 全ての国と言語を表示してください。一つの国に複数言語があると思いますので同じ国名を言語数だけ出力してください。
select c1.name country_name, c2.language from countries c1 join country_languages c2 on c1.code = c2.country_code;

-- 問26
-- 全ての国と言語と市区町村を表示してください。
select
  c1.name country_name
 ,c3.name city_name
 ,c2.language
from
  countries c1
  join
    country_languages c2
    on c1.code = c2.country_code
  join
    cities c3
    on c1.code = c3.country_code
;

-- 問27
-- 全ての有名人を出力してください。左側外部結合を使用して国名なし（country_codeがNULL）も表示してください。
select c1.name, c2.name from celebrities c1 left join countries c2 on c1.country_code = c2.code;

-- 問28
-- 全ての有名人の名前,国名、第一言語を出力してください。
select
  c1.name celebrity_name
 ,c2.name country_name
 ,(select
     language
   from
     country_languages
   where
     country_code = c1.country_code
   order by
     percentage desc
   limit 1)
from
  celebrities c1
left join
  countries c2
  on c1.country_code = c2.code
;

-- 問29
-- 全ての有名人の名前と国名をに出力してください。 ただしテーブル結合せずサブクエリを使用してください。
select name celeb_name, (select name from countries where code = c1.country_code) country_name from celebrities c1;

-- 問30
-- 最年長が50歳以上かつ最年少が30歳以下の国を表示させてください。
select
  c1.country_code
 ,(select name from countries where code = c1.country_code)
 ,max(c1.age) max_age
 ,min(c1.age) min_age
from
  celebrities c1
where
  trim(c1.country_code) != ''
group by
  c1.country_code
having
      max(c1.age) >= 50
  and min(c1.age) <= 30
;

-- 問31
-- 1991年生まれと、1981年生まれの有名人が何人いるか調べてください。ただし、日付関数は使用せず、UNION句を使用してください。
select '1991' birth_year, count(*) from celebrities where '1991-01-01 00:00:00' <= birth and birth < '1992-01-01 00:00:00'
union
select '1981' birth_year, count(*) from celebrities where '1981-01-01 00:00:00' <= birth and birth < '1982-01-01 00:00:00'
;

-- 問32
-- 有名人の出身国の平均年齢を高い方から順に表示してください。ただし、FROM句はcountriesテーブルとしてください。
select
  c1.name country_name
 ,c2.avg_age
from
  countries c1
inner join
  (select country_code, avg(age) avg_age from celebrities group by country_code) c2
  on c1.code = c2.country_code
order by
  c2.avg_age desc
;