test: order_last_synced_raw_recency_1_day {
    explore_source: order {
        column: last_synced_raw {}
        sorts: [last_synced_raw: desc]
        limit: 1
    }

    assert: last_synced_date_recency_1_day {
        expression: ${order.last_synced_raw} >= add_days(-1, now());;
    }
}

test: order_order_pubkey_is_unique {
    explore_source: order {
        column: order_pubkey {}
    }
    assert: order_pubkey_is_unique {
        expression: count_distinct(${order.order_pubkey}) = count(${order.order_pubkey});;
    }
}

test: order_order_pubkey_is_not_null {
    explore_source: order {
        column: order_pubkey {}
    }
    assert: order_pubkey_is_not_null {
        expression: NOT is_null(${order.order_pubkey}) ;;
    }
}

test: order_customer_pubkey_is_not_null {
    explore_source: order {
        column: customer_pubkey {}
    }
    assert: customer_pubkey_is_not_null {
        expression: NOT is_null(${order.customer_pubkey}) ;;
    }
}

test: order_order_date_at_tz_ny_is_not_null {
    explore_source: order {
        column: order_date_at_tz_ny_date {}
    }
    assert: order_date_at_tz_ny_is_not_null {
        expression: NOT is_null(${order.order_date_at_tz_ny_date}) ;;
    }
}

test: order_total_without_taxes_USD_is_accurate {
    explore_source: order {
        column: gross_sales_without_taxes_amount_USD {}
        column: total_discount_amount_USD {}
        column: total_net_sales_USD {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: total_without_taxes_USD_is_accurate {
        expression: round(${order.gross_sales_without_taxes_amount_USD} - ${order.total_discount_amount_USD}, 2) = round(${order.total_net_sales_USD}, 2);;
    }
}

test: order_order_conversion_rate_CAD_gross_sales_without_taxes_is_accurate {
    explore_source: order {
        column: order_conversion_rate {}
        column: gross_sales_without_taxes_amount {}
        column: gross_sales_without_taxes_amount_USD {}
        sorts: [last_synced_raw: desc]
        filters: [order.order_currency: "CAD"]
        limit: 1000
    }
    assert: order_conversion_rate_CAD_gross_sales_without_taxes_is_accurate {
        expression: round(${order.gross_sales_without_taxes_amount} / ${order.order_conversion_rate}, 2) = round(${order.gross_sales_without_taxes_amount_USD}, 2);;
    }
}

test: order_order_conversion_rate_CAD_total_net_sales_is_accurate {
    explore_source: order {
        column: order_conversion_rate {}
        column: total_net_sales {}
        column: total_net_sales_USD {}
        sorts: [last_synced_raw: desc]
        filters: [order.order_currency: "CAD"]
        limit: 1000
    }
    assert: order_conversion_rate_CAD_total_net_sales_is_accurate {
        expression: round(${order.total_net_sales} / ${order.order_conversion_rate}, 2) = round(${order.total_net_sales_USD}, 2);;
    }
}

test: order_order_currency_contains {
    explore_source: order {
        column: order_currency {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: last_subscription_status_company_contains {
        expression: contains(concat("USD", "CAD"), ${order.order_currency});;
    }
}

test: order_order_date_at_tz_ny_recency {
    explore_source: order {
        column: order_date_at_tz_ny_date {}
        column: first_order_date_at_tz_ny_date {}
        sorts: [last_synced_raw: desc]
        filters: [order.is_valid_sales_order: "Yes"]
        limit: 100
    }
    assert: order_order_date_at_tz_ny_recency {
        expression: ${order.order_date_at_tz_ny_date} >= ${order.first_order_date_at_tz_ny_date};;
    }
}

test: historic_total_number_orders_is_accurate_2020 {
    explore_source: order {
        column: total_number_orders {}
        filters: [order.order_date_at_tz_ny_year: "2020"]
        filters: [order.is_valid_sales_order: "Yes"]
    }
    assert: total_number_orders_is_accurate {
        expression: sum(${order.total_number_orders}) = 12345 ;;
    }
}

test: historic_total_number_orders_is_accurate_2021 {
    explore_source: order {
        column: total_number_orders {}
        filters: [order.order_date_at_tz_ny_year: "2021"]
        filters: [order.is_valid_sales_order: "Yes"]
    }
    assert: total_number_orders_is_accurate {
        expression: sum(${order.total_number_orders}) = 123456 ;;
    }
}

test: historic_total_number_of_placed_from_subscription_orders_is_accurate_2020 {
    explore_source: order {
        column: total_number_orders {}
        filters: [order.order_date_at_tz_ny_year: "2020"]
        filters: [order.is_valid_sales_order: "Yes"]
        filters: [order.is_order_placed_from_subscription: "Yes"]
    }
    assert: total_number_of_placed_from_subscription_orders_is_accurate {
        expression: ${order.total_number_orders} = 123456 ;;
    }
}

test: historic_total_number_of_placed_from_subscription_orders_is_accurate_2021 {
    explore_source: order {
        column: total_number_orders {}
        filters: [order.order_date_at_tz_ny_year: "2021"]
        filters: [order.is_valid_sales_order: "Yes"]
        filters: [order.is_order_placed_from_subscription: "Yes"]
    }
    assert: total_number_of_placed_from_subscription_orders_is_accurate {
        expression: ${order.total_number_orders} = 123456 ;;
    }
}

## All contains flag tests


test: order_contains_product_x_not_empty {
  explore_source: order {
    column: total_number_orders    {}
    filters: [order.order_contains_shampoo : "Yes"]
  }
  assert: order_contains_product_x_count_not_null {
    expression: ${order.total_number_orders} > 0 ;;
  }
}

