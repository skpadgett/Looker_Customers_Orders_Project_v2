test: customer_customer_pubkey_is_unique {
    explore_source: customer {
        column: customer_pubkey {}
    }
    assert: customer_pubkey_is_unique {
        expression: count_distinct(${customer.customer_pubkey}) = count(${customer.customer_pubkey});;
    }
}

test: customer_customer_pubkey_is_not_null {
    explore_source: customer {
        column: customer_pubkey {}
    }
    assert: customer_customer_pubkey_is_not_null {
        expression: NOT is_null(${customer.customer_pubkey}) ;;
    }
}

test: customer_last_synced_raw_recency_1_day {
    explore_source: customer {
        column: last_synced_raw {}
        sorts: [last_synced_raw: desc]
        limit: 1
    }
    assert: customer_last_synced_raw_recency_1_day {
        expression: ${customer.last_synced_raw} >= add_days(-1, now());;
    }
}

test: customer_last_subscription_status_company_contains {
    explore_source: customer {
        column: subscription_status_company {}
        sorts: [last_subscription_created_at_tz_ny_prose: desc]
        limit: 1000
    }
    assert: customer_last_subscription_status_company_contains {
        expression: contains(concat("active", "never-subscribed", "churned", "on-hold"), ${customer.subscription_status_company});;
    }
}

test: customer_customer_type_contains {
    explore_source: customer {
        column: customer_type {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: customer_last_subscription_status_company_contains {
        expression: contains(concat("Prospect", "Client_at_least_2_orders", "Client_1_order"), ${customer.customer_type});;
    }
}

test: historic_total_distinct_customers_is_accurate_2020 {
    explore_source: customer {
        column: total_distinct_customers {}
        filters: [customer.first_order_date_company_at_tz_ny_year: "2020"]
    }
    assert: historic_total_distinct_customers_is_accurate {
        expression: sum(${customer.total_distinct_customers}) = 327605 ;;
    }
}

test: historic_total_distinct_customers_is_accurate_2021 {
    explore_source: customer {
        column: total_distinct_customers {}
        filters: [customer.first_order_date_company_at_tz_ny_year: "2021"]
    }
    assert: historic_total_distinct_customers_is_accurate {
        expression: sum(${customer.total_distinct_customers}) = 426894 ;;
    }
}
