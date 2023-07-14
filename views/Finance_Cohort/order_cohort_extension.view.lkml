include: "/views/order.view.lkml"
view: order_cohort_extension {
  #################################################################
  #  The purpose of this extension of orders view is to provide a version of orders
  #  that includes objects dependent on crossjoin with cohort_finance_name.view
  #
  #  Modified versions of Discount and Sales Measure definitions included in this view because it uniquely requires
  #  use of sum_distinct due to x-join with cohort_finance name.
  ##############################################################
  sql_table_name: `prosehair.prose_bi_datamart_growth_customer_ltv_customer_order.order`
    ;;
  extends: [order]

  # dimension: order_pubkey {
  #   primary_key: yes
  #   hidden: yes
  #   type: string
  #   sql: ${TABLE}.order_pubkey ;;
  #   group_label: "ID Fields"
  # }
  dimension: cohort_finance_name {
    type: string
    hidden: yes
    sql:  ${cohort_finance_name.cohort_finance_name} ;;
  }

  measure: gross_sales_without_taxes_amount_USD  {
    label: "Gross Sales USD"
    type: sum_distinct
    sql:${TABLE}.gross_sales_without_taxes_USD  ;;
    value_format_name: usd_0
    drill_fields: [detail*]
    group_label: "Net Sales"
  }

# Net Sales

  measure: total_net_sales_USD {
    label: "Total Net Sales USD"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD  ;;
    value_format: "$#,##0.00"
    drill_fields: [detail*]
    group_label: "Net Sales"
  }

  measure: total_net_new_sales_USD {
    label: "Total New Net Sales USD"
    description: "Net Sales from new orders (new customers); includes sub and non-sub"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [is_first_order: "Yes"]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sales_USD {
    label: "Total Repeat Net Sales USD"
    description: "Net Sales from all repeat orders (sub and non-sub)"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [is_first_order: "No"]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_subscription_net_sales_USD {
    type: sum_distinct
    description: "Net Sales from all subscription orders"
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [is_order_placed_from_subscription: "Yes"]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_non_subscription_net_sales_USD {
    label: "Total Non-Subscription Net Sales USD"
    description: "Net Sales from all non-subscription orders"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [is_order_placed_from_subscription: "No"]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_new_subscription_at_first_net_sales_USD {
    label: "New Subscription at First Net Sales USD"
    description: "Net Sales from new orders by customers who subscribed at first order"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "Yes",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_new_non_subscription_at_first_net_sales_USD {
    label: "New Non-Subscription at First Net Sales USD"
    description: "Net Sales from new orders by customers who did not subscribe at first order"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "Yes",
      customer.is_subscription_at_first_order_company: "No"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_nonsub_net_sales_USD {
    label: "Repeat Non-Subscription Net Sales USD"
    description: "Repeat Net Sales for repeat non-sub orders"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_subscription_net_sales_USD {
    label: "Repeat Subscription Net Sales USD"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_subscription_net_sales_haircare_USD {
    label: "Repeat Subscription Net Sales Haircare USD"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      order_contains_haircare: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_subscription_net_sales_supplements_USD {
    label: "Repeat Subscription Net Sales Supplements USD"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      order_contains_supplements: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_first_net_sales_USD {
    label: "Repeat Sub at First Net Sales USD"
    description: "Repeat Net Sales from those who subscribed at first order - includes ALL repeat orders (sub and non-sub)"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_repeat_net_sales_USD {
    label: "Repeat Sub at Repeat Net Sales USD"
    description: "Repeat Net Sales from those who subscribed at a repeat order - only includes subscription orders"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",

      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_repeat_net_sales_haircare_USD {
    label: "Repeat Sub at Repeat Net Sales Haircare USD"
    description: "Repeat Net Sales from those who subscribed at a repeat order - only includes subscription orders for haircare"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_haircare: "yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_repeat_net_sales_supplements_USD {
    label: "Repeat Sub at Repeat Net Sales Supplements USD"
    description: "Repeat Net Sales from those who subscribed at a repeat order - only includes subscription orders for supplements"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_first_sub_net_sales_USD {
    label: "Repeat Sub at First Sub Net Sales USD"
    description: "Repeat Net Sales from those who subscribed at first sub - only includes subscription orders"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_first_sub_net_sales_haircare_USD {
    label: "Repeat Sub at First Sub Net Sales Haircare USD"
    description: "Repeat Net Sales from those who subscribed at first sub - only includes subscription orders for haircare"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_haircare: "yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_first_sub_net_sales_supplements_USD {
    label: "Repeat Sub at First Sub Net Sales Supplements USD"
    description: "Repeat Net Sales from those who subscribed at first sub - only includes subscription orders for supplements"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_subscription_net_sales_churned_USD {
    label: "Repeat Subscription Net Sales Churned Customers USD"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

  measure: total_repeat_sub_at_first_sub_net_sales_churned_USD {
    label: "Repeat Sub at First Sub Net Sales Churned Customers USD"
    description: "Repeat Net Sales from churned customers who subscribed at first sub - only includes subscription orders"
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format: "$#,##0.00"
    group_label: "Net Sales"
  }

# Discounts

  measure: total_number_of_new_discounts_not_subscribed_at_first {
    label: "New Non-Subscription at First discounts"
    description: "New discounts that are Non-Subscription; same as New Non-Subscription Customers"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "No"]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: total_number_of_new_discounts_subscribed_at_first {
    label: "New Subscription at First discounts"
    description: "New discounts that are Subscription; same as New Subscription at First Customers"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "Yes"]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: total_number_of_nonsubscription_repeat_discounts {
    label: "Repeat Non-Subscription discounts"
    description: "Repeat discounts where Is Order Placed From Subscription = No"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [is_first_order: "No", is_order_placed_from_subscription: "No"]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: total_number_of_subscription_repeat_discounts_subscribed_at_first {
    label: "Repeat Subscription discounts by Subscribers at First Customers"
    description: "repeat subscription discounts, placed by those who subscribed at first order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: total_number_of_repeat_subsciption_discounts_by_subscribed_at_first_haircare {
    label: "Repeat Subscription discounts by Subscribed at First Customers-Haircare"
    description: "ALL repeat discounts (sub and non-sub) placed by those who subscribed at first order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      order_contains_haircare: "Yes",
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: total_number_of_repeat_subsciption_discounts_by_subscribed_at_first_supplements {
    label: "Repeat Subscription discounts by Subscribed at First Customers-Supplements"
    description: "ALL repeat discounts (sub and non-sub) placed by those who subscribed at first order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      order_contains_supplements: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  # Duplicate? to total_number_of_subscription_repeat_discounts_subscribed_at_first
  measure: total_number_of_repeat_subsciption_discounts_by_subscribed_at_first {
    label: "Repeat Subscription discounts by Subscribed at First Customers"
    description: "ALL repeat discounts (sub and non-sub) placed by those who subscribed at first order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: sum_of_subscription_repeat_discounts_sub_at_repeat_customers {
    label: "Repeat Sub discounts by Subscribed at Repeat Customers"
    description: "Count of all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

#haircare
  measure: sum_of_subscription_repeat_discounts_sub_at_repeat_customers_haircare {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers-Haircare"
    description: "all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_haircare: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

#supplements
  measure: sum_of_subscription_repeat_discounts_sub_at_repeat_customers_supplements {
    label: "Repeat Sub discounts by Subscribed at Repeat Customers-Supplements"
    description: "all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: sum_of_repeat_sub_at_repeat_discounts {
    label: "Repeat Sub discounts by Subscribed at Repeat Customers"
    description: "Sum of all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: sum_of_repeat_sub_at_repeat_discounts_haircare {
    label: "Repeat Sub discounts by Subscribed at Repeat Customers - Haircare"
    description: "Sum of all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_haircare: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: sum_of_repeat_sub_at_repeat_discounts_supplements {
    label: "Repeat Sub discounts by Subscribed at Repeat Customers - Supplements"
    description: "Sum of all sub-only repeat discounts placed by those who subscribed at a repeat order"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: repeat_sub_at_first_sub_discounts_churned_USD {
    label: "Repeat Sub discounts by Churned First Subscribied Customers - Supplements"
    description: "Sum of all sub-only repeat discounts placed by first subscribed churned customers"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: repeat_sub_at_repeat_sub_discounts_churned_USD {
    label: "Repeat Sub discounts by Churned Customers"
    description: "Sum of all sub-only repeat discounts placed by churned customers"
    type: sum_distinct
    sql:  ${total_discount_usd}  ;;
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
    drill_fields: [detail*]
    value_format_name: usd_0
    group_label: "Discount Values"
  }

  measure: cohort_finance_orders {
    type: number
    sql: CASE
        WHEN ${cohort_finance_name}  = "new_non_sub"
        THEN ${total_number_of_new_orders_not_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "new_sub_at_first"
      THEN ${total_number_of_new_orders_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "repeat_non_sub_orders"
      THEN ${total_number_of_nonsubscription_repeat_orders}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_first_only"
      THEN ${total_number_of_subscription_repeat_orders_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub"
      THEN ${total_repeat_sub_at_repeat_orders}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_supplements"
      THEN ${total_repeat_sub_at_repeat_orders_supplements}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_haircare"
      THEN ${total_repeat_sub_at_repeat_orders_haircare}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_haircare"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first_haircare}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_supplements"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first_supplements}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort"    -- grouping on report by sub_cohort ??
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_haircare"
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers_haircare}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_supplements"
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers_supplements}

      WHEN ${cohort_finance_name}  ="repeat_sub_at_repeat_orders_by_first_order_cohort"  --same as above, grouping different on report??
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"   -- best guess on this - need confirmation
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_churned_customers}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first_churned}

      else
      0 end ;;
  }

  measure: cohort_finance_discounts {
    type: number
    value_format_name: usd_0
    sql: CASE
      WHEN ${cohort_finance_name}  = "new_non_sub"
      THEN ${total_number_of_new_discounts_not_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "new_sub_at_first"
      THEN ${total_number_of_new_discounts_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "repeat_non_sub_orders"
      THEN ${total_number_of_nonsubscription_repeat_discounts}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_first_only"
      THEN ${total_number_of_subscription_repeat_discounts_subscribed_at_first}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub"
      THEN ${sum_of_repeat_sub_at_repeat_discounts}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_supplements"
      THEN ${sum_of_repeat_sub_at_repeat_discounts_supplements}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_haircare"
      THEN ${sum_of_repeat_sub_at_repeat_discounts_haircare}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub"
      THEN ${total_number_of_subscription_repeat_discounts_subscribed_at_first}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_haircare"
      THEN ${total_number_of_repeat_subsciption_discounts_by_subscribed_at_first_haircare}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_supplements"
      THEN ${total_number_of_repeat_subsciption_discounts_by_subscribed_at_first_supplements}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort"    -- grouping on report by sub_cohort ??
      THEN ${sum_of_subscription_repeat_discounts_sub_at_repeat_customers}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_haircare"
      THEN ${sum_of_subscription_repeat_discounts_sub_at_repeat_customers_haircare}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_supplements"
      THEN ${sum_of_subscription_repeat_discounts_sub_at_repeat_customers_supplements}

      WHEN ${cohort_finance_name}  ="repeat_sub_at_repeat_orders_by_first_order_cohort"  --same as above, grouping different on report??
      THEN ${sum_of_subscription_repeat_discounts_sub_at_repeat_customers}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"   -- best guess on this - need confirmation
      THEN ${repeat_sub_at_repeat_sub_discounts_churned_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"
      THEN ${repeat_sub_at_first_sub_discounts_churned_USD}

      else
      0 end ;;
  }

  measure: cohort_finance_net_sales {
    value_format_name: usd_0
    type: number
    sql: CASE
      WHEN ${cohort_finance_name}  = "new_non_sub"
      THEN ${total_new_non_subscription_at_first_net_sales_USD}

      WHEN ${cohort_finance_name}  = "new_sub_at_first"
      THEN ${total_new_subscription_at_first_net_sales_USD}

      WHEN ${cohort_finance_name}  = "repeat_non_sub_orders"
      THEN ${total_repeat_nonsub_net_sales_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_first_only"
      THEN ${total_repeat_sub_at_first_net_sales_USD}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub"
      THEN ${total_repeat_sub_at_repeat_net_sales_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_supplements"
      THEN ${total_repeat_sub_at_repeat_net_sales_supplements_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub_haircare"
      THEN ${total_repeat_sub_at_repeat_net_sales_haircare_USD}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub"
      THEN ${total_repeat_sub_at_first_sub_net_sales_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_haircare"
      THEN ${total_repeat_sub_at_first_sub_net_sales_haircare_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub_supplements"
      THEN ${total_repeat_sub_at_first_sub_net_sales_supplements_USD}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort"    -- grouping on report by sub_cohort ??
      THEN ${total_repeat_subscription_net_sales_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_haircare"
      THEN ${total_repeat_subscription_net_sales_haircare_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort_supplements"
      THEN ${total_repeat_subscription_net_sales_supplements_USD}

      WHEN ${cohort_finance_name}  ="repeat_sub_at_repeat_orders_by_first_order_cohort"  --same as above, grouping different on report??
      THEN ${total_repeat_subscription_net_sales_USD}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"   -- best guess on this - need confirmation
      THEN ${total_repeat_subscription_net_sales_churned_USD}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"
      THEN ${total_repeat_sub_at_first_sub_net_sales_churned_USD}

      else
      0 end ;;
  }

  measure: cohort_finance_churned_customer_counts{
    type: number
    sql: CASE
            WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"   -- best guess on this - need confirmation
            THEN ${churned_customers_repeat_subsciption_orders_by_subscribed_at_first}
            WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"
            THEN ${churned_customers_repeat_subsciption_at_repeat}
      else
      0 end ;;
  }
}
