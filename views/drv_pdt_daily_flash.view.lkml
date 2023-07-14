view: drv_pdt_daily_flash {

  #####################################################################################
  # This PDT support the Daily Flash Table visualization on the Daily Flash Dashboard.
  #####################################################################################

  derived_table: {
    datagroup_trigger: datagroup_orders
    explore_source: marketing_spend_and_orders {
      column: daily_flash_times { field: order.daily_flash_times }
      column: flash_rank { field: order.flash_rank }
      column: total_net_sales_USD { field: order.total_net_sales_USD }
      column: total_number_orders_daily_flash { field: order.total_number_orders_daily_flash }
      column: total_net_sales_USD_running_total { field: order.total_net_sales_USD_running_total }
      column: total_number_orders_running_total { field: order.total_number_orders_running_total }
      column: distinct_new_customer_count_daily_flash { field: order.distinct_new_customer_count_daily_flash }
      column: distinct_customer_count_running_total { field: order.distinct_customer_count_running_total }
      column: total_media_spend { field: marketing_spend.total_media_spend }
      column: total_net_sales_USD_yesterday_py { field: order.total_net_sales_USD_yesterday_py }
      column: total_net_sales_USD_last_7_days_py { field: order.total_net_sales_USD_last_7_days_py }
      column: total_net_sales_USD_last_30_days_py { field: order.total_net_sales_USD_last_30_days_py }
      column: total_net_sales_USD_last_365_days_py { field: order.total_net_sales_USD_last_365_days_py }
      column: total_number_orders_yesterday_py { field: order.total_number_orders_yesterday_py }
      column: total_number_orders_last_7_days_py { field: order.total_number_orders_last_7_days_py }
      column: total_number_orders_last_30_days_py { field: order.total_number_orders_last_30_days_py }
      column: total_number_orders_last_365_days_py { field: order.total_number_orders_last_365_days_py }
      column: distinct_new_customer_count_yesterday_py { field: order.distinct_new_customer_count_yesterday_py }
      column: distinct_new_customer_count_last_7_days_py { field: order.distinct_new_customer_count_last_7_days_py }
      column: distinct_new_customer_count_last_30_days_py { field: order.distinct_new_customer_count_last_30_days_py }
      column: distinct_new_customer_count_last_365_days_py { field: order.distinct_new_customer_count_last_365_days_py }
      column: order_shipping_country { field: order.order_shipping_country }
      column: total_media_spend_yesterday_py { field: marketing_spend.total_media_spend_yesterday_py }
      column: total_media_spend_last_7_days_py { field: marketing_spend.total_media_spend_last_7_days_py }
      column: total_media_spend_last_365_days_py { field: marketing_spend.total_media_spend_last_365_days_py }
      column: total_media_spend_last_30_days_py { field: marketing_spend.total_media_spend_last_30_days_py }
      filters: {
        field: order.order_shipping_country
        value: "-NULL"
      }
      filters: {
        field: order.order_date_at_tz_ny_date
        value: "750 days"
      }
    }
  }
  dimension: order_shipping_country {
    label: "(3) Order Order Shipping Country"
    description: "Country order is being shipped to (e.g. US, CA, etc.)."
  }

  dimension: daily_flash_times {
    label: "(3) Order Daily Flash Times"
    description: ""
  }
  dimension: flash_rank {
    label: "(3) Order Flash Rank"
    description: ""
  }

  measure: total_net_sales_USD {
    label: "(3) Order Total Net Sales USD"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}.total_net_sales_USD                                  ;;
    html: @{dynamic_currency_formatting_us} ;;
 }

  measure: total_number_orders_daily_flash {
    label: "(3) Order Orders | Daily Flash"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.total_number_orders_daily_flash                                 ;;
  }

  measure: total_net_sales_USD_running_total {
    label: "(3) Order Total Net Sales USD Running Total"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: running_total
    sql: ${total_net_sales_USD} ;;
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_number_orders_running_total {
    label: "(3) Order Orders Running Total"
    description: "Distinct count of order_pubkey"
    type: running_total
    sql: ${total_number_orders_daily_flash}                               ;;
  }

  measure: distinct_new_customer_count_daily_flash {
    label: "(3) Order New Customer Count | Daily Flash"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_daily_flash                                 ;;
  }

  measure: distinct_customer_count_running_total {
    label: "(3) Order New Customer Count Running Total"
    description: ""
    type: running_total
    sql: ${distinct_new_customer_count_daily_flash}  ;;
  }

  measure: total_net_sales_USD_yesterday_py {
    label: "(3) Order Total Net Sales USD Yesterday Py"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}.total_net_sales_USD_yesterday_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_last_7_days_py {
    label: "(3) Order Total Net Sales USD Last 7 Days Py"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}.total_net_sales_USD_last_7_days_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
 }

  measure: total_net_sales_USD_last_30_days_py {
    label: "(3) Order Total Net Sales USD Last 30 Days Py"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}.total_net_sales_USD_last_30_days_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_last_365_days_py {
    label: "(3) Order Total Net Sales USD Last 365 Days Py"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}.total_net_sales_USD_last_365_days_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
    }

  measure: total_number_orders_yesterday_py {
    label: "(3) Order Orders Yesterday PY"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.total_number_orders_yesterday_py                                ;;
  }

  measure: total_number_orders_last_7_days_py {
    label: "(3) Order Orders Last 7 Days PY"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.total_number_orders_last_7_days_py                                 ;;
  }

  measure: total_number_orders_last_30_days_py {
    label: "(3) Order Orders Last 30 Days PY"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.total_number_orders_last_30_days_py                                 ;;
  }

  measure: total_number_orders_last_365_days_py {
    label: "(3) Order Orders Last 365 Days PY"
    description: "Distinct count of order_pubkey"
    type: sum
    sql: ${TABLE}.total_number_orders_last_365_days_py                                 ;;
  }


  measure: distinct_new_customer_count{
    label: "(3) Order Distinct New Customer Count Yesterday Py"
    description: ""
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_daily_flash                                 ;;
  }


  measure: distinct_new_customer_count_yesterday_py {
    label: "(3) Order Distinct New Customer Count Yesterday Py"
    description: ""
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_yesterday_py                                 ;;
  }

  measure: distinct_new_customer_count_last_7_days_py {
    label: "(3) Order Distinct New Customer Count Last 7 Days Py"
    description: ""
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_last_7_days_py                                 ;;
  }

  measure: distinct_new_customer_count_last_30_days_py {
    label: "(3) Order Distinct New Customer Count Last 30 Days Py"
    description: ""
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_last_30_days_py                                 ;;
  }

  measure: distinct_new_customer_count_last_365_days_py {
    label: "(3) Order Distinct New Customer Count Last 365 Days Py"
    description: ""
    type: sum
    sql: ${TABLE}.distinct_new_customer_count_last_365_days_py                                ;;
  }

  measure: total_media_spend {
    label: "(1) Marketing Spend Total Media Spend"
    description: "Total Media Spend, no filters"
    type: sum
    sql: ${TABLE}.total_media_spend                                ;;
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_yesterday_py {
    label: "(1) Marketing Spend Total Media Spend Yesterday Py"
    description: "Total Media Spend, no filters"
    type: sum
    sql: ${TABLE}.total_media_spend_yesterday_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
 }

  measure: total_media_spend_last_7_days_py {
    label: "(1) Marketing Spend Total Media Spend Last 7 Days Py"
    description: "Total Media Spend, no filters"
    type: sum
    sql: ${TABLE}.total_media_spend_last_7_days_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_media_spend_last_365_days_py {
    label: "(1) Marketing Spend Total Media Spend Last 365 Days Py"
    description: "Total Media Spend, no filters"
    type: sum
    sql: ${TABLE}.total_media_spend_last_365_days_py                                 ;;
    html: @{dynamic_currency_formatting_us} ;;
 }

  measure: total_media_spend_last_30_days_py {
    label: "(1) Marketing Spend Total Media Spend Last 30 Days Py"
    description: "Total Media Spend, no filters"
    type: sum
    sql: ${TABLE}.total_media_spend_last_30_days_py                               ;;
    html: @{dynamic_currency_formatting_us} ;;
 }


  measure: cpa {
    label: "CPA"
    type: number
    sql: ${total_media_spend}/nullif(${distinct_new_customer_count_daily_flash},0) ;;

    value_format_name: usd_0
  }

  measure: cpa_yesterday_py {
    label: "CPA Yesterday PY"
    type: number
    sql: ${total_media_spend_yesterday_py}/nullif(${distinct_new_customer_count_yesterday_py},0) ;;

    value_format_name: usd_0
  }

  measure: cpa_last_7_days_py {
    label: "CPA Last 7 Days PY"
    type: number
    sql: ${total_media_spend_last_7_days_py}/nullif(${distinct_new_customer_count_last_7_days_py},0) ;;

    value_format_name: usd_0
  }

  measure: cpa_last_30_days_py {
    label: "CPA Last 30 Days PY"
    type: number
    sql: ${total_media_spend_last_30_days_py}/nullif(${distinct_new_customer_count_last_30_days_py},0) ;;


    value_format_name: usd_0
  }

  measure: cpa_last_365_days_py {
    label: "CPA Last 365 Days PY"
    type: number
    sql: ${total_media_spend_last_365_days_py}/nullif(${distinct_new_customer_count_last_365_days_py},0) ;;

    value_format_name: usd_0
  }












}
