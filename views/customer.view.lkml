#### DESCRIPTION --------------------------------------------------------------------------------------------------------------------

# This view pulls data from the customer data mart.

view: customer {

  sql_table_name: `customer.customer_bi_datamart_growth_customer_ltv_customer_order.customer`
    ;;

#### SETS --------------------------------------------------------------------------------------------------------------------

  set: detail {
    fields: [customer_pubkey, last_order_shipping_country, last_order_shipping_state_abbvr]
  }

#### DIMENSIONS --------------------------------------------------------------------------------------------------------------------

  dimension: active_subscription_products {
    type:  string
    sql: ${TABLE}.active_subscription_products ;;
  }

  dimension: category_currently_subscribed_count {
    hidden: yes
    type: number
    sql: ${TABLE}.category_currently_subscribed_count ;;
  }

  dimension: category_ever_subscribed_count {
    hidden: yes
    type: number
    sql: ${TABLE}.category_ever_subscribed_count ;;
  }

  dimension: customer_net_ltv {
    label: "Customer Lifetime Net Sales"
    type: number
    sql: ${TABLE}.customer_net_ltv ;;
  }

  dimension: customer_order_count {
    label: "Customer Lifetime Order Count"
    type: number
    sql: ${TABLE}.customer_order_count ;;
  }

  dimension: customer_origin {
    label: "Customer Post-Purchase Survey Channel"
    type: string
    sql: ${TABLE}.customer_origin ;;
  }

  dimension: customer_type {
    type: string
    sql: ${TABLE}.customer_type ;;
  }

  dimension: first_order_purchased_category_count {
    hidden: yes
    type: number
    sql: ${TABLE}.first_order_purchased_category_count ;;
  }

  dimension: first_order_purchased_product_count {
    hidden: yes
    type: number
    sql: ${TABLE}.first_order_purchased_product_count ;;
  }

  dimension: number_of_subscription_snoozed {
    type: number
    sql: ${TABLE}.number_of_subscription_snoozed ;;
  }

  dimension: product_currently_subscribed_count {
    type: number
    hidden: yes
    sql: ${TABLE}.product_currently_subscribed_count ;;
  }

  dimension: product_ever_subscribed_count {
    type: number
    hidden: yes
    sql: ${TABLE}.product_ever_subscribed_count ;;
  }

  dimension: purchased_category_upsold_since_first_order {
    type: number
    hidden: yes
    sql: ${TABLE}.purchased_category_upsold_since_first_order ;;
  }

  dimension: subscription_orders_per_year {
    type: number
    sql: ${TABLE}.subscription_orders_per_year ;;
  }

  dimension: last_is_first_order {
    type: string
    sql: CASE ${TABLE}.first_order_pubkey WHEN ${TABLE}.last_order_pubkey THEN "Yes"
      ELSE "No" END;;
  }

  dimension: days_between_signup_and_first_order {
    type:  number
    sql: ${TABLE}.days_between_signup_and_first_order ;;
  }

  ## Beginning of on hold dimensions

  dimension: subscription_onhold_reason_hair {
    type:  string
    sql:  ${TABLE}.subscription_onhold_reason_hair ;;
    group_label: "On Hold Reasons"
  }

  dimension: subscription_onhold_reason_haircare {
    type:  string
    sql:  ${TABLE}.subscription_onhold_reason_haircare ;;
    group_label: "On Hold Reasons"
  }

  dimension: subscription_onhold_reason_skincare {
    type:  string
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN "@{mock_string}" END ;;
    group_label: "On Hold Reasons"
  }

  dimension: subscription_onhold_reason_supplements {
    type:  string
    sql:  ${TABLE}.subscription_onhold_reason_supplements ;;
    group_label: "On Hold Reasons"
  }

  ## End of on hold dimensions

  ## Beginning of customer origin first order dimensions

  dimension: customer_category_origin_first_skin_order {
    type: string
    group_label: "@{customer_origin_first_order}"
    group_item_label: "@{customer_origin_first_order} Skin"
  }

  dimension: customer_category_origin_first_skincare_order {
    type: string
    group_label: "@{customer_origin_first_order}"
    group_item_label: "@{customer_origin_first_order} Skincare"
  }

  dimension: customer_category_origin_first_hair_order {
    type: string
    group_label: "@{customer_origin_first_order}"
    group_item_label: "@{customer_origin_first_order} Hair"
  }

  dimension: customer_category_origin_first_haircare_order {
    type: string
    group_label: "@{customer_origin_first_order}"
    group_item_label: "@{customer_origin_first_order} Haircare"
  }

  dimension: customer_category_origin_first_supp_order {
    type: string
    group_label: "@{customer_origin_first_order}"
    group_item_label: "@{customer_origin_first_order} Supplements"
  }

  ## End of customer origin first order dimensions

  ## Beginning of customer subscribed product flags dimensions

  dimension: currently_subscribes_to_conditioner {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_conditioner ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_curl_cream {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_curl_cream ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_dry_shampoo {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_dry_shampoo ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_hair_mask {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_hair_mask ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_hair_oil {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_hairoil ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_leavin {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_leavin ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_leavein_conditionner {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_leavein_conditioner ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_scalp_mask {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_scalp_mask ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_shampoo {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_haircare_shampoo ;;
    group_label: "Currently Subscribed Product Flags"
  }

  dimension: currently_subscribes_to_supplement_core {
    type: yesno
    sql: ${TABLE}.currently_subscribes_to_supplements_supplement_core ;;
    group_label: "Currently Subscribed Product Flags"
  }

  ## End of customer subscribed product flags dimensions

  ## Beginning of customer info dimensions

  dimension: customer_age_range {
    type: string
    sql: ${TABLE}.customer_age_range ;;
    group_label: "Customer Info"
  }

  dimension: customer_email_sha256 {
    type: string
    sql: ${TABLE}.customer_email_sha256 ;;
    group_label: "Customer Info"
    hidden: yes
  }

  dimension: customer_first_name {
    type: string
    sql: ${TABLE}.customer_first_name ;;
    group_label: "Customer Info"
  }

  dimension: customer_hair_texture_type {
    type: string
    sql: ${TABLE}.customer_hair_texture_type ;;
    group_label: "Customer Info"
  }

  dimension: customer_pubkey {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.customer_pubkey ;;
    group_label: "Customer Info"
  }

  ## End of customer info dimensions

  ## Beginning of product subscription frequency flag dimensions

  dimension: declared_product_frequency_conditioner  {
    type: number
    sql: ${TABLE}.declared_product_frequency_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_curl_cream{
    type: number
    sql: ${TABLE}.declared_product_frequency_curl_cream ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_dry_shampoo {
    type: number
    sql: ${TABLE}.declared_product_frequency_dry_shampoo;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_hair_mask {
    type: number
    sql: ${TABLE}.declared_product_frequency_hair_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_hairoil {
    type: number
    sql: ${TABLE}.declared_product_frequency_hairoil ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_leavein_conditioner {
    type: number
    sql: ${TABLE}.declared_product_frequency_leavein_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_scalp_mask {
    type: number
    sql: ${TABLE}.declared_product_frequency_scalp_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_shampoo {
    type: number
    sql: ${TABLE}.declared_product_frequency_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: declared_product_frequency_supplement_core {
    type: number
    sql: ${TABLE}. ;;
    group_label: "Product Subscription Frequency Flags"
  }

  ## End of product subscription frequency flag dimensions

  ## Beginning of first order flag dimensions

  dimension: discount_code_at_first_order {
    type:  string
    sql: ${TABLE}.discount_code_at_first_order ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_product {
    type: string
    sql: CASE WHEN ${first_order_contains_brush} is true AND ${first_order_purchased_product_count} = 1 THEN 'Brush'
              WHEN ${first_order_contains_conditioner} is true AND ${first_order_purchased_product_count} = 1 THEN 'Conditioner'
              WHEN  ${first_order_contains_curl_cream} is true AND ${first_order_purchased_product_count} = 1 THEN 'Curl Cream'
              WHEN ${first_order_contains_dry_shampoo}  is true AND ${first_order_purchased_product_count} = 1 THEN 'Dry Shampoo'
              WHEN ${first_order_contains_haircare} is true AND ${first_order_purchased_product_count} = 1 THEN 'Hair Care'
              WHEN ${first_order_contains_shampoo} is true AND ${first_order_purchased_product_count} = 1 THEN 'Shampoo'
              WHEN (
                ${first_order_contains_supplement_core} IS TRUE OR ${first_order_contains_supplement_booster} IS TRUE)
                AND ${first_order_purchased_product_count} = 1
              THEN 'Supplements' ELSE 'Multiple Products' END;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_brush {
    type: yesno
    sql: ${TABLE}.first_order_contains_brush ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_conditioner {
    type: yesno
    sql: ${TABLE}.first_order_contains_conditioner ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_curl_cream {
    type: yesno
    sql: ${TABLE}.first_order_contains_curl_cream ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_dry_shampoo {
    type: yesno
    sql: ${TABLE}.first_order_contains_dry_shampoo ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_hair_mask {
    type: yesno
    sql: ${TABLE}.first_order_contains_hair_mask ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_haircare {
    type: yesno
    sql: ${TABLE}.first_order_contains_haircare ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_skincare {
    label: "First Order Contains Skincare"
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_skin {
    label: "First Order Contains Skin"
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_hairoil {
    label: "First Order Contains Hair Oil"
    type: yesno
    sql: ${TABLE}.first_order_contains_hairoil ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_leavein_conditioner {
    type: yesno
    sql: ${TABLE}.first_order_contains_leavein_conditioner ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_scalp_mask {
    type: yesno
    sql: ${TABLE}.first_order_contains_scalp_mask ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_shampoo {
    type: yesno
    sql: ${TABLE}.first_order_contains_shampoo ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_shimmer_hairoil {
    label: "First Order Contains Shimmer Hair Oil"
    type: yesno
    sql: ${TABLE}.first_order_contains_shimmer_hairoil ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_styling_gel {
    label: "First Order Contains Styling Gel"
    type: yesno
    sql: ${TABLE}.first_order_contains_styling_gel ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_supplement_core {
    label: "First Order Contains Supplement Core"
    type: yesno
    sql: ${TABLE}.first_order_contains_supplement_core ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_contains_supplement_booster {
    label: "First Order Contains Supplement Booster"
    type: yesno
    sql: ${TABLE}.first_order_contains_supplement_booster ;;
    group_label: "First Order Flags"
  }

  dimension: first_order_purchased_with_discount {
    hidden: yes
    type: yesno
    sql: ${TABLE}.first_order_purchased_with_discount ;;
    group_label: "First Order Flags"
  }

  ## End of first order flag dimensions

  ## Beginning of first order address dimensions

  dimension: first_order_shipping_city {
    type: string
    sql: ${TABLE}.first_order_shipping_city ;;
    group_label: "First Order Address"
  }

  dimension: first_order_shipping_country {
    type: string
    sql: ${TABLE}.first_order_shipping_country ;;
    group_label: "First Order Address"
  }

  dimension: first_order_shipping_division {
    type: string
    sql: ${TABLE}.first_order_shipping_division ;;
    group_label: "First Order Address"
  }

  dimension: first_order_shipping_region {
    type: string
    sql: ${TABLE}.first_order_shipping_region ;;
    group_label: "First Order Address"
  }

  dimension: first_order_shipping_state_abbvr {
    type: string
    sql: ${TABLE}.first_order_shipping_state_abbvr ;;
    map_layer_name: us_states
    group_label: "First Order Address"
    link: {
      label: "{{value}} Lookup Dashboard"
      url: "/dashboards/8?Order+Shipping+State={{ value | encode_uri }}"
      icon_url: "https://www.seekpng.com/png/full/138-1386046_google-analytics-integration-analytics-icon-blue-png.png"
    }
  }

  dimension: first_order_shipping_state {
    type: string
    sql: ${TABLE}.first_order_shipping_state ;;
    group_label: "First Order Address"
  }

  dimension: first_order_shipping_zipcode {
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.first_order_shipping_zipcode ;;
    group_label: "First Order Address"
  }

  ## End of first order address dimensions

  ## Beginning of has ever purchased flag dimensions

  dimension: has_ever_purchased_brush {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_brush ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_conditioner {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_conditioner ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_curl_cream {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_curl_cream ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_dry_shampoo {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_dry_shampoo ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_hair_mask {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_hair_mask ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_haircare {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_haircare ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_hair {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_hair ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_skincare {
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_hairoil {
    label: "Has Ever Purchased Hair Oil"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_hairoil ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_leavein_conditioner {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_leavein_conditioner ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_scalp_mask {
    type: yesno
    sql: ${TABLE}.has_ever_purchased_scalp_mask ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_shampoo {
    label: "Has Ever Purchased Shampoo"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_shampoo ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_shimmer_hairoil {
    label: "Has Ever Purchased Shimmer Hair Oil"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_shimmer_hairoil ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_styling_gel {
    label: "Has Ever Purchased Styling Gel Hair Oil"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_styling_gel ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_supplements {
    label: "Has Ever Purchased Supplements"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_supplements ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_supplement_booster {
    label: "Has Ever Purchased Supplement booster"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_supplement_booster ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_purchased_supplement_core {
    label: "Has Ever Purchased Supplement core"
    type: yesno
    sql: ${TABLE}.has_ever_purchased_supplement_core ;;
    group_label: "Has Ever Purchased Flags"
  }

  dimension: has_ever_subscribed_company {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_customer ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_hair {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_hair ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_haircare {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_haircare ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_skincare {
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_supplements {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_supplements ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_conditioner {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_conditioner ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_curl_cream {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_curl_cream ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_dry_shampoo {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_dry_shampoo ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_hair_mask {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_hair_mask ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_hairoil {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_hairoil ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_leavin {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_leavin ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_leavein_conditioner {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_leavein_conditioner ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_scalp_mask {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_scalp_mask ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_shampoo {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_shampoo ;;
    group_label: "Has Ever Subscribed Flags"
  }

  dimension: has_ever_subscribed_to_supplement_core {
    type: yesno
    sql: ${TABLE}.has_ever_subscribed_to_supplement_core ;;
    group_label: "Has Ever Subscribed Flags"
  }

  ## End of has ever purchased flag dimensions

  ## Beginning of winback flag dimensions

  dimension: is_customer_subscription_winback_company {
    type: yesno
    sql: ${TABLE}.is_customer_subscription_winback_customer ;;
    group_label: "Winback Flags"
  }

  dimension: is_customer_subscription_winback_hair {
    type: yesno
    sql: ${TABLE}.is_customer_subscription_winback_hair ;;
    group_label: "Winback Flags"
  }

  dimension: is_customer_subscription_winback_haircare {
    type: yesno
    sql: ${TABLE}.is_customer_subscription_winback_haircare ;;
    group_label: "Winback Flags"
  }

  dimension: is_customer_subscription_winback_skincare {
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "Winback Flags"
  }

  dimension: is_customer_subscription_winback_supplements {
    type: yesno
    sql: ${TABLE}.is_customer_subscription_winback_supplements ;;
    group_label: "Winback Flags"
  }

  ## End of winback flag dimensions

  ## Beginning of subscription at first order flag dimensions

  dimension: is_subscription_at_first_order_company {
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order_customer ;;
    group_label: "Subscription at First Order Flags"
  }

  dimension: is_subscription_at_first_order_hair {
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order_hair ;;
    group_label: "Subscription at First Order Flags"
  }

  dimension: is_subscription_at_first_order_haircare {
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order_haircare ;;
    group_label: "Subscription at First Order Flags"
  }

  dimension: is_subscription_at_first_order_skincare {
    type: yesno
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN @{mock_boolean} END ;;
    group_label: "Subscription at First Order Flags"
  }

  dimension: is_subscription_at_first_order_supplements {
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order_supplements ;;
    group_label: "Subscription at First Order Flags"
  }

  ## End of subscription at first order flag dimensions

  ## Beginning of last order contains flag dimensions

  dimension: last_order_contains_brush {
    type: yesno
    sql: ${TABLE}.last_order_contains_brush ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_conditioner {
    type: yesno
    sql: ${TABLE}.last_order_contains_conditioner ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_curl_cream {
    type: yesno
    sql: ${TABLE}.last_order_contains_curl_cream ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_dry_shampoo {
    type: yesno
    sql: ${TABLE}.last_order_contains_dry_shampoo ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_hair_mask {
    type: yesno
    sql: ${TABLE}.last_order_contains_hair_mask ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_hairoil {
    label: "Last Order Contains Hair Oil"
    type: yesno
    sql: ${TABLE}.last_order_contains_hairoil ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_leavein_conditioner {
    type: yesno
    sql: ${TABLE}.last_order_contains_leavein_conditioner ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_scalp_mask {
    type: yesno
    sql: ${TABLE}.last_order_contains_scalp_mask ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_shampoo {
    type: yesno
    sql: ${TABLE}.last_order_contains_shampoo ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_shimmer_hairoil {
    label: "Last Order Contains Shimmer Hair Oil"
    type: yesno
    sql: ${TABLE}.last_order_contains_shimmer_hairoil ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_styling_gel {
    label: "Last Order Contains Styling Gel"
    type: yesno
    sql: ${TABLE}.last_order_contains_styling_gel ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_supplements {
    type: yesno
    sql: ${TABLE}.last_order_contains_supplements ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_supplement_booster {
    type: yesno
    sql: ${TABLE}.last_order_contains_supplement_booster ;;
    group_label: "Last Order Contains Flags"
  }

  dimension: last_order_contains_supplement_core {
    type: yesno
    sql: ${TABLE}.last_order_contains_supplement_core ;;
    group_label: "Last Order Contains Flags"
  }

  ## End of last order contains flag dimensions

  ## Beginning of last order address dimensions

  dimension: last_order_shipping_city {
    type: string
    sql: ${TABLE}.last_order_shipping_city ;;
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_country {
    type: string
    sql: ${TABLE}.last_order_shipping_country ;;
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_division {
    type: string
    sql: ${TABLE}.last_order_shipping_division ;;
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_region {
    type: string
    sql: ${TABLE}.last_order_shipping_region ;;
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_state_abbvr {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.last_order_shipping_state_abbvr ;;
    drill_fields: [last_order_shipping_zipcode]
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_state {
    type: string
    sql: ${TABLE}.last_order_shipping_state ;;
    group_label: "Last Order Address"
  }

  dimension: last_order_shipping_zipcode {
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.last_order_shipping_zipcode ;;
    group_label: "Last Order Address"
  }

  ## End of last order address dimensions

  ## Beginning of last subscription cancellation reason dimensions

  dimension: last_subscription_cancellation_reason_haircare {
    hidden: yes
    type: string
    sql: ${TABLE}.last_subscription_cancellation_reason_haircare ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  dimension: last_subscription_cancellation_reason_skincare {
    hidden: yes
    type: string
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN "@{mock_string}" END ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  dimension: last_subscription_cancellation_reason_supplements {
    hidden: yes
    type: string
    sql: ${TABLE}.last_subscription_cancellation_reason_supplements ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  dimension: last_subscription_cancellation_source_haircare {
    hidden: yes
    type: string
    sql: ${TABLE}.last_subscription_cancellation_source_haircare ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  dimension: last_subscription_cancellation_source_skincare {
    hidden: yes
    type: string
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN "@{mock_string}" END ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  dimension: last_subscription_cancellation_source_supplements {
    hidden: yes
    type: string
    sql: ${TABLE}.last_subscription_cancellation_source_supplements ;;
    group_label: "Last Subscription Cancellation Reasons"
  }

  ## End of last subscription cancellation reason dimensions

  ## Beginning of product subscription frequency flags dimensions

  dimension: longest_subscription_frequency_conditioner {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_curl_cream {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_curl_cream ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_dry_shampoo {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_dry_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_hair_mask {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_hair_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_hairoil {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_hairoil ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_leavein_conditioner {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_leavein_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_scalp_mask {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_scalp_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_shampoo {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: longest_subscription_frequency_supplement_core {
    type: number
    sql: ${TABLE}.longest_subscription_frequency_supplement_core ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_conditioner {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_curl_cream{
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_curl_cream ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_dry_shampoo {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_dry_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_hair_mask {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_hair_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_hairoil {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_hairoil ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_leavein_conditioner {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_leavein_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_scalp_mask {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_scalp_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_shampoo {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: number_of_subscription_frequency_ever_selected_supplement_core {
    type: number
    sql: ${TABLE}.number_of_subscription_frequency_ever_selected_supplement_core ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_conditioner{
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_curl_cream {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_curl_cream ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_dry_shampoo {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_dry_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_hair_mask {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_hair_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_hairoil{
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_hairoil ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_leavein_conditioner {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_leavein_conditioner ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_scalp_mask {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_scalp_mask ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_shampoo {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_shampoo ;;
    group_label: "Product Subscription Frequency Flags"
  }

  dimension: shortest_subscription_frequency_supplement_core {
    type: number
    sql: ${TABLE}.shortest_subscription_frequency_supplement_core;;
    group_label: "Product Subscription Frequency Flags"
  }

  ## End of product subscription frequency flags dimensions

  ## Beginning of theoretical subscription product number dimensions

  dimension: subscription_products_per_year_conditioner {
    type: number
    sql: ${TABLE}.subscription_products_per_year_conditioner ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_curl_cream {
    type: number
    sql: ${TABLE}.subscription_products_per_year_curl_cream ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_dry_shampoo {
    type: number
    sql: ${TABLE}.subscription_products_per_year_dry_shampoo ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_hair_mask {
    type: number
    sql: ${TABLE}.subscription_products_per_year_hair_mask ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_hairoil {
    type: number
    sql: ${TABLE}.subscription_products_per_year_hairoil ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_leavein_conditioner {
    type: number
    sql: ${TABLE}.subscription_products_per_year_leavein_conditioner ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_scalp_mask{
    type: number
    sql: ${TABLE}.subscription_products_per_year_scalp_mask ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_shampoo {
    type: number
    sql: ${TABLE}.subscription_products_per_year_shampoo ;;
    group_label: "Theoretical Subscription Product Number"
  }

  dimension: subscription_products_per_year_supplement_core {
    type: number
    sql: ${TABLE}.subscription_products_per_year_supplement_core ;;
    group_label: "Theoretical Subscription Product Number"
  }

  ## End of theoretical subscription product number dimensions

  ## Beginning of current subscription status dimensions

  dimension: subscription_status_company {
    type: string
    sql: ${TABLE}.subscription_status_customer ;;
    group_label: "Current Subscription Status"
  }

  dimension: subscription_status_hair {
    type: string
    sql: ${TABLE}.subscription_status_hair ;;
    group_label: "Current Subscription Status"
  }

  dimension: subscription_status_haircare {
    type: string
    sql: ${TABLE}.subscription_status_haircare ;;
    group_label: "Current Subscription Status"
  }

  dimension: subscription_status_skincare {
    type: string
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN "@{mock_string}" END ;;
    group_label: "Current Subscription Status"
  }

  dimension: subscription_status_supplements {
    type: string
    sql: ${TABLE}.subscription_status_supplements ;;
    group_label: "Current Subscription Status"
  }

  ## End of current subscription status dimensions

  ## Beginning of latest product satisfaction dimensions

  dimension: feedback_product_hair_oil_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_hair_oil_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_conditioner_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_conditioner_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_curl_cream_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_curl_cream_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_dry_shampoo_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_dry_shampoo_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_hair_mask_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_hair_mask_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_leavein_conditioner_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_leavein_conditioner_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_scalp_mask_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_scalp_mask_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }
  dimension: feedback_product_shampoo_satisfaction {
    type:  number
    sql: ${TABLE}.feedback_product_shampoo_satisfaction ;;
    group_label: "Latest Product Satisfaction"
  }

  ## End of latest product satisfaction dimensions

#### DIMENSION GROUPS --------------------------------------------------------------------------------------------------------------------

  dimension_group: last_synced {
    description: "This field gives the last synced metadata for the customer mart.
    This is used in the last_synced explore to provide last synced metadata for all datamarts throughout Pandera-developed dashboards"
    hidden: yes
    type: time
    timeframes: [
      raw,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dag_ts_utc;;
  }

  dimension_group: first_order_date_company_at_tz_ny {
    label: "First Order - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_order_date_company_at_tz_ny ;;
  }

  dimension_group: first_order_date_haircare_at_tz_ny {
    label: "First Order Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_order_date_at_tz_ny_haircare ;;
  }

  dimension_group: first_order_date_skincare_at_tz_ny {
    label: "First Order Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
  }

  dimension_group: first_order_date_supplements_at_tz_ny {
    label: "First Order Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_order_date_at_tz_ny_supplements ;;
  }

  dimension_group: first_order_date_hair_at_tz_ny {
    label: "First Order Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.first_order_date_at_tz_ny_hair ;;
  }

  dimension_group: first_snooze_date_ny_tz {
    label: "First Snooze"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_snooze_date_ny_tz ;;
  }

  dimension_group: first_subscription_canceled_at_company_tz_ny {
    label: "First Subscription Canceled at Date - Company - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_canceled_at_tz_ny_customer ;;
  }

  dimension_group: first_subscription_canceled_at_hair_tz_ny {
    label: "First Subscription Canceled at Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_canceled_at_tz_ny_hair ;;
  }

  dimension_group: first_subscription_canceled_at_haircare_tz_ny {
    label: "First Subscription Canceled at Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_canceled_at_tz_ny_haircare ;;
  }

  dimension_group: first_subscription_canceled_at_skincare_tz_ny {
    label: "First Subscription Canceled at Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
    hidden: yes
  }

  dimension_group: first_subscription_canceled_at_supplements_tz_ny {
    label: "First Subscription Canceled at Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_canceled_at_tz_ny_supplements ;;
  }

  dimension_group: first_subscription_created_at_company_tz_ny {
    label: "First Subscription Created at Date - Company - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_created_at_tz_ny_customer ;;
  }

  dimension_group: first_subscription_created_at_hair_tz_ny {
    label: "First Subscription Created at Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_created_at_tz_ny_hair ;;
    hidden: yes
  }

  dimension_group: first_subscription_created_at_haircare_tz_ny {
    label: "First Subscription Created at Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_subscription_created_at_tz_ny_haircare ;;
    hidden: yes
  }

  dimension_group: first_subscription_created_at_skincare_tz_ny {
    label: "First Subscription Created at Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
    hidden: yes
  }

  dimension_group: first_subscription_created_at_supplements_tz_ny {
    label: "First Subscription Created at Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.first_subscription_created_at_tz_ny_supplements ;;
  }

  dimension_group: last_customer_subscription_winback_company_at_tz_ny {
    label: "Last Subscription Winback Date - Company - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_customer_subscription_winback_tz_ny_customer ;;
  }

  dimension_group: last_customer_subscription_winback_hair_at_tz_ny {
    label: "Last Subscription Winback Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_customer_subscription_winback_tz_ny_hair ;;
  }

  dimension_group: last_customer_subscription_winback_haircare_at_tz_ny {
    label: "Last Subscription Winback Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_customer_subscription_winback_tz_ny_haircare ;;
  }

  dimension_group: last_customer_subscription_winback_skincare_at_tz_ny {
    label: "Last Subscription Winback Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
  }

  dimension_group: last_customer_subscription_winback_supplements_at_tz_ny {
    label: "Last Subscription Winback Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_customer_subscription_winback_tz_ny_supplements ;;
  }

  dimension_group: last_order_date_company_at_tz_ny {
    label: "Last Order - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_order_date_company_at_tz_ny ;;
  }

  dimension_group: last_snooze_date_ny_tz {
    label: "Last Snooze"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_snooze_date_ny_tz ;;
  }

  dimension_group: last_subscription_canceled_at_company_tz_ny {
    label: "Last Subscription Canceled - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_subscription_canceled_at_tz_ny_customer ;;
  }

  dimension_group: last_subscription_canceled_at_hair_tz_ny {
    label: "Last Subscription Canceled Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_canceled_at_tz_ny_hair ;;
  }

  dimension_group: last_subscription_canceled_at_haircare_tz_ny {
    label: "Last Subscription Canceled Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_canceled_at_tz_ny_haircare ;;
  }

  dimension_group: last_subscription_canceled_at_skincare_tz_ny {
    label: "Last Subscription Canceled Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
  }

  dimension_group: last_subscription_canceled_at_supplements_tz_ny {
    label: "Last Subscription Canceled Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_canceled_at_tz_ny_supplements ;;
  }

  dimension_group: last_subscription_created_at_company_tz_ny {
    label: "Last Subscription Created - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_subscription_created_at_tz_ny_customer ;;
  }

  dimension_group: last_subscription_created_at_hair_tz_ny {
    label: "Last Subscription Created Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_created_at_tz_ny_hair ;;
  }

  dimension_group: last_subscription_created_at_haircare_tz_ny {
    label: "Last Subscription Created Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_created_at_tz_ny_haircare ;;
  }

  dimension_group: last_subscription_created_at_skincare_tz_ny {
    label: "Last Subscription Created Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
  }

  dimension_group: last_subscription_created_at_supplements_tz_ny {
    label: "Last Subscription Created Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_subscription_created_at_tz_ny_supplements ;;
  }

  dimension_group: first_sub_order_date_company_at_tz_ny {
    label: "First Subscription Order - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_sub_order_date_company_at_tz_ny ;;
  }

  dimension_group: first_non_sub_order_date_company_at_tz_ny {
    label: "First Non Subscription Order - Company"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_non_sub_order_date_company_at_tz_ny ;;
  }

  dimension_group: first_order_date_sub_at_tz_ny_hair {
    label: "First Order Date Subscriber - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.first_order_date_sub_at_tz_ny_hair ;;
  }

  dimension_group: first_order_date_non_sub_at_tz_ny_hair {
    label: "First Order Date Subscriber - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.first_order_date_non_sub_at_tz_ny_hair ;;
  }

  dimension_group: last_order_date_haircare_at_tz_ny {
    label: "Last Order Date - Haircare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_order_date_at_tz_ny_haircare ;;
  }

  dimension_group: last_order_date_skincare_at_tz_ny {
    label: "Last Order Date - Skincare - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: CASE WHEN ${customer_pubkey} IS NOT NULL THEN PARSE_DATE("%Y-%m-%d",  "@{mock_date}") END ;;
  }

  dimension_group: last_order_date_supplements_at_tz_ny {
    label: "Last Order Date - Supplements - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_order_date_at_tz_ny_supplements ;;
  }

  dimension_group: last_order_date_hair_at_tz_ny {
    label: "Last Order Date - Hair - NY TZ"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}.last_order_date_at_tz_ny_hair ;;
  }

#### PARAMETERS AND DYNAMIC FIELDS --------------------------------------------------------------------------------------------------------------------

  parameter: cohort_selector {
    description: "Use this Selector with the Dynamic Cohort Dimension to quickly change cohorts"
    type: unquoted
    default_value: "hair_type"
    allowed_value: {
      label: "Hair Type"
      value: "hair_type"
    }
    allowed_value: {
      label: "First Order Product"
      value: "product"
    }
    allowed_value: {
      label: "Age Range"
      value: "age"
    }
    allowed_value: {
      label: "Subscription Status"
      value: "sub"
    }
  }

  dimension: dynamic_cohort {
    label_from_parameter: cohort_selector
    sql:
    {% if cohort_selector._parameter_value == 'hair_type' %}
      ${customer_hair_texture_type}
    {% elsif cohort_selector._parameter_value == 'product' %}
    ${first_order_product}
    {% elsif cohort_selector._parameter_value == 'age' %}
    ${customer_age_range}
    {% else %}
      ${subscription_status_company}
    {% endif %};;
  }

#### MEASURES --------------------------------------------------------------------------------------------------------------------

  measure: total_distinct_customers {
    type: count_distinct
    sql: ${customer_pubkey};;
    drill_fields: [detail*]
  }

  measure: first_order_subscribers_company {
    label: "First Order Subscribers (Company)"
    type: count_distinct
    sql: ${customer_pubkey};;
    filters: [is_subscription_at_first_order_company: "Yes"]
  }

  measure: subscription_at_first_penetration {
    sql: ${first_order_subscribers_company}/${total_distinct_customers} ;;
    value_format_name: percent_0
    }

  measure: non_subscription_at_first_customer {
    type: count_distinct
    sql: ${customer_pubkey};;
    description: "Count of unique customers who have not subscribed at first order"
    filters: [
      is_subscription_at_first_order_company: "No",
    ]
    group_label: "Counts"
  }

  measure: subscription_at_first_customer {
    type: count_distinct
    description: "Count of unique customers who subscribed at first order"
    sql: ${customer_pubkey};;
    filters: [
      is_subscription_at_first_order_company: "Yes",
    ]
    group_label: "Counts"
  }

  measure: repeat_customers {
    type: count_distinct
    description: "Count of unique repeat customers, meaning that their last order is not their first order"
    sql: ${customer_pubkey};;
    filters: [
      last_is_first_order: "No",
    ]
    group_label: "Counts"
  }

  measure: repeat_customers_never_subscribed {
    type: count_distinct
    description: "Count of unique repeat customers (they have more than one order) who have not subscribed to the company"
    sql: ${customer_pubkey};;
    filters: [
      last_is_first_order: "No",
      subscription_status_company: "never-subscribed",
    ]
    group_label: "Counts"
  }

  measure: repeat_customers_subscription_at_first {
    type: count_distinct
    description: "Count of repeat (more than one order) customers who subscribed at first and have an active or on-hold subscription status"
    sql: ${customer_pubkey};;
    filters: [
      last_is_first_order: "No",
      subscription_status_company: "active, on-hold",
      is_subscription_at_first_order_company: "Yes",
    ]
    group_label: "Counts"
  }

  measure: repeat_customers_subscription_at_repeat {
    type: count_distinct
    description: "Count of repeat (more than one order) subscription customers who didn't subscribed at first and have an active or on-hold subscription status"
    sql: ${customer_pubkey};;
    filters: [
      last_is_first_order: "No",
      subscription_status_company: "active, on-hold",
      is_subscription_at_first_order_company: "No",
    ]
    group_label: "Counts"
  }

  measure: active_customers {
    type: count_distinct
    description: "Count of customers who have placed an order in last 90 days"
    sql: ${customer_pubkey};;
    filters: [
      last_order_date_company_at_tz_ny_date: "after 90 days ago",
    ]
    group_label: "Counts"
  }

  measure: inactive_customers {
    type: count_distinct
    description: "Count of customers who have not placed an order in last 90 days"
    sql: ${customer_pubkey};;
    filters: [
      last_order_date_company_at_tz_ny_date: "before 90 days ago",
    ]
    group_label: "Counts"
  }

  measure: subscribers {
    type: count_distinct
    description: "Count of unique customers with either active or on-hold subscription status"
    sql: ${customer_pubkey};;
    filters: [
      subscription_status_company: "active, on-hold"
    ]
    group_label: "Counts"
  }

  measure: active_subscribers {
    type: count_distinct
    description: "Count of subscribers with active statuses (active, but not on hold) in the company"
    sql: ${customer_pubkey};;
    filters: [
      subscription_status_company: "active",
    ]
    group_label: "Counts"
  }

  measure: onhold_subscribers {
    type: count_distinct
    description: "Count of subscribers with on hold statuses in the company"
    sql: ${customer_pubkey};;
    filters: [
      subscription_status_company: "on-hold",
    ]
    group_label: "Counts"
  }

  measure: subscriber_penetration_rate {
    type: number
    sql: 100.0 * ${subscribers} / NULLIF(${total_distinct_customers}, 0);;
    description: "Percent of customers with either active or on-hold subscription status at company"
    group_label: "Percentage"
  }

  measure: subscribers_at_first {
    type: count_distinct
    description: "Count of subscribers at first order"
    sql: ${customer_pubkey};;
    filters: [
      subscription_status_company: "active, on-hold",
      is_subscription_at_first_order_company: "Yes",
    ]
    hidden: yes
  }

  measure: subscriber_at_first_penetration_rate {
    type: number
    sql: 100.0 * ${subscribers_at_first} / NULLIF(${subscribers}, 0);;
    description: "Percent of customers with either active or on-hold subscription status who subscribed at first"
    group_label: "Percentage"
  }

  measure: subscribers_at_repeat {
    type: count_distinct
    description: "Count of subscribers who are not subscribers at first order"
    sql: ${customer_pubkey};;
    filters: [
      subscription_status_company: "active, on-hold",
      is_subscription_at_first_order_company: "No",
    ]
    hidden: yes
  }

  measure: subscriber_at_repeat_penetration_rate {
    type: number
    sql: 100.0 * ${subscribers_at_repeat} / NULLIF(${subscribers}, 0);;
    description: "Percent of  customers with either active or on-hold subscription status who subscribed at repeat"
    group_label: "Percentage"
  }

  measure: reactivation_subscribers {
    type: count_distinct
    sql: ${customer_pubkey};;
    description: "Count of subscribers that reactivates any subscription after having canceled it"
    filters: [
      subscription_status_company: "active, on-hold",
      last_subscription_canceled_at_company_tz_ny_date: "after 1970",
    ]
    hidden: yes
  }

  measure: reactivation_rate {
    type: number
    sql: 100.0 * ${reactivation_subscribers} / NULLIF(${subscribers}, 0);;
    description: "Percent of customers with active or on-hold subscription status who once canceled it"
    group_label: "Percentage"
  }

  measure: churned_subscribers {
    type: count_distinct
    sql: ${customer_pubkey};;
    description: "Churned subscribers"
    filters: [
      subscription_status_company: "churned",
    ]
    hidden: yes
  }

  measure: subscription_churn_rate {
    type: number
    sql: 100.0 * ${churned_subscribers} / NULLIF(${total_distinct_customers}, 0);;
    description: "Percent of customers with churned subscription status"
    group_label: "Percentage"
  }

  measure: repurchase_rate {
    type: number
    sql: 100.0 * ${repeat_customers} / NULLIF(${total_distinct_customers}, 0);;
    description: "Percent of customers with more than one order"
    group_label: "Percentage"
}



}
