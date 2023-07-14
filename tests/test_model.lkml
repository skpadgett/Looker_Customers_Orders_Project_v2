test: order_join_customer_pubkey_validate {
  explore_source: order {
    column: order_customer_pubkey {
      field: order.customer_pubkey
    }
    column: customer_customer_pubkey {
      field: customer.customer_pubkey
    }
    limit: 1000
  }
  assert: order_join_customer_pubkey_validate {
    expression: ${order.customer_pubkey} = ${customer.customer_pubkey} ;;
  }
}

test: order_join_customer_pubkey_yealy_distinct_count {
  explore_source: order {
    column: order_date_at_tz_ny_year {}
    column: customer_distinct_customer_count {
      field:  customer.total_distinct_customers
    }
    column: order_distinct_customer_count {
      field: order.distinct_customer_count
    }
  }
  assert: order_join_customer_pubkey_yealy_distinct_count {
    expression: ${order.distinct_customer_count} = ${customer.total_distinct_customers} ;;
  }
}

test: order_items_join_customer_pubkey_validate {
  explore_source: order_items {
    column: order_items_customer_pubkey {
      field: order_items.customer_pubkey
    }
    column: customer_customer_pubkey {
      field: customer.customer_pubkey
    }
    limit: 1000
  }
  assert: order_items_join_customer_pubkey_validate {
    expression: ${order_items.customer_pubkey} = ${order_items.customer_pubkey} ;;
  }
}