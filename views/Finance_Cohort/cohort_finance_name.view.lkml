view: cohort_finance_name {
  derived_table: {
    sql:
     Select "repeat_sub_at_first_orders_non_sub_supplements" as cohort_finance_name
     union all
     Select  "repeat_sub_at_first_orders_sub_haircare" as cohort_finance_name
     union all
     Select "repeat_sub_at_first_orders_non_sub_haircare" as cohort_finance_name
     union all
     Select "repeat_sub_at_first_orders_sub_supplements" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_churned_customers" as cohort_finance_name
     union all
     Select "repeat_sub_at_first_churned_customers" as cohort_finance_name
     union all
     Select "new_non_sub" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_orders_first_only" as cohort_finance_name
     union all
     Select "repeat_non_sub_orders" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_orders_by_sub_cohort" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_orders_by_sub_cohort_supplements" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_orders_by_sub_cohort_haircare" as cohort_finance_name
     union all
     Select "repeat_sub_at_first_orders_non_sub" as cohort_finance_name
     union all
     Select "repeat_sub_at_first_orders_sub" as cohort_finance_name
     union all
     Select "repeat_sub_at_repeat_orders_by_first_order_cohort" as cohort_finance_name
     union all
     Select "new_sub_at_first" as cohort_finance_name
    ;;
  }
  dimension: cohort_finance_name {
    primary_key: yes
    type: string
    sql: ${TABLE}.cohort_finance_name ;;
    html: @{proper_case_snakecase} ;;
  }
}
