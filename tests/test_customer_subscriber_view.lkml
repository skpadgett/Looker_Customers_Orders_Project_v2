test: customer_subscriber_order_pubkey_is_not_null {
  explore_source: customer_subscriber {
    column: order_pubkey {}
  }
  assert: order_pubkey_is_not_null {
    expression: NOT is_null(${customer_subscriber.order_pubkey}) ;;
  }
}

test: customer_subscriber_customer_pubkey_is_not_null {
  explore_source: customer_subscriber {
    column: customer_pubkey {}
  }
  assert: customer_pubkey_is_not_null {
    expression: NOT is_null(${customer_subscriber.customer_pubkey}) ;;
  }
}

test: customer_subscriber_first_order_date_company_at_tz_ny_is_not_null {
  explore_source: customer_subscriber {
    column: first_order_date_company_at_tz_ny_date {}
    sorts: [dag_ts_utc: desc]
    limit: 1000
  }
  assert: first_order_date_company_at_tz_ny_is_not_null {
    expression: NOT is_null(${customer_subscriber.first_order_date_company_at_tz_ny_date}) ;;
  }
}

test: customer_subscriber_first_order_date_hair_category_greater_or_equal_company {
  explore_source: customer_subscriber {
    column: first_order_date_hair_at_tz_ny_date {}
    column: first_order_date_company_at_tz_ny_date {}
    filters: {
      field: customer_subscriber.first_order_date_hair_at_tz_ny_date
      value: "-NULL"
    }
    sorts: [dag_ts_utc: desc]
    limit: 1000
  }
  assert: first_order_date_hair_category_greater_or_equal_company {
    expression: (${customer_subscriber.first_order_date_hair_at_tz_ny_date} >= ${customer_subscriber.first_order_date_company_at_tz_ny_date}) ;;
  }
}

test: customer_subscriber_first_order_date_sub_greater_or_equal_company {
  explore_source: customer_subscriber {
    column: first_sub_order_date_company_at_tz_ny_date {}
    column: first_order_date_company_at_tz_ny_date {}
    filters: {
      field: customer_subscriber.first_sub_order_date_company_at_tz_ny_date
      value: "-NULL"
    }
    sorts: [dag_ts_utc: desc]
    limit: 1000
  }
  assert: first_order_date_hair_category_greater_or_equal_company {
    expression: (${customer_subscriber.first_sub_order_date_company_at_tz_ny_date} >= ${customer_subscriber.first_order_date_company_at_tz_ny_date}) ;;
  }
}

test: customer_subscriber_first_order_date_non_sub_greater_or_equal_company {
  explore_source: customer_subscriber {
    column: first_non_sub_order_date_company_at_tz_ny_date {}
    column: first_order_date_company_at_tz_ny_date {}
    filters: {
      field: customer_subscriber.first_non_sub_order_date_company_at_tz_ny_date
      value: "-NULL"
    }
    sorts: [dag_ts_utc: desc]
    limit: 1000
  }
  assert: first_order_date_hair_category_greater_or_equal_company {
    expression: (${customer_subscriber.first_non_sub_order_date_company_at_tz_ny_date} >= ${customer_subscriber.first_order_date_company_at_tz_ny_date}) ;;
  }
}

test: customer_subscriber_gross_sales_company_greater_or_equal_hair_category {
  explore_source: customer_subscriber {
    column: first_order_date_company_at_tz_ny_year {}
    column: gross_sales_without_taxes_amount_USD {}
    column: gross_sales_without_taxes_amount_USD_hair {}
  }
  assert: gross_sales_company_greater_or_equal_hair_category {
    expression: (${customer_subscriber.gross_sales_without_taxes_amount_USD} >= ${customer_subscriber.gross_sales_without_taxes_amount_USD_hair}) ;;
  }
}

