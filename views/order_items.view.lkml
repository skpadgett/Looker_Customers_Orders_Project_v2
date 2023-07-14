#### DESCRIPTION --------------------------------------------------------------------------------------------------------------------

# This view pulls data from the order items data mart. There are many hidden fields within this view. This is to support efforts to provide visibility into rollup aggregation bucketed by timeframes.
# A future enhancement opportunity would be to roll these aggregation needs into an aggregate PDT to enhance performance and efficiency.


view: order_items {

    sql_table_name: `customer.customer_bi_datamart_growth_customer_ltv_customer_order.order_items`
        ;;

#### SETS --------------------------------------------------------------------------------------------------------------------

  set: detail {
    fields: [order_date_at_tz_ny_date, is_first_order, is_free_order]
  }

#### DIMENSIONS --------------------------------------------------------------------------------------------------------------------

  dimension: order_shipping_country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.order_shipping_country ;;
    group_label: "Order Address"
  }

  dimension:  units {
    type: number
    hidden: yes
    sql: ${TABLE}.quantity ;;
    group_label: "Order Composition"
  }

  ## Beginning of ID fields

  dimension: pk_order_items{
    description: "Pseudo-primary key. Looker needs a unique primary key defined to pull measures through to joins and employ aggregate awareness."
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${order_item_pubkey},${box_pubkey}) ;;
    group_label: "ID Fields"
  }

  dimension: order_item_pubkey {
    hidden: yes
    type: string
    sql: ${TABLE}.order_item_pubkey ;;
    group_label: "ID Fields"
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey {
    hidden: yes
    type: string
    sql: ${TABLE}.order_pubkey ;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey {
    hidden: yes
    type: string
    sql: ${TABLE}.customer_pubkey ;;
    group_label: "ID Fields"
  }

  dimension: box_pubkey {
    hidden: yes
    type: string
    sql: coalesce(${TABLE}.box_pubkey, " ");;
    group_label: "ID Fields"
  }

  ## End of ID fields

  ## Beginning of order flags dimensions

  dimension: is_valid_sales_order {
      type: yesno
      sql: ${TABLE}.is_valid_sales_order ;;
      group_label: "Order Flags"
  }

  dimension: is_valid_operations_order {
      type: yesno
      sql: ${TABLE}.is_valid_operations_order ;;
      group_label: "Order Flags"
  }

  dimension: is_first_order {
      type: yesno
      sql: ${TABLE}.is_first_order ;;
      group_label: "Order Flags"
  }

  dimension: is_free_order {
      type: yesno
      sql: ${TABLE}.is_free_order ;;
      group_label: "Order Flags"
  }

  dimension: is_first_paid_order {
      type: yesno
      sql: ${TABLE}.is_first_paid_order ;;
      group_label: "Order Flags"
  }

  dimension: is_order_placed_from_subscription {
    type: yesno
    sql: ${TABLE}.is_order_placed_from_subscription ;;
    group_label: "Order Flags"
  }

  dimension: is_subscription_at_first_order {
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order ;;
    group_label: "Order Flags"
  }

  ## End of order flags dimensions

  ## Beginning of item flags dimensions

  dimension: is_available_as_gwp {
    label: "Is Available as GWP"
    type: yesno
    sql: ${TABLE}.is_available_as_gwp ;;
    group_label: "Item Flags"
  }

  dimension: is_revenue_generating_item {
      type: yesno
      sql: ${TABLE}.is_revenue_generating_item ;;
      group_label: "Item Flags"
  }


  dimension: is_order_item_from_subcription {
    type: yesno
    sql: ${TABLE}.is_order_item_from_subcription ;;
    group_label: "Item flags"
  }

  ## End of item flags dimensions

  ## Beginning of item info dimensions

  dimension: net_sales_without_taxes_amount_USD {
    hidden: yes
    type: number
    sql: ${gross_sales_without_taxes_amount_USD} - ${product_total_discount} ;;
    group_label: "Item Info"
    html: @{dynamic_currency_formatting_us} ;;
  }

  dimension: gross_sales_without_taxes_amount_USD {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_sales_without_taxes_amount_USD ;;
    group_label: "Item Info"
    html: @{dynamic_currency_formatting_us} ;;
  }

  dimension: item_type {
    type: string
    sql: ${TABLE}.item_type ;;
    group_label: "Item Info"
  }

  dimension: product_total_discount {
    hidden: yes
    type: number
    sql: ${TABLE}.product_total_discount_USD ;;
    group_label: "Item Info"
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}.product_type ;;
    group_label: "Item Info"
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    group_label: "Item Info"
    html: @{proper_case_snakecase} ;;
    }

  dimension: new_products {
    description: "Dedicated dimension to isolate new products for new products dashboard. Add products to this case statement
                  upon release; remove products from this case statement when products mature out of new product categorization."
    type: string
    sql: case when ${TABLE}.product_name = 'styling_gel'
              then ${TABLE}.product_name
              else null
              end;;
    group_label: "Item Info"
    html: @{proper_case_snakecase} ;;
  }

  dimension: product_fragrance {
    type: string
    sql: ${TABLE}.product_fragrance ;;
    group_label: "Item Info"
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
    group_label: "Item Info"
  }

  dimension: product_price_USD {
    type: number
    sql: ${TABLE}.product_price_USD ;;
    group_label: "Item Info"
  }

  dimension: product_price_subscription_USD {
    type: number
    sql: ${TABLE}.product_price_subscription_USD ;;
    group_label: "Item Info"
  }

  ## End of item info dimensions

  ## Beginning of item category dimensions

  dimension: target_category {
      type: string
      sql: ${TABLE}.target_category ;;
      group_label: "Item Category"
  }

  dimension: target_sub_category {
      type: string
      sql: ${TABLE}.target_sub_category ;;
      group_label: "Item Category"
  }

  dimension: product_target_category {
      type: string
      sql: ${TABLE}.product_target_category ;;
      group_label: "Item Category"
  }

  dimension: product_target_sub_category {
      type: string
      sql: ${TABLE}.product_target_sub_category ;;
      group_label: "Item Category"
  }


  ### Beginning of Daily Flash dimensions

  dimension: daily_flash_times {
    hidden: yes
    sql: case when ${order_date_yesterday} is not null
          then 'Yesterday'
          when ${order_date_last_7_days} is not null
          then 'Last 7 Days'
          when ${order_date_last_30_days} is not null
          then 'Last 30 Days'
          when ${order_date_last_365_days} is not null
          then 'Last 365 Days'
          else null
          end;;
    group_label: "Daily Flash Times"
  }

  dimension: order_date_yesterday {
    hidden: yes
    type: string
    sql: case when ${yesterday}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Times"
  }

  dimension: order_date_last_7_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Times"
  }

  dimension: order_date_last_30_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Times"
  }

  dimension: order_date_last_365_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days} or ${last_365_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Times"
  }

  dimension: yesterday {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} = @{yesterday_sql}
          then true
          else false
          end;;
    group_label: "Relative to Today"
  }

  dimension: last_7_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_7_days} and @{yesterday_sql}
          then true
          else false
          end;;
    group_label: "Relative to Today"
  }

  dimension: last_30_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_30_days} and @{yesterday_sql}
          then true
          else false
          end;;
    group_label: "Relative to Today"
  }

  dimension: last_365_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_365_days} and @{yesterday_sql}
          then true
          else false
          end;;
    group_label: "Relative to Today"
  }

  dimension: order_pubkey_yesterday {
    hidden: yes
    type: string
    sql: case when ${yesterday}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_7_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_30_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_365_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days} or ${last_365_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: flash_rank {
    description: "Ranking dimension to ensure the time binning is in chronological order."
    hidden: yes
    sql: case when ${daily_flash_times} = 'Yesterday'
          then 1
          when ${daily_flash_times} = 'Last 7 Days'
          then 2
          when ${daily_flash_times} = 'Last 30 Days'
          then 3
          when ${daily_flash_times} = 'Last 365 Days'
          then 4
          end;;
    group_label: "Daily Flash Times"
  }

  ### End of Daily Flash dimensions



#### DIMENSION GROUPS --------------------------------------------------------------------------------------------------------------------


  dimension_group: last_synced {
    description: "This field gives the last synced metadata for the order data mart.
    This is used in the last_synced explore to provide last synced metadata for all datamarts throughout Pandera-developed dashboards"
    hidden: no
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

  dimension_group: order_date_at_tz_ny {
    type: time
    label: "Order Date - NY TZ"
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date_at_tz_ny ;;
  }

  dimension_group: launch {
    type: duration
    sql_start: ${drv_launch_date_by_product.launch_date_raw} ;;
    sql_end: ${order_date_at_tz_ny_raw} ;;
  }

#### PARAMETERS AND DYNAMIC SELECTORS --------------------------------------------------------------------------------------------------------------------

  parameter: date_granularity {
    description: "Use This Selector with the Reporting Period dimension for dynamic Period over Period analysis "
    type: unquoted
    allowed_value: {
      label: "Yesterday"
      value: "day"
    }
    allowed_value: {
      label: "Last 7 Days"
      value: "week"
    }
    allowed_value: {
      label: "Last 14 Days"
      value: "two_week"
    }
    allowed_value: {
      label: "Last 30 Days"
      value: "month"
    }
  }

  parameter: select_days_since_launch {
    hidden: no
    type: string
    default_value: "< 31"
    allowed_value: {
      label: "30 days"
      value: "< 31"
    }
    allowed_value: {
      label: "60 Days"
      value: "< 61"
    }
    allowed_value: {
      label: "90 Days"
      value: "< 91"
    }
    allowed_value: {
      label:"1 yr"
      value: "< 366"
    }
    allowed_value: {
      label: "no limit"
      value: "< 99999"
    }
  }

  parameter: select_timeframe {
    label:  "Period over Period Scope"
    description: "Use with period buttons in daily flash for dynamic Period over Period analysis "
    hidden: yes
    type: string
    default_value: "Last 7 Days"
    allowed_value: {
      value: "Last 7 Days"
    }
    allowed_value: {
      value: "Last 30 Days"
    }
    allowed_value: {
      value: "Last 90 Days"
    }
    allowed_value: {
      value: "YTD"
    }
  }

  dimension: current_vs_previous_period {
    description: "Use this dimension along with \"Period over Period Scope\" Filter for dynamic Period of Period analysis"
    hidden: yes
    type: string
    sql:
    case
      {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_7_days} and @{yesterday_sql}
      {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_30_days} and @{yesterday_sql}
      {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
       when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_90_days} and @{yesterday_sql}
       {% elsif select_timeframe._parameter_value == "'YTD'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_year} and @{yesterday_sql}
        {% endif %}
        then 'Current Year'
      {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_7_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_30_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_90_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'YTD'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_year_prior_year} and @{yesterday_prior_year}
      {% endif %}
      then 'Prior Year'
      else null
    end
    ;;
  }

  dimension: selected_dynamic_duration  {
    hidden: yes
    description: "Dynamic date column for Period over Period analysis"
    type: number
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      ${order_date_at_tz_ny_day_of_week_index}
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
     ${order_date_at_tz_ny_month_num}
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      ${order_date_at_tz_ny_month_num}
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
     ${order_date_at_tz_ny_month_num}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of  {
    label: "Trend Line Date"
    description: "Dynamic date column for Period over Period analysis"
    hidden: yes
    order_by_field: selected_dynamic_day_of_sort
    type: string
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
    ${order_date_at_tz_ny_month_name}
      {% endif %}
      ;;
  }

  dimension: selected_dynamic_day_of_sort  {
    description: "Sorting column to dynamically sort Period over Period analysis in chronological order"
    hidden:  yes
    type: string
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
    format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
    format_date("%m",${order_date_at_tz_ny_date})
    {% endif %} ;;
  }

  parameter: measure_selector {
    description: "Used to toggle between KPI views in New Product Launch dashboard."
    hidden: yes
    type: unquoted
    allowed_value: {label: "Gross Sales"
      value: "grosssales"}
    allowed_value: {label: "Items"
      value: "items"}
    allowed_value: {label: "Gross AOV"
      value: "aov"}
    allowed_value: {label: "Customers"
      value: "customers"}
    allowed_value: {label: "New Gross Sales"
      value: "cpa"}
  }

  measure: selected_measure {
    hidden: yes
    label_from_parameter: measure_selector
    type: number
    value_format: "#,##0"   # default value format for the ‘else’ values
    sql:
      {% if measure_selector._parameter_value == 'grosssales' %} ${total_gross_sales_without_taxes_USD}
      {% elsif measure_selector._parameter_value == 'items' %} ${all_customer_units}                    -- may not be right - i.e. need measure filtered by product line/product
      {% elsif measure_selector._parameter_value == 'aov' %} ${gross_average_order_value_USD}
      {% elsif measure_selector._parameter_value == 'customers' %} ${distinct_new_customer_count}
      {% elsif measure_selector._parameter_value == 'cpa' %} ${total_gross_new_sales_USD}              -- need CPA
      {% endif %}
      ;;
    html:
     {% if measure_selector._parameter_value ==  'items' %}
     {{rendered_value }}
     {% elsif measure_selector._parameter_value == 'customers' %}
     {{rendered_value }}
     {% else %}
     ${{ rendered_value }}
     {% endif %}
     ;;
  }

    dimension: selected_dynamic_launch_days_label  {
      description: "Dynamic Number of Launch days grouping"
      label: "Days Since Launch"
      type: number
      sql:
          {% if select_days_since_launch._parameter_value == "'< 31'" %}
           ${days_launch}
          {% elsif select_days_since_launch._parameter_value == "'< 61'" %}
              ${days_launch}
          {% elsif select_days_since_launch._parameter_value == "'< 91'" %}
            DIV(${days_launch},7)* 7
          {% elsif select_days_since_launch._parameter_value == "'< 366'" %}
            DIV(${days_launch},7)* 7
          {% elsif select_days_since_launch._parameter_value == "'< 99999'" %}
           DIV(${days_launch},30)* 30
          {% else %}
            DIV(${days_launch},7)* 7

        {% endif %}
        ;;
    }

    dimension: selected_dynamic_launch_days_duration  {
      description: "Dynamic Number of Launch days grouping"
      type: number
      sql:
          {% if select_days_since_launch._parameter_value == "'< 31'" %}
           31
          {% elsif select_days_since_launch._parameter_value == "'< 61'" %}
            61
          {% elsif select_days_since_launch._parameter_value == "'< 91'" %}
            91
          {% elsif select_days_since_launch._parameter_value == "'< 366'" %}
           366
          {% elsif select_days_since_launch._parameter_value == "'< 99999'" %}
           9999
          {% else %}
           31

        {% endif %}
        ;;
    }


#### MEASURES --------------------------------------------------------------------------------------------------------------------

  ### Beginning of customer counts measures

  measure: distinct_customer_count  {
    type: count_distinct
    sql: ${customer_pubkey}  ;;
    group_label: "Customer Counts"
  }

  measure: distinct_new_customer_count {
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes"]
  }

  measure: distinct_new_customer_non_sub_count {
    label: "New Customers | Non-Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "No"]
  }

  measure: distinct_new_customer_sub_count {
    label: "New Customers | Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "Yes"]
  }

  measure: distinct_repeat_customer_sub_count {
    label: "Repeat Customers | Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "No",is_order_placed_from_subscription: "Yes"]
  }

  measure: distinct_repeat_customer_non_sub_count {
    label: "Repeat Customers | Non-Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "No",is_order_placed_from_subscription: "No"]
  }

  ### End of customer counts measures

  ### Beginning of revenue measures

  measure: total_net_sales_USD  {
    description: "Sum of units"
    hidden: yes
    type: sum
    sql:${net_sales_without_taxes_amount_USD} ;;
    group_label: "Revenue"
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_product_total_discount  {
    description: "Sum of units"
    type: sum
    sql:${product_total_discount} ;;
    group_label: "Revenue"
    value_format_name: usd_0
  }

  measure: total_gross_sales_without_taxes_USD  {
    description: "Gross Sales USD"
    type: sum
    sql:${gross_sales_without_taxes_amount_USD} ;;
    group_label: "Revenue"
    html: @{dynamic_currency_formatting_us} ;;
    value_format_name: usd_0
  }

  ### End of revenue measures

  ### Beginning of units measures

  measure: product_and_gwp_unit_count  {
    label: "Product and GWP Unit Count"
    description: "Sum of units"
    type: sum
    sql:${TABLE}.quantity ;;
    group_label: "Units"
  }

  measure: all_customer_units {
    description: "Order total number of units (curly supplements core & booster considered one single product)"
    type: sum
    sql: ${TABLE}.quantity ;;
    group_label: "Units"
  }

  measure: product_unit_count  {
    description: "Sum of units for revenue generating items"
    type: sum
    sql:${TABLE}.quantity ;;
    group_label: "Units"
    filters: [is_revenue_generating_item: "Yes"]
  }

  measure: net_new_units {
    description: "Units from new orders (new customers); includes sub and non-sub"
    type: sum_distinct
    sql: ${units} ;;
    filters: [is_first_order: "Yes"]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_units {
    description: "Units from all repeat orders (sub and non-sub)"
    type: sum_distinct
    sql: ${units} ;;
    filters: [is_first_order: "No"]
    drill_fields: [detail*]
    group_label: "Units"
  }

  measure: subscription_units {
    type: sum_distinct
    description: "Units from all subscription orders"
    sql: ${units} ;;
    filters: [is_order_placed_from_subscription: "Yes"]
    drill_fields: [detail*]
    group_label: "Units"
  }

  measure: non_subscription_units{
    description: "Units from all non-subscription orders"
    type: sum_distinct
    sql: ${units} ;;
    filters: [is_order_placed_from_subscription: "No"]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: new_subscription_at_first_units {
    description: "Units from new orders by customers who subscribed at first order"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "Yes",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: new_non_subscription_at_first_units {
    label: "New Non-Subscription at First Units "
    description: "Units from new orders by customers who did not subscribe at first order"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "Yes",
      customer.is_subscription_at_first_order_company: "No"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_nonsub_units {
    label: "Repeat Non-Subscription units "
    description: "Repeat units for repeat non-sub orders"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_subscription_units {
    label: "Repeat Subscription units"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      customer.has_ever_subscribed_company: "Yes",
      is_order_placed_from_subscription: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_sub_at_first_units {
    label: "Repeat Sub at First units"
    description: "Repeat units from those who subscribed at first order - includes ALL repeat orders (sub and non-sub)"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_sub_at_first_orders_non_sub_units {
    description: "Repeat units from those who subscribed at a repeat order - only includes subscription orders"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_sub_at_first_sub_units {
    label: "Repeat Sub at First Sub units"
    description: "Repeat units from those who subscribed at first sub - only includes subscription orders"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_subscription_units_churned {
    label: "Repeat Subscription units  Churned Customers "
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  measure: repeat_sub_at_first_sub_units_churned {
    label: "Repeat Sub at First Sub units Churned Customers "
    description: "Repeat units from churned customers who subscribed at first sub - only includes subscription orders"
    type: sum_distinct
    sql: ${units} ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]

    group_label: "Units"
  }

  ### End of units measures

  ### Beginning of discount values measures

  measure: total_subscription_discount_amount_USD  {
    description: "Discount amount from subcription USD"
    type: sum
    sql:${TABLE}.total_subscription_discount_amount_USD ;;
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: total_free_product_discount_amount_USD  {
    description: "Discount amount from free product USD"
    type: sum
    sql:${TABLE}.total_free_product_discount_amount_USD ;;
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: total_flat_coupon_discount_amount_USD  {
    description: "Discount amount from flat coupon USD"
    type: sum
    sql:${TABLE}.total_flat_coupon_discount_amount_USD ;;
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  ### End of discount values measures

  ### Beginning of average order values measures

  measure: gross_average_order_value_USD  {
    label: "Gross AOV USD"
    description: "Gross Sales / Orders"
    type: number
    sql: 1.0 * ${total_gross_sales_without_taxes_USD} / nullif(${total_number_orders},0) ;;
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: total_gross_new_sales_USD {
    label: "Total New Grpss Sales USD"
    description: "Gross Sales from new orders (new customers); includes sub and non-sub"
    type: sum
    sql: ${gross_sales_without_taxes_amount_USD} ;;
    drill_fields: [detail*]
    group_label: "Gross Sales"
    filters: [is_first_order: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
    value_format: "$#,##0.00"
  }

  measure: total_repeat_sales_USD {
    label: "Total Repeat Gross Sales USD"
    description: "Gross Sales from all repeat orders (sub and non-sub)"
    type: sum
    sql:  ${gross_sales_without_taxes_amount_USD} ;;
    drill_fields: [detail*]
    group_label: "Gross Sales"
    filters: [is_first_order: "No"]
    html: @{dynamic_currency_formatting_us} ;;
    value_format: "$#,##0.00"
  }

  ### End of average order values measures

  ### Beginning of order counts measures

  measure: total_number_orders   {
    label: "Orders"
    description: "Distinct count of order_pubkey"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  measure: total_number_orders_daily_flash   {
    label: "Orders | Daily Flash"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: count_distinct
    sql: case when ${daily_flash_times} = 'Yesterday'
          then ${order_pubkey_yesterday}
          when ${daily_flash_times} = 'Last 7 Days'
          then ${order_pubkey_last_7_days}
          when ${daily_flash_times} = 'Last 30 Days'
          then ${order_pubkey_last_30_days}
          when ${daily_flash_times} = 'Last 365 Days'
          then ${order_pubkey_last_365_days}
          else null
          end;;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  measure: total_number_orders_running_total  {
    label: "Orders Running Total"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: running_total
    sql: ${total_number_orders_daily_flash};;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  measure: total_number_of_placed_from_subscription_orders {
    label: "Orders Placed from Subscription"
    description: "# of Orders where is_order_placed_from_subscription = Yes"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_order_placed_from_subscription: "Yes"]
  }

  measure: total_number_of_non_subscription_orders {
    label: "Non-Subscription Orders"
    description: "# of Orders where is_order_placed_from_subscription = No"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_order_placed_from_subscription: "No"]
  }

  measure: total_number_of_new_orders {
    label: "New Orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes"]
  }

  measure: total_number_of_new_orders_subscribed_at_first {
    label: "New Subscription at First Orders"
    description: "Count of New Orders that are Subscription; same as New Subscription at First Customers"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "Yes"]
  }

  measure: total_number_of_new_orders_not_subscribed_at_first {
    label: "New Non-Subscription at First Orders"
    description: "Count of New Orders that are Non-Subscription; same as New Non-Subscription Customers"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "No"]
  }

  measure: total_number_of_repeat_orders {
    label: "Repeat Orders"
    description: "Count of Orders where Is First Order = No; Includes Sub and Non-sub"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No"]
  }

  measure: total_number_of_subscription_repeat_orders {
    label: "Repeat Subscription Orders"
    description: "Count of Repeat Orders where Is Order Placed From Subscription = Yes"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "Yes"]
  }

  measure: total_number_of_repeat_orders_by_subscribed_at_first {
    label: "Repeat Orders by Subscribed at First Customers"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", customer.is_subscription_at_first_order_company: "Yes"]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_customers {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders {
    label: "Repeat Non-Subscription Orders"
    description: "Count of Repeat Orders where Is Order Placed From Subscription = No"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "No"]
  }

  measure: total_number_of_subscription_repeat_orders_not_subscribed_at_first {
    label: "Repeat Subscription Orders by Non-Subscribers at First Customers"
    description: "Count of repeat subscription orders, placed by those who did not subscribe at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_subscribed_at_first {
    label: "Repeat Subscription Orders by Subscribers at First Customers"
    description: "Count of repeat subscription orders, placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders_not_subscribed_at_first {
    label: "Repeat Non-Subscription Orders by Non-Subscribers at First Customers"
    description: "Count of repeat non-subscription orders, placed by those who did not subscribe at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No",
      customer.is_subscription_at_first_order_company: "No"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders_subscribed_at_first {
    label: "Repeat Non-Subscription Orders by Subscribers at First Customers"
    description: "Count of repeat non-subscription orders, placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
  }

  measure: product_and_gwp_item_count  {
    description: "Distinct count of order_item_pubkey"
    type: count_distinct
    sql: ${order_item_pubkey} ;;
    group_label: "Order Counts"
  }

  measure: product_item_count  {
    description: "Distinct count of order_item_pubkey for revenue generating items"
    type: count_distinct
    sql: ${order_item_pubkey} ;;
    group_label: "Order Counts"
    filters: [is_revenue_generating_item: "Yes"]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first {
    label: "Repeat Subscription Orders by Subscribed at First Customers"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes"
    ]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first_churned {
    label: "Repeat Subscription Orders by Subscribed at First-Churned Customers"
    description: "Count of ALL repeat  sub orders placed by those who subscribed at first order and have previously cancelled"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_churned_customers {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers-Churned"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  measure: total_repeat_sub_at_repeat_orders {
    label: "Repeat Sub at Repeat Orders"
    description: "Repeat Orders from those who subscribed at a repeat order - only includes subscription orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes"
    ]
  }

  ### End of order counts measures


}
