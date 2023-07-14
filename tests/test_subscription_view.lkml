
test: subscription_subscription_pubkey_is_not_null {
  explore_source: subscription {
    column: subscription_pubkey {}
  }
  assert: subscription_pubkey_is_not_null {
    expression: NOT is_null(${subscription.subscription_pubkey}) ;;
  }
}

test: subscription_customer_pubkey_is_not_null {
  explore_source: subscription {
    column: customer_pubkey {}
  }
  assert: customer_pubkey_is_not_null {
    expression: NOT is_null(${subscription.customer_pubkey}) ;;
  }
}

test: subscription_subscription_category_is_not_null {
  explore_source: subscription {
    column: subscription_category {}
  }
  assert: subscription_category_is_not_null {
    expression: NOT is_null(${subscription.subscription_category}) ;;
  }
}


test: subscription_subscription_sub_category_is_not_null {
  explore_source: subscription {
    column: subscription_sub_category {}
  }
  assert: subscription_category_sub_is_not_null {
    expression: NOT is_null(${subscription.subscription_sub_category}) ;;
  }
}

test: subscription_event_timestamp_at_recency_1_day {
  explore_source: subscription {
    column: event_timestamp {}
    sorts: [event_timestamp: desc]
    limit: 1
  }
  assert: event_timestamp_recency_1_day {
    expression: ${subscription.event_timestamp} >= add_days(-1, now());;
  }
}
