{{
    config(
        materialized = 'table',
    )
}}

with date_spine as (
  {{ dbt_utils.date_spine(
      datepart = "day",
      start_date = "'2000-01-01'::date",
      end_date = "(date_trunc('month', current_date)::date + interval 6 month)::date"
    )
  }}
),

final as (
    select
      date_day::date as calendar_date,
      date_part('year', calendar_date) as calendar_year,
      date_part('month', calendar_date) as calendar_month,
      date_part('day', calendar_date) as calendar_day_of_month,
      date_day::date as fiscal_date,
      calendar_date::timestamp as calendar_date_start_at_utc,
      
      -- Replaced dateadd for end_at_utc
      ((calendar_date::timestamp + interval 1 day) - interval 1 microsecond)::timestamp as calendar_date_end_at_utc,
      
      case 
        when date_part('dayofweek', calendar_date) = 0 then 'Sunday'
        when date_part('dayofweek', calendar_date) = 1 then 'Monday'
        when date_part('dayofweek', calendar_date) = 2 then 'Tuesday'
        when date_part('dayofweek', calendar_date) = 3 then 'Wednesday'
        when date_part('dayofweek', calendar_date) = 4 then 'Thursday'
        when date_part('dayofweek', calendar_date) = 5 then 'Friday'
        when date_part('dayofweek', calendar_date) = 6 then 'Saturday'
      end as day_of_week_name,

      case when coalesce(day_of_week_name, '') not in ('Sunday', 'Saturday') then true else false end as is_weekday,

      date_part('dayofweek', calendar_date) = 0 as is_start_of_calendar_week,
      date_part('dayofweek', calendar_date) = 6 as is_end_of_calendar_week,
      date_part('day', calendar_date) = 1 as is_start_of_calendar_month,
      date_day = last_day(calendar_date) as is_end_of_calendar_month,
      date_day = date_trunc('quarter', calendar_date)::date as is_start_of_calendar_quarter,
      date_day = (date_trunc('quarter', calendar_date)::date + interval 1 quarter - interval 1 day)::date as is_end_of_calendar_quarter,
      date_day = date_trunc('year', calendar_date)::date as is_start_of_calendar_year,
      date_day = (date_trunc('year', calendar_date)::date + interval 1 year - interval 1 day)::date as is_end_of_calendar_year

    from date_spine
)

select * from final
