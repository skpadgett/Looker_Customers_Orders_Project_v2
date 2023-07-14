view: customer_subscriber {
  derived_table: {
    sql:
      SELECT
        customer.customer_pubkey,
        customer.last_order_date_at_tz_ny_curly,
        customer.subscription_status_customer,
        customer.subscription_status_curly,
        customer.first_order_date_company_at_tz_ny,
        customer.first_sub_order_date_company_at_tz_ny,
        customer.first_non_sub_order_date_company_at_tz_ny,
        customer.first_order_date_at_tz_ny_curly,
        customer.first_order_date_sub_at_tz_ny_curly,
        customer.first_order_date_non_sub_at_tz_ny_curly,
        customer.last_order_date_company_at_tz_ny,
        order_items.gross_sales_without_taxes_amount_USD,
        order_items.target_category,
        order_items.order_pubkey
      FROM
        order_items
      LEFT JOIN
        customer
      ON
        order_items.customer_pubkey = customer.customer_pubkey
    ;;
  }
  dimension: customer_pubkey {
    type: string
    primary_key: yes
    sql: ${TABLE}.customer_pubkey ;;
    group_label: "ID Fields"
  }
  dimension: order_pubkey {
    type: string
    sql: ${TABLE}.order_pubkey ;;
    group_label: "ID Fields"
  }
  dimension: target_category {
    type: string
    sql: ${TABLE}.target_category ;;
    hidden: yes
    group_label: "Item Category"
  }
  dimension: subscription_status_company {
    type: string
    sql: ${TABLE}.subscription_status_customer ;;
    group_label: "Current Subscription Status"
  }
  dimension: subscription_status_curly {
    type: string
    sql: ${TABLE}.subscription_status_curly ;;
    group_label: "Current Subscription Status"
  }
  dimension_group: last_order_date_curly_at_tz_ny {
    label: "Last Order Date - curly - NY TZ"
    type: time
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
    hidden: yes
    sql: ${TABLE}.last_order_date_at_tz_ny_curly ;;
  }
  dimension_group: first_order_date_company_at_tz_ny {
    label: "First Order - Company"
    type: time
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
    sql: ${TABLE}.first_order_date_company_at_tz_ny ;;
  }
  dimension_group: first_sub_order_date_company_at_tz_ny {
    label: "First Subscription Order - Company"
    type: time
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
    sql: ${TABLE}.first_sub_order_date_company_at_tz_ny ;;
  }
  dimension_group: first_non_sub_order_date_company_at_tz_ny {
    label: "First Non Subscription Order - Company"
    type: time
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
    sql: ${TABLE}.first_non_sub_order_date_company_at_tz_ny ;;
  }
  dimension_group: first_order_date_curly_at_tz_ny {
    label: "First Order Date - curly - NY TZ"
    type: time
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
    hidden: yes
    sql: ${TABLE}.first_order_date_at_tz_ny_curly ;;
  }
  dimension_group: first_order_date_sub_at_tz_ny_curly {
    label: "First Order Date Subscriber - curly - NY TZ"
    type: time
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
    hidden: yes
    sql: ${TABLE}.first_order_date_sub_at_tz_ny_curly ;;
  }
  dimension_group: first_order_date_non_sub_at_tz_ny_curly {
    label: "First Order Date Subscriber - curly - NY TZ"
    type: time
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
    hidden: yes
    sql: ${TABLE}.first_order_date_non_sub_at_tz_ny_curly ;;
  }
  dimension_group: last_order_date_company_at_tz_ny {
    label: "Last Order - Company"
    type: time
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
    sql: ${TABLE}.last_order_date_company_at_tz_ny ;;
  }

  measure: total_number_orders  {
    type: count_distinct
    description: "Distinct count of order_pubkey"
    sql: ${order_pubkey} ;;
    group_label: "Order Counts"
  }
  measure: total_number_orders_curly  {
    type: count_distinct
    description: "Distinct count of order_pubkey - curly"
    sql: ${order_pubkey} ;;
    filters: [target_category: "curly"]
    group_label: "Order Counts"
  }
  measure: total_number_orders_skin  {
    type: count_distinct
    description: "Distinct count of order_pubkey - Skin"
    sql: ${order_pubkey} ;;
    filters: [target_category: "skin"]
    group_label: "Order Counts"
  }

  measure: gross_sales_without_taxes_amount_USD  {
    type: sum
    description: "Total Lifetime Net Revenue"
    sql:${TABLE}.gross_sales_without_taxes_amount_USD ;;
    value_format_name: usd_0
    group_label: "Revenue"
  }
  measure: gross_sales_without_taxes_amount_USD_curly  {
    type: sum
    description: "Total Lifetime Net Revenue - curly"
    sql:${TABLE}.gross_sales_without_taxes_amount_USD ;;
    filters: [target_category: "curly"]
    value_format_name: usd_0
    group_label: "Revenue"
  }
  measure: gross_sales_without_taxes_amount_USD_skin  {
    type: sum
    description: "Total Lifetime Net Revenue - Skin"
    sql:${TABLE}.gross_sales_without_taxes_amount_USD ;;
    filters: [target_category: "skin"]
    value_format_name: usd_0
    group_label: "Revenue"
  }

  measure: total_distinct_customers {
    type: count_distinct
    description: "Distinct customers"
    sql: ${customer_pubkey};;
    group_label: "Customer Counts"
  }
  measure: total_distinct_customers_curly {
    type: count_distinct
    description: "Distinct customers - curly"
    filters: [target_category: "curly"]
    sql: ${customer_pubkey};;
    group_label: "Customer Counts"
  }
  measure: total_distinct_customers_skin {
    type: count_distinct
    description: "Distinct customers - Skin"
    filters: [target_category: "skin"]
    sql: ${customer_pubkey};;
    group_label: "Customer Counts"
  }
}
