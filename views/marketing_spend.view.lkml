#### DESCRIPTION --------------------------------------------------------------------------------------------------------------------

# This view pulls data from the customer marketing spend data mart. Some of these fields are hidden, as they are integral to building out
# the Daily Flash logic for the time frame binning.

view: marketing_spend {
  sql_table_name: `customer.customer_bi_datamart_marketing_spend.marketing_spend`
    ;;

#### SETS --------------------------------------------------------------------------------------------------------------------

  set: detail {
    fields: [date_date, country, platform_name, channel_group, media_spend]
  }

#### DIMENSIONS --------------------------------------------------------------------------------------------------------------------

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${platform_name},${country},${channel_group}, ${date_date}) ;;
  }

  dimension: country {
    description: "Country in which the media was spent, where available"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: platform_name {
    description: "Platform Name associated with the spend"
    type: string
    sql: ${TABLE}.platform_name ;;
  }

  dimension: channel_group {
    description: "Broader Channel Group that Platform Names roll-up into"
    type: string
    sql: ${TABLE}.channel_group ;;
  }

  dimension: media_spend {
    hidden: yes
    type: number
    sql: ${TABLE}.media_spend ;;
    value_format_name: usd
  }

  ## Beginning of daily flash date binning dimensions

  dimension: yesterday_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${date_date} = @{yesterday_same_day_prior_year}
          then true
          else false
          end;;
    group_label: "Daily Flash Time Binning"
  }

  dimension: last_7_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${date_date} between @{beginning_of_last_7_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
          then true
          else false
          end;;
    group_label: "Daily Flash Time Binning"
  }

  dimension: last_30_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${date_date} between @{beginning_of_last_30_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
          then true
          else false
          end;;
    group_label: "Daily Flash Time Binning"
  }

  dimension: last_365_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${date_date} between @{beginning_of_last_365_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
          then true
          else false
          end;;
    group_label: "Daily Flash Time Binning"
  }

  ## End of daily flash date binning dimensions

#### DIMENSION GROUPS --------------------------------------------------------------------------------------------------------------------

  dimension_group: last_synced {
    description: "This field gives the last synced metadata for the marketing spend data mart.
    This is used in the last_synced explore to provide last synced metadata for all datamarts throughout Pandera-developed dashboards"
    hidden: yes
    type: time
    timeframes: [
      raw,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dag_ts_utc;;
  }

  dimension_group: date {
    label: "Spend"
    type: time
    description: "Calendar date in which the media dollars were spent / recorded"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

#### MEASURES --------------------------------------------------------------------------------------------------------------------

  measure: total_media_spend {
    type: sum
    description: "Total Media Spend"
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_running_total {
    hidden: yes
    type: running_total
    description: "Total Media Spend Running Total"
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: cpa {
    label: "CPA"
    type: number
    sql: ${total_media_spend}/nullif(${order.distinct_new_customer_count},0) ;;
    drill_fields: [detail*]
    value_format_name: usd_0
  }

  ## Beginning of daily flash media spend binning dimensions

  measure: total_media_spend_yesterday_py {
    description: "Total Media Spend for the same day of the week as yesterday in the preceding year."
    hidden: yes
    type: sum
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    group_label: "Daily Flash Media Spend Binning"
    filters: [yesterday_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_last_7_days_py {
    description: "Total Media Spend for the same days of the week as the last 7 days in the preceding year."
    hidden: yes
    type: sum
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    group_label: "Daily Flash Media Spend Binning"
    filters: [last_7_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_last_30_days_py {
    description: "Total Media Spend for the same days as the last 30 days in the preceding year."
    hidden: yes
    type: sum
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    group_label: "Daily Flash Media Spend Binning"
    filters: [last_30_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_last_365_days_py {
    description: "Total Media Spend for the same days as the last 365 days in the preceding year."
    hidden: yes
    type: sum
    sql: ${media_spend} ;;
    drill_fields: [detail*]
    group_label: "Daily Flash Media Spend Binning"
    filters: [last_365_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  ## End of daily flash media spend binning dimensions

  ## Beginning of CPA binning dimensions

  measure: cpa_yesterday_py {
    label: "CPA Yesterday PY"
    hidden: yes
    type: number
    sql: ${total_media_spend_yesterday_py}/nullif(${order.distinct_new_customer_count_yesterday_py},0) ;;
    drill_fields: [detail*]
    group_label: "Daily Flash CPA Binning"
    value_format_name: usd_0
  }

  measure: cpa_last_7_days_py {
    label: "CPA Last 7 Days PY"
    hidden: yes
    type: number
    sql: ${total_media_spend_last_7_days_py}/nullif(${order.distinct_new_customer_count_last_7_days_py},0) ;;
    drill_fields: [detail*]
    group_label: "Daily Flash CPA Binning"
    value_format_name: usd_0
  }

  measure: cpa_last_30_days_py {
    label: "CPA Last 30 Days PY"
    hidden: yes
    type: number
    sql: ${total_media_spend_last_30_days_py}/nullif(${order.distinct_new_customer_count_last_30_days_py},0) ;;
    drill_fields: [detail*]
    group_label: "Daily Flash CPA Binning"
    value_format_name: usd_0
  }

  measure: cpa_last_365_days_py {
    label: "CPA Last 365 Days PY"
    hidden: yes
    type: number
    sql: ${total_media_spend_last_365_days_py}/nullif(${order.distinct_new_customer_count_last_365_days_py},0) ;;
    drill_fields: [detail*]
    group_label: "Daily Flash CPA Binning"
    value_format_name: usd_0
  }

  ## End of daily flash CPA binning dimensions

}
