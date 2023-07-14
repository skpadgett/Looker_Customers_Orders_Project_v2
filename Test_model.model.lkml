connection: "customer_prod_connection"

include: "/views/*.view.lkml"       # include all views in the views/ folder in this project
include: "/views/*/*.view.lkml"       # include all views in the views/ folder in this project
include: "/tests/*.lkml"            # include all tests in the tests/ folder in this project



datagroup: datagroup_orders {
  max_cache_age: "24 hours"
  sql_trigger: SELECT max(order_pubkey) FROM `customer.customer_bi_datamart_growth_customer_ltv_customer_order.order` ;;
  interval_trigger: "12 hours"
}

explore:  customer {
  # join: order {
  #   sql_on:  ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  #   relationship: one_to_many
  # }
}

explore:  customer_subscriber {}

explore: order {
  label: "Orders & Customers"
  view_label: "(1) Order"
  sql_always_where:
  {% if order.current_vs_previous_period._in_query %} ${order.current_vs_previous_period} is not null {% else %} 1=1 {% endif %};;
  join: customer {
    view_label: "(2) Customer"
    type:  inner
    relationship: many_to_one
    sql_on: ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  }
}

explore: marketing_spend_and_orders {
  label: "Marketing Spend & Orders"
  fields: [marketing_spend*, order*, customer.is_subscription_at_first_order_company, customer.has_ever_subscribed_company, customer.customer_curly_texture_type,customer.is_customer_subscription_winback_company]
  view_label: "(3) Order"
  sql_always_where:
  {% if order.current_vs_previous_period._in_query %} ${order.current_vs_previous_period} is not null {% else %} 1=1 {% endif %};;
  view_name: order
  join: customer {
    view_label: "(2) Customer"
    type:  inner
    #foreign_key: customer_pubkey
    relationship: many_to_one
    sql_on: ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  }
  join: marketing_spend {
    view_label: "(1) Marketing Spend"
    type: inner
    relationship: many_to_many
    sql_on: ${marketing_spend.date_date} = ${order.order_date_at_tz_ny_date}
      AND ${marketing_spend.country} = ${order.order_shipping_country};;
  }
}


explore: marketing_spend_and_orders_wip {
  label: "Marketing Spend & Orders WIP"
  fields: [marketing_spend*, order*, customer.is_subscription_at_first_order_company, customer.has_ever_subscribed_company, customer.customer_curly_texture_type,customer.is_customer_subscription_winback_company]
  view_label: "(3) Order"
  sql_always_where:
  {% if order.current_vs_previous_period._in_query %} ${order.current_vs_previous_period} is not null {% else %} 1=1 {% endif %};;
  view_name: order
  join: customer {
    view_label: "(2) Customer"
    type:  inner
    #foreign_key: customer_pubkey
    relationship: many_to_one
    sql_on: ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  }
  join: marketing_spend {
    view_label: "(1) Marketing Spend"
    type: left_outer
    relationship: many_to_many
    sql_on: ${marketing_spend.date_date} = ${order.order_date_at_tz_ny_date}
      AND ${marketing_spend.country} = ${order.order_shipping_country};;
  }
}

explore: order_items {
  label: "Order Items & Customers"
  view_label: "(1) Order Items"
  join: customer {
    view_label: "(2) Customer"
    type:  inner
    foreign_key: customer_pubkey
    relationship: many_to_one
    }
  join: order {
    view_label: "(3) Orders"
    type: inner
    foreign_key: order_pubkey
    relationship: many_to_one
  }
  join: drv_launch_date_by_product {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_name}= ${drv_launch_date_by_product.product_name};;
  }
}

explore: last_synced {
  view_name: order
  fields: [customer.last_synced_raw,
    customer.last_synced_hour_of_day,
    customer.last_synced_date,
    customer.last_synced_day_of_week,
    customer.last_synced_week,
    customer.last_synced_month,
    customer.last_synced_month_name,
    customer.last_synced_quarter,
    customer.last_synced_year,
    order.last_synced_raw,
    order.last_synced_hour_of_day,
    order.last_synced_date,
    order.last_synced_day_of_week,
    order.last_synced_week,
    order.last_synced_month,
    order.last_synced_month_name,
    order.last_synced_quarter,
    order.last_synced_year,
    marketing_spend.last_synced_raw,
    marketing_spend.last_synced_hour_of_day,
    marketing_spend.last_synced_date,
    marketing_spend.last_synced_day_of_week,
    marketing_spend.last_synced_week,
    marketing_spend.last_synced_month,
    marketing_spend.last_synced_month_name,
    marketing_spend.last_synced_quarter,
    marketing_spend.last_synced_year,
    order_items.last_synced_raw,
    order_items.last_synced_hour_of_day,
    order_items.last_synced_date,
    order_items.last_synced_day_of_week,
    order_items.last_synced_week,
    order_items.last_synced_month,
    order_items.last_synced_month_name,
    order_items.last_synced_quarter,
    order_items.last_synced_year,
  ]
  join: customer {
    relationship: many_to_one
    sql_on: ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  }
  join: marketing_spend {
    relationship: many_to_many
    sql_on: ${marketing_spend.date_date} = ${order.order_date_at_tz_ny_date}
    AND ${marketing_spend.country} = ${order.order_shipping_country};;
  }
  join: order_items {
    relationship: one_to_many
    sql_on:  ${order.order_pubkey} = ${order_items.order_pubkey} ;;
  }
}

explore: finance_cohort {
  view_name: order_cohort_extension
  view_label: "(1) Order"
  join: customer {
    view_label: "(2) Customer"
    type:  inner
    foreign_key: customer_pubkey
    relationship: many_to_one
    #sql_on: ${order_cohort_extension.customer_pubkey} = ${customer.customer_pubkey};;
  }
  join: cohort_finance_name {
    type:  cross
    #foreign_key: customer_pubkey
    relationship: many_to_many
  }
  }
# This explore is used for single look that produces sql for cohort_finance_units_by_month PDT definition

# Look's name "Look for producing sql for cohort_finance_units_by_month_derived table"
  explore: finance_cohort_products {
    view_name: order_items_cohort_extension
    view_label: "(1) Order"
    join: customer {
      view_label: "(2) Customer"
      type:  inner
      foreign_key: customer_pubkey
      relationship: many_to_one
      #sql_on: ${order_items_cohort_extension.customer_pubkey} = ${customer.customer_pubkey};;
    }
    join: cohort_finance_name {
      type:  cross
      #foreign_key: customer_pubkey
      relationship: many_to_many
    }
    join: drv_launch_date_by_product {
      type: left_outer
      relationship: many_to_one
      sql_on: ${order_items_cohort_extension.product_name}= ${drv_launch_date_by_product.product_name};;
    }

  }

explore: drv_pdt_daily_flash  {}

explore:  subscription {}
