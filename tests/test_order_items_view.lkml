test: order_items_last_synced_raw_recency_1_day {
    explore_source: order_items {
        column: last_synced_raw {}
        sorts: [last_synced_raw: desc]
        limit: 1
    }
    assert: last_synced_raw_recency_1_day {
        expression: ${order_items.last_synced_raw} >= add_days(-1, now());;
    }
}

test: order_items_order_item_pubkey_is_unique {
    explore_source: order_items {
        column: order_item_pubkey {}
    }
    assert: order_item_pubkey_is_unique {
        expression: count_distinct(${order_items.order_item_pubkey}) = count(${order_items.order_item_pubkey});;
    }
}

test: order_items_order_item_pubkey_is_not_null {
    explore_source: order_items {
        column: order_item_pubkey {}
    }
    assert: order_item_pubkey_is_not_null {
        expression: NOT is_null(${order_items.order_item_pubkey});;
    }
}

test: order_items_order_pubkey_is_not_null {
    explore_source: order_items {
        column: order_pubkey {}
    }
    assert: order_pubkey_is_not_null {
        expression: NOT is_null(${order_items.order_pubkey});;
    }
}

test: order_items_customer_pubkey_is_not_null {
    explore_source: order_items {
        column: customer_pubkey {}
    }
    assert: customer_pubkey_is_not_null {
        expression: NOT is_null(${order_items.customer_pubkey});;
    }
}

test: order_items_sku_is_not_null {
    explore_source: order_items {
        column: sku {}
    }
    assert: sku_is_not_null {
        expression: NOT is_null(${order_items.sku});;
    }
}

test: order_items_item_type_contains {
    explore_source: order_items {
        column: item_type {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: item_type_contains {
        expression: contains(concat("formula", "gift_cards", "gwp", "loyalty_gift", "postcard", "tool"), ${order_items.item_type});;
    }
}

test: order_items_target_category_contains {
    explore_source: order_items {
        column: target_category {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: target_category_contains {
        expression: contains(concat("hair", "skin"), ${order_items.target_category});;
    }
}

test: order_items_target_sub_category_contains {
    explore_source: order_items {
        column: target_sub_category {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: target_sub_category_contains {
        expression: contains(concat("haircare", "supplements", "skincare"), ${order_items.target_sub_category});;
    }
}

test: order_items_product_target_category_contains {
    explore_source: order_items {
        column: product_target_category {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: product_target_category_contains {
        expression: contains(concat("hair", "gifts"), ${order_items.product_target_category});;
    }
}

test: order_items_product_target_sub_category_contains {
    explore_source: order_items {
        column: product_target_sub_category {}
        sorts: [last_synced_raw: desc]
        limit: 1000
    }
    assert: product_target_sub_category_contains {
        expression: contains(concat("gift_cards", "hair_styling", "hair_supplements", "hair_treatment", "haircare", "tools_accessories"), ${order_items.product_target_sub_category});;
    }
}
