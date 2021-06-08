/* Data Virtuality exported objects */
/* Created: 08.06.21  14:24:03.414 */
/* Server version: 2.4.6 */
/* Build: ce8ff20 */
/* Build date: 2021-05-28 */
/* Exported by Studio ver.2.4.6 (rev.cb1b700). Build date is 2021-05-28. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'master_class_2021_reporting') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Partition_Data as
select  1 as id, ''A'' as partition_name,   3 as val, 2019 as yr,  1 as mnth union all
select  2 as id, ''A'' as partition_name,   4 as val, 2019 as yr,  2 as mnth union all
select  3 as id, ''A'' as partition_name,   5 as val, 2019 as yr,  3 as mnth union all
select  4 as id, ''A'' as partition_name,   6 as val, 2019 as yr,  4 as mnth union all
select  5 as id, ''A'' as partition_name,   7 as val, 2019 as yr,  5 as mnth union all
select  6 as id, ''A'' as partition_name,   8 as val, 2019 as yr,  6 as mnth union all
select  7 as id, ''A'' as partition_name,   9 as val, 2019 as yr,  7 as mnth union all
select  8 as id, ''A'' as partition_name,  10 as val, 2019 as yr,  8 as mnth union all
select  9 as id, ''A'' as partition_name,  11 as val, 2019 as yr,  9 as mnth union all
select 10 as id, ''A'' as partition_name,  12 as val, 2019 as yr, 10 as mnth union all
select 11 as id, ''A'' as partition_name,  13 as val, 2019 as yr, 11 as mnth union all
select 12 as id, ''A'' as partition_name,  14 as val, 2019 as yr, 12 as mnth union all
select 13 as id, ''B'' as partition_name,  44 as val, 2020 as yr,  1 as mnth union all
select 14 as id, ''B'' as partition_name,  45 as val, 2020 as yr,  2 as mnth union all
select 15 as id, ''B'' as partition_name,  46 as val, 2020 as yr,  3 as mnth union all
select 16 as id, ''B'' as partition_name,  47 as val, 2020 as yr,  4 as mnth union all
select 17 as id, ''B'' as partition_name,  48 as val, 2020 as yr,  5 as mnth union all
select 18 as id, ''B'' as partition_name,  49 as val, 2020 as yr,  6 as mnth union all
select 19 as id, ''B'' as partition_name,  50 as val, 2020 as yr,  7 as mnth union all
select 20 as id, ''B'' as partition_name,  51 as val, 2020 as yr,  8 as mnth union all
select 21 as id, ''B'' as partition_name,  52 as val, 2020 as yr,  9 as mnth union all
select 22 as id, ''B'' as partition_name,  53 as val, 2020 as yr, 10 as mnth union all
select 23 as id, ''B'' as partition_name,  54 as val, 2020 as yr, 11 as mnth union all
select 24 as id, ''B'' as partition_name,  55 as val, 2020 as yr, 12 as mnth union all
select 25 as id, ''C'' as partition_name, 200 as val, 2021 as yr,  1 as mnth union all
select 26 as id, ''C'' as partition_name, 201 as val, 2021 as yr,  2 as mnth union all
select 27 as id, ''C'' as partition_name, 202 as val, 2021 as yr,  3 as mnth union all
select 28 as id, ''C'' as partition_name, 203 as val, 2021 as yr,  4 as mnth union all
select 29 as id, ''C'' as partition_name, 204 as val, 2021 as yr,  5 as mnth union all
select 30 as id, ''C'' as partition_name, 205 as val, 2021 as yr,  6 as mnth union all
select 31 as id, ''C'' as partition_name, 206 as val, 2021 as yr,  7 as mnth union all
select 32 as id, ''C'' as partition_name, 207 as val, 2021 as yr,  8 as mnth union all
select 33 as id, ''C'' as partition_name, 208 as val, 2021 as yr,  9 as mnth union all
select 34 as id, ''C'' as partition_name, 209 as val, 2021 as yr, 10 as mnth union all
select 35 as id, ''C'' as partition_name, 210 as val, 2021 as yr, 11 as mnth union all
select 36 as id, ''C'' as partition_name, 211 as val, 2021 as yr, 12 as mnth') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Window01 as
SELECT 
	"partition_name", 
	sum("val") as val
FROM 
	"master_class_2021_reporting.Partition_Data"
group by
	"partition_name"') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_reporting.Window02 as
SELECT
	Id,
	"partition_name", 
	"val",
	sum("val") over(partition by "partition_name") as sum_of_partition,
	-- equivalent to next line
	--sum("val") over(partition by "partition_name" order by id rows unbounded preceding) as sum_of_preceding,
	sum("val") over(partition by "partition_name" order by id rows between unbounded preceding and current row) as sum_of_preceding,
	sum("val") over(partition by "partition_name" order by id rows between current row and unbounded following) as sum_of_following,
	sum("val") over(partition by "partition_name" order by id rows between unbounded preceding and 1 preceding) as sum_of_preceding_excluding_curr_row,
	sum("val") over(partition by "partition_name" order by id rows between 1 following and unbounded following) as sum_of_following_excluding_curr_row
FROM 
	"master_class_2021_reporting.Partition_Data"
order by id') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Window03 as
SELECT
    Id,
    "partition_name", 
    "val",
    count(*) over(partition by "partition_name" order by id rows between unbounded preceding and current row) as cnt_preceding,
    count(*) over(partition by "partition_name" order by id rows between unbounded preceding and current row) as cnt_preceding,
    count(*) over(partition by "partition_name" order by id rows between current row and unbounded following) as cnt_following,
    count(*) over(partition by "partition_name" order by id rows between unbounded preceding and 1 preceding) as cnt_preceding_excluding_curr_row,
    count(*) over(partition by "partition_name" order by id rows between 1 preceding and unbounded following) as cnt_following_excluding_curr_row
FROM 
    "master_class_2021_reporting.Partition_Data"
order by id') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Window04 as
SELECT
    Id,
    "partition_name", 
    "val",
    lag(Id, 1, -5555)  over(partition by "partition_name" order by id) as lg1,
    lag(Id, 2, -6666)  over(partition by "partition_name" order by id) as lg2,
    lead(Id, 1)  over(partition by "partition_name" order by id) as ld1,
    lead(Id, 2)  over(partition by "partition_name" order by id) as ld2
FROM 
    "master_class_2021_reporting.Partition_Data"
order by id') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Window05 as
SELECT
    Id,
    "partition_name", 
    "val",
    first_value(val)  over(partition by "partition_name" order by id) as f1,
    first_value(val)  over(partition by "partition_name" order by id 
        rows between 1 preceding AND UNBOUNDED FOLLOWING) as f2,
    first_value(val)  over(partition by "partition_name" order by id 
        rows between CURRENT ROW AND UNBOUNDED FOLLOWING) as f3,
    first_value(val)  over(partition by "partition_name" order by id 
        rows between 1 following AND UNBOUNDED FOLLOWING) as f4,
    last_value(val)  over(partition by "partition_name" order by id) as l1,
    last_value(val)  over(partition by "partition_name" order by id 
        rows between unbounded preceding AND 1 preceding) as l2,
    last_value(val)  over(partition by "partition_name" order by id 
        rows between unbounded preceding AND current row) as l3,
    last_value(val)  over(partition by "partition_name" order by id
        rows between unbounded preceding AND 1 FOLLOWING) as l4
FROM 
    "master_class_2021_reporting.Partition_Data"
order by id') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_reporting.Window06 as
with cte as (
SELECT
    yr, mnth,
    val,
    sum(val)  over(partition by yr order by yr, mnth) as ytd,
    sum(val)  over(order by yr, mnth rows between 11 preceding and current row) as sum_rolling_12_months,
    avg(val)  over(order by yr, mnth rows between 11 preceding and current row) as avg_rolling_12_months,
    avg(val)  over(order by yr, mnth rows between 2 preceding and current row) as avg_rolling_3_months,
    lag(val, 12) over(order by yr, mnth) as lag_12_months_ago,
    lag(val, 3) over(order by yr, mnth) as lag_3_months_ago,
    case
        when (lag(val, 12) over(order by yr, mnth)) is null then cast(null as float)
        else cast(100.0 as float) * (val - (lag(val, 12) over(order by yr, mnth))) 
            / (lag(val, 12) over(order by yr, mnth))
    end as YoY,
    case
        when (lag(val, 1) over(order by yr, mnth)) is null then cast(null as float)
        else cast(100.0 as float) * (val - (lag(val, 1) over(order by yr, mnth))) 
            / (lag(val, 1) over(order by yr, mnth))
    end as MoM,
    first_value(val)  over(order by yr, mnth
        rows between 12 preceding AND current row) as first_rolling_12_months,
    first_value(val)  over(order by yr, mnth
        rows between 3 preceding AND current row) as first_rolling_3_months
FROM 
    "master_class_2021_reporting.Partition_Data"
)
select
    cte.*,
    cast(val - ifnull(lag_12_months_ago, first_rolling_12_months) as float) / 12.0 as slope_rolling_12_mo,
    cast(val - ifnull(lag_3_months_ago, first_rolling_3_months) as float) / 3.0 as slope_rolling_3_mo
from
    cte
order by yr, mnth') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_reporting.pivot_01 as
with cte as (
	SELECT yr, mnth, sum(val) as sum_val
	FROM "master_class_2021_reporting.Partition_Data"
	group by yr, mnth
	order by yr, mnth
), cte2 as (
select
    yr
    ,array_agg (sum_val order by yr, mnth) as arr_sum_val
from
    cte
group by
    yr
)
select
    yr
    ,array_get(arr_sum_val, 1) as "mo1"
    ,array_get(arr_sum_val, 2) as "mo2"
    ,array_get(arr_sum_val, 3) as "mo3"
    ,array_get(arr_sum_val, 4) as "mo4"
    ,array_get(arr_sum_val, 5) as "mo5"
    ,array_get(arr_sum_val, 6) as "mo6"
    ,array_get(arr_sum_val, 7) as "mo7"
    ,array_get(arr_sum_val, 8) as "mo8"
    ,array_get(arr_sum_val, 9) as "mo9"
    ,array_get(arr_sum_val, 10) as "mo10"
    ,array_get(arr_sum_val, 11) as "mo11"
    ,array_get(arr_sum_val, 12) as "mo12"
from
	cte2') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_reporting.pivot_02 as
with cte as (
    SELECT yr, mnth, sum(val) as sum_val
    FROM "master_class_2021_reporting.Partition_Data"
    group by yr, mnth
    order by yr, mnth
)
SELECT
    p.yr,
    mo1.sum_val as mo1,
    mo2.sum_val as mo2,
    mo3.sum_val as mo3,
    mo4.sum_val as mo4,
    mo5.sum_val as mo5,
    mo6.sum_val as mo6,
    mo7.sum_val as mo7,
    mo8.sum_val as mo8,
    mo9.sum_val as mo9,
    mo10.sum_val as mo10,
    mo11.sum_val as mo11,
    mo12.sum_val as mo12
FROM 
    (SELECT yr FROM "master_class_2021_reporting.Partition_Data" group by yr) p
    join cte mo1 on p.yr = mo1.yr and mo1.mnth = 1
    join cte mo2 on p.yr = mo2.yr and mo2.mnth = 2
    join cte mo3 on p.yr = mo3.yr and mo3.mnth = 3
    join cte mo4 on p.yr = mo4.yr and mo4.mnth = 4
    join cte mo5 on p.yr = mo5.yr and mo5.mnth = 5
    join cte mo6 on p.yr = mo6.yr and mo6.mnth = 6
    join cte mo7 on p.yr = mo7.yr and mo7.mnth = 7
    join cte mo8 on p.yr = mo8.yr and mo8.mnth = 8
    join cte mo9 on p.yr = mo9.yr and mo9.mnth = 9
    join cte mo10 on p.yr = mo10.yr and mo10.mnth = 10
    join cte mo11 on p.yr = mo11.yr and mo11.mnth = 11
    join cte mo12 on p.yr = mo12.yr and mo12.mnth = 12') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_reporting.unpivot as
SELECT 
	yr, mnth, val
FROM 
	(
		SELECT yr, mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11, mo12 
		FROM master_class_2021_reporting.pivot_01
	) p 
	UNPIVOT (
		val FOR mnth IN (mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11, mo12)
	) AS unpvt') ;;








