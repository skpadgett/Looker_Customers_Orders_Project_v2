include: "/views/order_items.view.lkml"

view: order_items_cohort_extension {

  # View requires cross-join to cohort_finance_name


    extends: [order_items]


    dimension: cohort_finance_name {
      type: string
      hidden: yes
      sql:  ${cohort_finance_name.cohort_finance_name} ;;
    }


    measure: cohort_finance_units {
      type: number
      sql: CASE
        WHEN ${cohort_finance_name}  = "new_non_sub"
        THEN ${new_non_subscription_at_first_units}

        WHEN ${cohort_finance_name}  = "new_sub_at_first"
        THEN ${new_subscription_at_first_units}

        WHEN ${cohort_finance_name}  = "repeat_non_sub_orders"
        THEN ${repeat_nonsub_units}

        WHEN ${cohort_finance_name}  ="repeat_sub_at_repeat_orders_by_first_order_cohort"   --same as above, grouping different on report??
        THEN ${repeat_subscription_units}

        WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_first_only"
        THEN ${repeat_sub_at_first_units}

        WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_non_sub"
        THEN ${repeat_sub_at_first_orders_non_sub_units}

        WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub"
        THEN ${repeat_sub_at_first_sub_units}

        WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"  -- best guess on this - need confirmation
        THEN ${repeat_subscription_units_churned}

        WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"
        THEN ${repeat_sub_at_first_sub_units_churned}

        else
        0 end ;;
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


      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_orders_sub"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first}


      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_orders_by_sub_cohort"    -- grouping on report by sub_cohort ??
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers}


      WHEN ${cohort_finance_name}  ="repeat_sub_at_repeat_orders_by_first_order_cohort"  --same as above, grouping different on report??
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_customers}

      WHEN ${cohort_finance_name}  = "repeat_sub_at_repeat_churned_customers"   -- best guess on this - need confirmation
      THEN ${total_number_of_subscription_repeat_orders_sub_at_repeat_churned_customers}
      WHEN ${cohort_finance_name}  = "repeat_sub_at_first_churned_customers"
      THEN ${total_number_of_repeat_subsciption_orders_by_subscribed_at_first_churned}

      else
      0 end ;;
  }

  }
