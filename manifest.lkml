project_name: "customer_trial"

new_lookml_runtime: no

constant: mock_string {
  value: "wip"
}

constant: mock_boolean {
  value: "False"
}

constant: mock_date {
  value: "1970-01-01"
}

constant: dynamic_currency_formatting_us {
  value: "{% assign abs_value = value | abs %}
  {% if abs_value >= 1000 and abs_value < 1000000 %}
  ${{value | divided_by: 1000 | round: 2 }}K
  {% elsif abs_value >= 1000000 and abs_value <  1000000000 %}
  ${{value | divided_by: 1000000 | round: 2 }}M
  {% elsif abs_value >= 1000000000 %}
  ${{value | divided_by: 1000000000 | round: 2 }}B
  {% else %}
  ${{value | round: 2 }}
{% endif %}"}

constant: proper_case_snakecase {
  value: "{% assign words = value | split: '_' %}
  {% for word in words %}
  {% assign down_word = word | downcase %}
  {% if down_word == 'gcs' %}
  {{word | upcase}}
  {% elsif down_word == 'ssn' %}
  {{word | upcase}}
  {% elsif down_word contains 'https' %}
  {{word | downcase }}
  {% elsif down_word contains '@' %}
  {{word | downcase }}
  {% elsif down_word == 'n/a' %}
  {{word | upcase }}
  {%else %}
  {{ word | capitalize }}
  {% endif %}
  {% endfor %}"
}

constant: sdpy_sql {
  value: "
select
case when extract(day from (last_day(date((extract(year from current_date)),
      2, 1)))) = 29
      then date_add(date((extract(year from current_date) - 1),
      extract(month from current_date),
      extract(day from current_date)), interval 2 day)
else
date_add(date((extract(year from current_date) - 1),
      extract(month from current_date),
      extract(day from current_date)), interval 1 day)
end"
}

constant: yesterday_sql {
  value: "date_add(current_date, interval -1 day)"
}

constant: yesterday_prior_year {
  value: "date(extract(year from @{yesterday_sql}) - 1, extract(month from @{yesterday_sql}), extract(day from @{yesterday_sql}))"
}

constant: yesterday_same_day_prior_year {
  value:  "case
          when extract(day from (last_day(date(extract(year from
                                                        @{yesterday_sql}),
                                                        2, 1)))) = 29
          then date_add(date(extract(year from @{yesterday_sql}) - 1,
                              extract(month from @{yesterday_sql}),
                              extract(day from @{yesterday_sql})), interval 2 day)
          else
                date_add(date(extract(year from @{yesterday_sql}) - 1,
                                extract(month from @{yesterday_sql}),
                                extract(day from @{yesterday_sql})), interval 1 day)
          end"
}

constant: preceding_day_sql {
  value: "date_add(current_date, interval -2 day)"
}

constant: beginning_of_last_7_days {
  value: "date_add(current_date, interval -7 day)"
}

constant: beginning_of_last_7_days_prior_year {
  value: "date(extract(year from @{beginning_of_last_7_days}) - 1, extract(month from @{beginning_of_last_7_days}), extract(day from @{beginning_of_last_7_days}))"
}

constant: beginning_of_last_7_days_same_day_prior_year {
  value:  "case
          when extract(day from (last_day(date(extract(year from
                                                        @{beginning_of_last_7_days}),
                                                        2, 1)))) = 29
          then date_add(date(extract(year from @{beginning_of_last_7_days}) - 1,
                              extract(month from @{beginning_of_last_7_days}),
                              extract(day from @{beginning_of_last_7_days})), interval 2 day)
          else
                date_add(date(extract(year from @{beginning_of_last_7_days}) - 1,
                                extract(month from @{beginning_of_last_7_days}),
                                extract(day from @{beginning_of_last_7_days})), interval 1 day)
          end"
}

constant: end_of_last_week {
  value: "date_add(current_date, interval -1 day)"
}

constant: beginning_of_last_30_days {
  value: "date_add(current_date, interval -30 day)"
}

constant: beginning_of_last_30_days_prior_year {
  value: "date(extract(year from @{beginning_of_last_30_days}) - 1, extract(month from @{beginning_of_last_30_days}), extract(day from @{beginning_of_last_30_days}))"
}

constant: beginning_of_last_30_days_same_day_prior_year {
  value:  "case
          when extract(day from (last_day(date(extract(year from
                                                        @{beginning_of_last_30_days}),
                                                        2, 1)))) = 29
          then date_add(date(extract(year from @{beginning_of_last_30_days}) - 1,
                              extract(month from @{beginning_of_last_30_days}),
                              extract(day from @{beginning_of_last_30_days})), interval 2 day)
          else
                date_add(date(extract(year from @{beginning_of_last_30_days}) - 1,
                                extract(month from @{beginning_of_last_30_days}),
                                extract(day from @{beginning_of_last_30_days})), interval 1 day)
          end"
}

constant: beginning_of_last_90_days {
  value: "date_add(current_date, interval -90 day)"
}

constant: beginning_of_last_90_days_prior_year {
  value: "date(extract(year from @{beginning_of_last_90_days}) - 1, extract(month from @{beginning_of_last_90_days}), extract(day from @{beginning_of_last_90_days}))"
}

constant: beginning_of_last_90_days_same_day_prior_year {
  value:  "case
          when extract(day from (last_day(date(extract(year from
                                                        @{beginning_of_last_90_days}),
                                                        2, 1)))) = 29
          then date_add(date(extract(year from @{beginning_of_last_90_days}) - 1,
                              extract(month from @{beginning_of_last_90_days}),
                              extract(day from @{beginning_of_last_90_days})), interval 2 day)
          else
                date_add(date(extract(year from @{beginning_of_last_90_days}) - 1,
                                extract(month from @{beginning_of_last_90_days}),
                                extract(day from @{beginning_of_last_90_days})), interval 1 day)
          end"
}

constant: beginning_of_last_365_days {
  value: "date_add(current_date, interval -365 day)"
}

constant: beginning_of_last_365_days_prior_year {
  value: "date(extract(year from @{beginning_of_last_365_days}) - 1, extract(month from @{beginning_of_last_365_days}), extract(day from @{beginning_of_last_365_days}))"
}

constant: beginning_of_last_365_days_same_day_prior_year {
  value:  "case
          when extract(day from (last_day(date(extract(year from
                                                        @{beginning_of_last_365_days}),
                                                        2, 1)))) = 29
          then date_add(date(extract(year from @{beginning_of_last_365_days}) - 1,
                              extract(month from @{beginning_of_last_365_days}),
                              extract(day from @{beginning_of_last_365_days})), interval 2 day)
          else
                date_add(date(extract(year from @{beginning_of_last_365_days}) - 1,
                                extract(month from @{beginning_of_last_365_days}),
                                extract(day from @{beginning_of_last_365_days})), interval 1 day)
          end"
}

constant: beginning_of_last_month {
  value: "date(extract(year from (current_date())),
  extract(month from current_date()) - 1, 1)
"
}

constant: end_of_last_month {
  value: "last_day(date_add(current_date(), interval -1 month))"
}

constant: beginning_of_last_year {
  value: "date(extract(year from (current_date())), 1, 1)"
}

constant: beginning_of_last_year_prior_year {
  value: "date(extract(year from @{beginning_of_last_year}) - 1, 1, 1)"
}

constant: end_of_last_year {
  value: "date(extract(year from (current_date())) - 1, 12, 31)
  "
  }
constant: mock_integer {
  value: "0"
}

constant: customer_origin_first_order {
  value: "Customer Origin First Order"
}
