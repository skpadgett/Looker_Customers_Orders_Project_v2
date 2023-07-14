#### DESCRIPTION --------------------------------------------------------------------------------------------------------------------

# This view pulls data from the order data mart. There are many hidden fields within this view. This is to support efforts to provide visibility into rollup aggregation bucketed by timeframes.
# A future enhancement opportunity would be to roll these aggregation needs into an aggregate PDT to enhance performance and efficiency.

view: order {

  sql_table_name: `customer.customer_bi_datamart_growth_customer_ltv_customer_order.order`
    ;;

#### SETS --------------------------------------------------------------------------------------------------------------------

  # This set holds the default drill fields throughout many of the measures in this view.
  set: detail {
    fields: [customer.customer_first_name, customer.subscription_status_company, order_date_at_tz_ny_date, order_shipping_city, total_net_sales, is_first_order, is_free_order, is_discounted_order]
  }

#### DIMENSIONS --------------------------------------------------------------------------------------------------------------------

  ## Beginning of ID fields

  dimension: order_pubkey {
    primary_key: yes
    description: "The primary key for orders."
    hidden: yes
    type: string
    sql: ${TABLE}.order_pubkey ;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey {
    description: "The primary key for customers."
    hidden: yes
    type: string
    sql: ${TABLE}.customer_pubkey ;;
    group_label: "ID Fields"
  }

  # The below pubkey delineation is all hidden. These breakouts are integral for the daily flash time-bucket calculations.
  # Order pubkey had to be broken out in these different dimensions to:
  #       1) allow for count distinct within each time bucket
  #       2) allow for the count of previous time periods that would otherwise be disregarded by the binary-classification nature of CASE WHEN
  #               (e.g., When breaking out the count distinct to show orders yesterday and the last 7 days, all of yesterday's orders would
  #                      thereby not be included in the last 7 days' calculation by default. Siloing out these time frames allows for accurate
  #                      calculation upon assimilation.).

  dimension: order_pubkey_yesterday {
    hidden: yes
    type: string
    sql: case when ${yesterday}
    then ${TABLE}.order_pubkey
    else null
    end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_7_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_30_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: order_pubkey_last_365_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days} or ${last_365_days}
          then ${TABLE}.order_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey_yesterday {
    hidden: yes
    type: string
    sql: case when ${yesterday}
          then ${TABLE}.customer_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey_last_7_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days}
          then ${TABLE}.customer_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey_last_30_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days}
          then ${TABLE}.customer_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  dimension: customer_pubkey_last_365_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days} or ${last_365_days}
          then ${TABLE}.customer_pubkey
          else null
          end;;
    group_label: "ID Fields"
  }

  ## End of ID fields

  ## Beginning of Order Currency fields

  dimension: order_conversion_rate {
    label: "Order Currency Conversion Rate"
    type:  number
    sql: ${TABLE}.order_conversion_rate ;;
    group_label: "Order Currency"
  }

  dimension: order_currency {
    type:  string
    sql: ${TABLE}.order_currency ;;
    group_label: "Order Currency"
  }

  ## Beginning of Order Composition dimensions

  dimension:  count_brush {
    type: number
    sql: ${TABLE}.count_brush ;;
    group_label: "Order Composition"
  }

  dimension: count_conditioner  {
    type: number
    sql: ${TABLE}.count_conditioner ;;
    group_label: "Order Composition"
  }

  dimension: count_curl_cream  {
    type: number
    sql: ${TABLE}. count_curl_cream;;
    group_label: "Order Composition"
  }

  dimension: count_dry_shampoo  {
    type: number
    sql: ${TABLE}.count_dry_shampoo;;
    group_label: "Order Composition"
  }

  dimension: count_curly_mask  {
    type: number
    sql: ${TABLE}.count_curly_mask ;;
    group_label: "Order Composition"
  }

  dimension: count_curlyoil  {
    type: number
    sql: ${TABLE}.count_curlyoil ;;
    group_label: "Order Composition"
  }

  dimension: count_leavein_conditioner  {
    label: "Count Leave-in Conditioner"
    type: number
    sql: ${TABLE}.count_leavein_conditioner ;;
    group_label: "Order Composition"
  }

  dimension: count_scalp_mask  {
    type: number
    sql: ${TABLE}.count_scalp_mask ;;
    group_label: "Order Composition"
  }

  dimension: count_shampoo  {
    type: number
    sql: ${TABLE}.count_shampoo ;;
    group_label: "Order Composition"
  }

  dimension: count_shimmer_curlyoil  {
    type: number
    sql: ${TABLE}.count_shimmer_curlyoil ;;
    group_label: "Order Composition"
  }

  dimension: count_styling_gel  {
    type: number
    sql: ${TABLE}.count_styling_gel ;;
    group_label: "Order Composition"
  }

  dimension: count_supplement_core  {
    type: number
    sql: ${TABLE}.count_supplement_core ;;
    group_label: "Order Composition"
  }

  dimension: count_supplement_booster  {
    type: number
    sql: ${TABLE}.count_supplement_booster ;;
    group_label: "Order Composition"
  }

  dimension: count_supplement_total  {
    type: number
    description: "Supplement Core + Booster"
    sql: ${count_supplement_core} + ${count_supplement_booster};;
    group_label: "Order Composition"
  }

  dimension: count_units  {
    type: number
    sql: ${TABLE}.count_units ;;
    group_label: "Order Composition"
  }

  ## End of order composition dimensions

  ## Beginning of customer time duration dimensions

  dimension: days_since_first_order {
    description: "Datediff between Today's date and the customer's First Valid Order Date (tells us how aged the customer is). Use to ensure a customer is 'aged' enough to be included in an analysis."
    type: number
    sql: ${TABLE}.days_since_first_order ;;
    group_label: "Customer Time Duration"
  }


  dimension: first_order_to_order_days {
    description: "Datediff in days between First Order Date and the Order Date. Each order will have its own value (e.g. The value would be 0 for the First Order. If a customer places an order the day after placing their first order, the value would be 1.) Use to ensure customer orders only through a certain timeframe are included in an analysis."
    type: number
    sql: ${TABLE}.first_order_to_order_days ;;
    group_label: "Customer Time Duration"
  }

  dimension: months_since_first_order {
    description: "Order Date less First Order Date (in months). The number of months since first valid sales order date. Every order has its own value."
    type: number
    sql: ${TABLE}.months_since_first_order ;;
    group_label: "Customer Time Duration"
  }

  ## End of customer time duration dimensions

  ## Beginning of Discount dimensions

  dimension: discounts_used {
    type:  string
    sql:  ${TABLE}.discounts_used ;;
    group_label: "Order Discount"
  }

  dimension: discount_code_used {
    description: "Promotion code used to apply a discount to an order."
    type:  string
    sql:  ${TABLE}.discount_code_used ;;
    group_label: "Order Discount"
  }

  dimension: has_balance_discount {
    type: yesno
    sql: ${TABLE}.has_balance_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_gift_discount  {
    type: yesno
    sql: ${TABLE}.has_gift_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_membership_gift_discount  {
    type: yesno
    sql: ${TABLE}.has_membership_gift_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_new_customer_discount {
    type: yesno
    sql: ${TABLE}.has_new_customer_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_one_time_membership_gift_discount  {
    type: yesno
    sql: ${TABLE}.has_one_time_membership_gift_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_promotion_discount  {
    type: yesno
    sql: ${TABLE}.has_promotion_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_referral_advocate_discount  {
    type: yesno
    sql: ${TABLE}.has_referral_advocate_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_referral_code_discount  {
    type: yesno
    sql: ${TABLE}.has_referral_code_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_subscription_discount  {
    type: yesno
    sql: ${TABLE}.has_subscription_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: has_winback_gift_discount  {
    type: yesno
    sql: ${TABLE}.has_winback_gift_discount ;;
    group_label: "Order Discount Flags"
  }

  dimension: discount_types {
    description: "Creating consolidated list for reporting."
    type: string
    sql: case when ${has_gift_discount}
              then 'Gift Discount'
              when ${has_balance_discount}
              then 'Balance Discount'
              when ${has_promotion_discount}
              then 'Promotion Discount'
              when ${has_new_customer_discount}
              then 'New Customer Discount'
              when ${has_membership_gift_discount}
              then 'Membership Gift Discount'
              when ${has_referral_code_discount}
              then 'Referral Code Discount'
              when ${has_subscription_discount}
              then 'Subscription Discount'
              when ${has_winback_gift_discount}
              then 'Winback Discount'
              when ${has_referral_advocate_discount}
              then 'Referral Advocate Discount'
              when ${has_one_time_membership_gift_discount}
              then 'One Time Membership Discount'
              else 'Other'
              end;;
    group_label: "Order Discount"
  }

  ### End of Discount dimensions

  ### Beginning of Order Flag dimensions

  dimension: is_employee_order {
    description: "Flag whether order was placed by a customer Employee. This includes F&F but does not include influencers."
    type: yesno
    sql: ${TABLE}.is_employee_order ;;
    group_label: "Order Flags"
  }

  dimension: is_discounted_order {
    description: "Flag whether there was any promotional/discounted value applied to the order."
    type: yesno
    sql: ${TABLE}.is_discounted_order ;;
    group_label: "Order Flags"
  }

  dimension: is_first_order {
    description: "Flag whether it's the customer's first overall order with customer, even if it's a free order."
    type: yesno
    sql: ${TABLE}.is_first_order ;;
    group_label: "Order Flags"
  }

  dimension: is_first_paid_order {
    description: "Flag whether it's the customer's first order and it's not a free order."
    type: yesno
    sql: ${TABLE}.is_first_paid_order ;;
    group_label: "Order Flags"
  }

  dimension: is_free_order {
    type: yesno
    sql: ${TABLE}.is_free_order ;;
    group_label: "Order Flags"
  }

  dimension: is_gift_set_purchase {
    description: "Flag whether the order is the purchase of a Gift Card (currently it's not really a Gift Card, it's the purchase of a set of Gifted items)."
    type: yesno
    sql: ${TABLE}.is_gift_set_purchase ;;
    group_label: "Order Flags"
  }

  dimension: is_gift_set_redemption_order {
    description: "Flag whether the order was a redemmed gift set (e.g. The Essentials (Shampoo + Conditioner Set) or The Complete Set (Shampoo + Conditioner + Mask)."
    type: yesno
    sql: ${TABLE}.is_gift_set_redemption_order ;;
    group_label: "Order Flags"
  }

  dimension: is_order_placed_from_subscription {
    description: "Flag whether the order was automatically created from a subscription, even if the customer added another product. An order can still be placed from subscription if it contains both a subscribed product and not a subscribed product."
    type: yesno
    sql: ${TABLE}.is_order_placed_from_subscription ;;
    group_label: "Order Flags"
  }

  dimension: is_fully_refunded {
    description: "Flag whether the order was previously paid and shipped, but ended up being fully refunded."
    type: yesno
    sql: ${TABLE}.is_fully_refunded ;;
    group_label: "Order Flags"
  }

  dimension: is_partially_refunded {
    description: "Flag whether the order was previously paid and shipped, but ended up having a partial refund."
    type: yesno
    sql: ${TABLE}.is_partially_refunded ;;
    group_label: "Order Flags"
  }


  dimension: is_store_credit_redemption_order {
    description: "Flag whether store credit was redeemed/used as payment or part of payment for the order."
    type: yesno
    sql: ${TABLE}.is_store_credit_redemption_order ;;
    group_label: "Order Flags"
  }

  dimension: is_subscriber_at_time_of_order_company {
    description: "Flag whether the customer was an active Subscriber at the time of placing the order (any order type). Meaning did the customer have an active subscription at the time of placing the order."
    type: yesno
    sql: ${TABLE}.is_subscriber_at_time_of_order_company ;;
    group_label: "Order Flags"
  }

  dimension: is_subscription_at_first_order {
    description: "Identifies order subscribed at first order."
    type: yesno
    sql: ${TABLE}.is_subscription_at_first_order ;;
    group_label: "Order Flags"
  }

  dimension: is_valid_operations_order {
    description: "Flag whether the order is a Valid Operations Order. Valid operations orders are linked to operations activity (i.e. is it produced?) Includes orders that are reformulated, lost package, damaged order, order error, missing item, employee order, influencer order. Gift set orders are NOT considered a valid operations order."
    type: yesno
    sql: ${TABLE}.is_valid_operations_order ;;
    group_label: "Order Flags"
  }

  dimension: is_valid_sales_order {
    description: "Flag whether the order is a Valid Sales Order. Valid sales orders are linked to marketing activity (i.e. did we collect money from customer?) It includes orders that were fully paid by coupons, discounts, gift cards etc. Includes orders of a gift card."
    type: yesno
    sql: ${TABLE}.is_valid_sales_order ;;
    group_label: "Order Flags"
  }

  # TODO: needs confirmation_using for finance_cohort measure
  dimension: is_order_after_last_subscription_winback {
    type: yesno
    sql: ${order_date_at_tz_ny_raw} >${customer.last_customer_subscription_winback_company_at_tz_ny_raw};;
    group_label: "Order Flags"
  }

  dimension: is_order_at_last_subscription_winback {
    type: yesno
    sql: ${order_date_at_tz_ny_raw} = ${customer.last_customer_subscription_winback_company_at_tz_ny_raw};;
    group_label: "Order Flags"
  }

  ### End of Order Flag dimensions

  ### Beginning of order makeup flags dimensions

  dimension: is_containing_gwp {
    label: "Order Contains GWP (Gift with Purchase)"
    description: "Flag whether the order contains a gift with purchase."
    type: yesno
    sql: ${TABLE}.is_containing_gwp ;;
    group_label: "Order Contains Flags"
  }

  dimension: is_containing_trial_product {
    label: "Order Contains Trial Product"
    description: "Flag whether the order contains a trial product."
    type: yesno
    sql: ${TABLE}.is_containing_trial_product ;;
    group_label: "Order Contains Flags"
  }

  dimension: order_contains_brush {
    description: "Flag whether the order contains a brush."
    type: yesno
    sql: ${TABLE}.order_contains_brush ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_conditioner {
    description: "Flag whether the order contains conditioner."
    type: yesno
    sql: ${TABLE}.order_contains_conditioner ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_curl_cream {
    description: "Flag whether the order contains curl cream."
    type: yesno
    sql: ${TABLE}.order_contains_curl_cream ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_dry_shampoo {
    description: "Flag whether the order contains dry shampoo."
    type: yesno
    sql: ${TABLE}.order_contains_dry_shampoo ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_curly {
    type: yesno
    sql: ${TABLE}.contains_curly ;;
    group_label: "Order Contains Flags"
  }

  dimension: order_contains_curlycare {
    type: yesno
    sql: ${TABLE}.contains_curlycare ;;
    group_label: "Order Contains Flags"
  }

  dimension: order_contains_curly_mask {
    description: "Flag whether the order contains a curly mask."
    type: yesno
    sql: ${TABLE}.order_contains_curly_mask ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_curlyoil {
    label: "Order Contains curly Oil"
    description: "Flag whether the order contains curly oil."
    type: yesno
    sql: ${TABLE}.order_contains_curlyoil ;;
    group_label: "Order Contains Flags"
    }

  dimension: contains_curlycare_and_supplements {
    description: "Flag whether the order contains curlycare AND supplements."
    type: yesno
    sql: ${TABLE}.contains_curlycare AND ${TABLE}.contains_supplements ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_leavein_conditioner {
    label: "Order Contains Leave-in Conditioner"
    description: "Flag whether the order contains leave-in conditioner."
    type: yesno
    sql: ${TABLE}.order_contains_leavein_conditioner ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_scalp_mask {
    description: "Flag whether the order contains a scalp mask."
    type: yesno
    sql: ${TABLE}.order_contains_scalp_mask ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_shampoo {
    description: "Flag whether the order contains shampoo."
    type: yesno
    sql: ${TABLE}.order_contains_shampoo ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_shimmer_curlyoil {
    label: "Order Contains Shimmer curly Oil"
    description: "Flag whether the order contains shimmer curly oil."
    type: yesno
    sql: ${TABLE}.order_contains_shimmer_curlyoil ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_styling_gel {
    description: "Flag whether the order contains styling gel."
    type: yesno
    sql: ${TABLE}.order_contains_styling_gel ;;
    group_label: "Order Contains Flags"
  }

  dimension: order_contains_supplements {
    type: yesno
    sql: ${TABLE}.contains_supplements ;;
    group_label: "Order Contains Flags"
  }

  dimension: order_contains_supplement_booster {
    description: "Flag whether the order contains supplement booster."
    type: yesno
    sql: ${TABLE}.order_contains_supplement_booster ;;
    group_label: "Order Contains Flags"
    }

  dimension: order_contains_supplement_core {
    description: "Flag whether the order contains supplement core."
    type: yesno
    sql: ${TABLE}.order_contains_supplement_core ;;
    group_label: "Order Contains Flags"
  }

  ### End of order makeup flags

  ### Beginning of order rank dimensions

  dimension: subscription_order_rank {
    type: number
    sql: ${TABLE}.subscription_order_rank ;;
    group_label: "Order Rank"
  }

  dimension: non_subscription_order_rank {
    type: number
    sql: ${TABLE}.non_subscription_order_rank ;;
    group_label: "Order Rank"
  }


  dimension: total_order_rank {
    type: number
    sql: ${TABLE}.total_order_rank ;;
    group_label: "Order Rank"
  }

  dimension: total_order_rank_tier {
    description: "This dimension reformats the order rank tier in a more user-readable format."
    type: tier
    tiers: [2,6]
    style: relational
    sql: ${total_order_rank} ;;
    group_label: "Order Rank"
    html: {%if value == '< 2.0' %}
    First Order
    {%elsif value == '>= 2.0 and < 6.0' %}
    Orders 2-5
    {%elsif value == '>= 6.0' %}
    Orders 5+
    {% endif %};;
  }

  dimension: valid_operations_order_rank {
    type: number
    sql: ${TABLE}.valid_operations_order_rank ;;
    group_label: "Order Rank"
  }

  dimension: valid_sales_order_rank {
    description: "The number order of customer (e.g. first order = 1, second order = 2, etc.). Includes ONLY VALID SALES orders"
    type: number
    sql: ${TABLE}.valid_sales_order_rank ;;
    group_label: "Order Rank"
  }

  ### End of order rank dimensions

  ### Beginning of shipping dimensions

  dimension: order_shipping_address_line_1 {
    description: "Address 1 of where order is shipped to."
    type: string
    sql: ${TABLE}.order_shipping_address_line_1 ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_address_line_2 {
    description: "Address 2 of where order is shipped to."
    type: string
    sql: ${TABLE}.order_shipping_address_line_2 ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_city {
    description: "City order is being shipped to (e.g. San Francisco)."
    type: string
    sql: ${TABLE}.order_shipping_city ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_country {
    description: "Country order is being shipped to (e.g. US, CA, etc.)."
    type: string
    map_layer_name: countries
    sql: ${TABLE}.order_shipping_country ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_division {
    description: "US Census Division the order is being shipped to (e.g. Pacific, New England)"
    type: string
    sql: ${TABLE}.order_shipping_division ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_name {
    type: string
    sql: ${TABLE}.order_shipping_name ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_region {
    description: "US Census Region order is being shipped to (Northeast, South, West, Midwest)."
    type: string
    sql: ${TABLE}.order_shipping_region ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_state {
    description: "State order is being shipped to (e.g. New York, California, etc.)."
    type: string
    sql: ${TABLE}.order_shipping_state ;;
    group_label: "Order Address"
  }

  dimension: order_shipping_state_abbrv {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.order_shipping_state_abbvr ;;
    group_label: "Order Address"
    drill_fields: [order_shipping_zipcode]
    link: {
      label: "{{value}} Lookup Dashboard"
      url: "/dashboards/8?Order+Shipping+State={{ value | encode_uri }}"
      icon_url: "https://www.seekpng.com/png/full/138-1386046_google-analytics-integration-analytics-icon-blue-png.png"
    }

  }

  dimension: order_shipping_zipcode {
    description: "ZIP or Postal Code orer is being shipped to (e.g. 11030)."
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.order_shipping_zipcode ;;
    group_label: "Order Address"
  }

  ### End of shipping dimensions

  ### Beginning of Daily Flash dimensions

  # The dimensions below are foundational in calculating the time frame buckets for the daily flash crosstab on the Daily Flash Dashboard.
  # Many of them are hidden, as they are not integral for data exploration.

  dimension: daily_flash_times {
    description: "Buckets for different timeframes to compare by in the Daily Flash dashboard"
    hidden: yes
    sql: case when ${order_date_yesterday} is not null
    then 'Yesterday'
    when ${order_date_last_7_days} is not null
    then 'Last 7 Days'
    when ${order_date_last_30_days} is not null
    then 'Last 30 Days'
    when ${order_date_last_365_days} is not null
    then 'Last 365 Days'
    else null
    end;;
    order_by_field: flash_rank
    group_label: "Daily Flash Calculation"
   }

  dimension: flash_rank {
    description: "Hidden field used to rank the daily_flash_times dinmension chronologically."
    hidden: yes
    sql: case when ${daily_flash_times} = 'Yesterday'
          then 1
          when ${daily_flash_times} = 'Last 7 Days'
          then 2
          when ${daily_flash_times} = 'Last 30 Days'
          then 3
          when ${daily_flash_times} = 'Last 365 Days'
          then 4
          when ${daily_flash_times} is null
          then 5
          end;;
  }

  dimension: order_date_yesterday {
    hidden: yes
    type: string
    sql: case when ${yesterday}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"

  }

  dimension: order_date_last_7_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }


  dimension: order_date_last_30_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  dimension: order_date_last_365_days {
    hidden: yes
    type: string
    sql: case when ${yesterday} or ${last_7_days} or ${last_30_days} or ${last_365_days}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  dimension: order_date_yesterday_prior_year {
    hidden: yes
    type: string
    sql: case when ${yesterday_prior_year}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  dimension: order_date_last_7_days_prior_year {
    hidden: yes
    type: string
    sql: case when ${yesterday_prior_year} or ${last_7_days_prior_year}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  dimension: order_date_last_30_days_prior_year {
    hidden: yes
    type: string
    sql: case when ${yesterday_prior_year} or ${last_7_days_prior_year} or ${last_30_days_prior_year}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  dimension: order_date_last_365_days_prior_year {
    hidden: yes
    type: string
    sql: case when ${yesterday_prior_year} or ${last_7_days_prior_year} or ${last_30_days_prior_year} or ${last_365_days_prior_year}
          then ${order_date_at_tz_ny_date}
          else null
          end;;
    group_label: "Daily Flash Calculation"
  }

  ### End of Daily Flash dimensions

  ### Beginning of relative to today/prior year dimensions

  # These hidden fields are used in filters and other time-based logic throughout the LookML.

  dimension: yesterday {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} = @{yesterday_sql}
              then true
              else false
              end;;
    group_label: "Relative to Today"
  }

  dimension: last_7_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_7_days} and @{yesterday_sql}
              then true
              else false
              end;;
    group_label: "Relative to Today"
  }

  dimension: last_30_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_30_days} and @{yesterday_sql}
              then true
              else false
              end;;
    group_label: "Relative to Today"
  }

  dimension: last_365_days {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_365_days} and @{yesterday_sql}
              then true
              else false
              end;;
    group_label: "Relative to Today"
  }

  dimension: yesterday_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} = @{yesterday_same_day_prior_year}
              then true
              else false
              end;;
    group_label: "Relative to Prior Year"
  }

  dimension: last_7_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_7_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
              then true
              else false
              end;;
    group_label: "Relative to Prior Year"
  }

  dimension: last_30_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_30_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
              then true
              else false
              end;;
    group_label: "Relative to Prior Year"
  }

  dimension: last_365_days_prior_year {
    hidden: yes
    type: yesno
    sql: case when ${order_date_at_tz_ny_date} between @{beginning_of_last_365_days_same_day_prior_year} and @{yesterday_same_day_prior_year}
              then true
              else false
              end;;
    group_label: "Relative to Prior Year"
  }

  ### End of relative to today/prior year dimensions

  ### Beginning of refund dimensions

  dimension: refund_reason {
    type: string
    sql: ${TABLE}.refund_reason ;;
    group_label: "Refund Info"
  }

  ### End of refund dimensions

#### DIMENSION GROUPS --------------------------------------------------------------------------------------------------------------------

  dimension_group: last_synced {
    description: "This field gives the last synced metadata for the order data mart.
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

  dimension_group: order_shipped {
    label: "Order Shipped"
    description: "Date product was shipped. Meaning when the product leaves the facility NOT when a shipping label is created."
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.order_shipped_at ;;
  }

  dimension_group: first_order_date_at_tz_ny {
    label: "First Order Date - NY TZ"
    description: "Date of first valid sales order."
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
    sql: ${TABLE}.first_order_date_at_tz_ny ;;
  }

  dimension_group: order_date_at_tz_ny {
    label: "Order Date - NY TZ"
    description: "Date the order was placed. Order is placed once payment has been processed. If payment doesn't go through, order status is set to `payment_error`."
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
      year,
      day_of_week_index,
      day_of_month,
      month_num,
      day_of_year
    ]
    convert_tz: no
    alias: [Order]
    datatype: date
    sql: ${TABLE}.order_date_at_tz_ny ;;
  }

  dimension_group: order_datetime_at_tz_ny {
    label: "Order Datetime - NY TZ"
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
    alias: [Order]
    datatype: datetime
    sql: ${TABLE}.order_datetime_at_tz_ny ;;
  }

  dimension_group: flat_refund_created_at {
    label: "Refund"
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.flat_refund_created_at ;;
  }

#### PARAMETERS AND DYNAMIC FIELDS --------------------------------------------------------------------------------------------------------------------

  parameter: select_timeframe {
    label:  "Period over Period Scope"
    description: "Use with period buttons in daily flash for dynamic Period over Period analysis"
    hidden: yes
    type: string
    default_value: "Last 7 Days"
    allowed_value: {
      value: "Last 7 Days"
    }
    allowed_value: {
      value: "Last 30 Days"
    }
    allowed_value: {
      value: "Last 90 Days"
    }
    allowed_value: {
      value: "YTD"
    }
  }

  parameter: measure_selector {
    description: "Used to toggle between KPI views in New Product Launch dashboard."
    hidden: yes
    type: unquoted
    allowed_value: {label: "Net Sales"
      value: "netsales"}
    allowed_value: {label: "Items"
      value: "items"}
    allowed_value: {label: "AOV"
      value: "aov"}
    allowed_value: {label: "Customers"
      value: "customers"}
    allowed_value: {label: "CPA"
      value: "cpa"}
  }

  measure: selected_measure {
    label_from_parameter: measure_selector
    hidden: yes
    type: number
    value_format: "#,##0"   # default value format for the ‘else’ values
    sql:
      {% if measure_selector._parameter_value == 'netsales' %} ${total_net_new_sales_USD}
      {% elsif measure_selector._parameter_value == 'items' %} ${all_customer_units}                    -- may not be right - i.e. need measure filtered by product line/product
      {% elsif measure_selector._parameter_value == 'aov' %} ${average_order_value_USD}
      {% elsif measure_selector._parameter_value == 'customers' %} ${distinct_new_customer_count}
      {% elsif measure_selector._parameter_value == 'cpa' %} ${total_net_new_sales_USD}              -- need CPA
      {% endif %}
      ;;
    html:
     {% if measure_selector._parameter_value ==  'items' %}
     {{rendered_value }}
     {% elsif measure_selector._parameter_value == 'customers' %}
     {{rendered_value }}
     {% else %}
     ${{ rendered_value }}
     {% endif %}
     ;;

  }

  dimension: current_vs_previous_period {
    description: "Use this dimension along with the Period over Period Scope Filter for dynamic Period of Period analysis"
    hidden: yes
    type: string
    sql:
    case
      {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_7_days} and @{yesterday_sql}
      {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_30_days} and @{yesterday_sql}
      {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
       when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_90_days} and @{yesterday_sql}
       {% elsif select_timeframe._parameter_value == "'YTD'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_year} and @{yesterday_sql}
        {% endif %}
        then 'Current Year'
      {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_7_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_30_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_90_days_prior_year} and @{yesterday_prior_year}
      {% elsif select_timeframe._parameter_value == "'YTD'" %}
        when ${order_date_at_tz_ny_date}
        between @{beginning_of_last_year_prior_year} and @{yesterday_prior_year}
      {% endif %}
      then 'Prior Year'
      else null
    end
    ;;
  }

  dimension: selected_dynamic_duration  {
    description: "Dynamic date column for Period over Period analysis"
    hidden: yes
    type: number
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      ${order_date_at_tz_ny_day_of_week_index}
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
     ${order_date_at_tz_ny_month_num}
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      ${order_date_at_tz_ny_month_num}
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
     ${order_date_at_tz_ny_month_num}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of  {
    label: "Trend Line Date"
    description: "Dynamic date formatting column for Period over Period analysis"
    hidden: yes
    order_by_field: selected_dynamic_day_of_sort
    type: string
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      format_date("%m/%d", ${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
    ${order_date_at_tz_ny_month_name}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_sort  {
    description: "Sorting column to dynamically sort Period over Period analysis in chronological order"
    hidden:  yes
    type: string
    sql:
    {% if select_timeframe._parameter_value == "'Last 7 Days'" %}
      format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 30 Days'" %}
    format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'Last 90 Days'" %}
      format_date("%m/%d",${order_date_at_tz_ny_date})
    {% elsif select_timeframe._parameter_value == "'YTD'" %}
    format_date("%m",${order_date_at_tz_ny_date})
    {% endif %};;
  }

#### MEASURES --------------------------------------------------------------------------------------------------------------------

  ### Beginning of order counts measures

  measure: total_number_orders   {
    label: "Orders"
    description: "Distinct count of order_pubkey"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  measure: total_number_orders_daily_flash   {
    label: "Orders | Daily Flash"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: count_distinct
    sql: case when ${daily_flash_times} = 'Yesterday'
              then ${order_pubkey_yesterday}
              when ${daily_flash_times} = 'Last 7 Days'
              then ${order_pubkey_last_7_days}
              when ${daily_flash_times} = 'Last 30 Days'
              then ${order_pubkey_last_30_days}
              when ${daily_flash_times} = 'Last 365 Days'
              then ${order_pubkey_last_365_days}
              else null
              end;;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  measure: total_number_of_discount_orders {
    label: "Discount Orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    group_label: "Order Counts"
    filters: [is_discounted_order: "Yes"]
  }

  measure: total_number_of_non_discount_orders {
    label: "Non Discount Orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    group_label: "Order Counts"
    filters: [is_discounted_order: "No"]
  }

  measure: total_number_of_placed_from_subscription_orders {
    label: "Orders Placed from Subscription"
    description: "# of Orders where is_order_placed_from_subscription = Yes"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_order_placed_from_subscription: "Yes"]
  }

  measure: total_number_of_non_subscription_orders {
    label: "Non-Subscription Orders"
    description: "# of Orders where is_order_placed_from_subscription = No"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_order_placed_from_subscription: "No"]
  }

  measure: total_number_of_new_orders {
    label: "New Orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes"]
  }

  measure: total_number_of_new_orders_subscribed_at_first {
    label: "New Subscription at First Orders"
    description: "Count of New Orders that are Subscription; same as New Subscription at First Customers"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "Yes"]
  }

  measure: total_number_of_new_orders_not_subscribed_at_first {
    label: "New Non-Subscription at First Orders"
    description: "Count of New Orders that are Non-Subscription; same as New Non-Subscription Customers"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "No"]
  }

  measure: total_number_of_repeat_orders {
    label: "Repeat Orders"
    description: "Count of Orders where Is First Order = No; Includes Sub and Non-sub"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No"]
  }

  measure: total_number_of_subscription_repeat_orders {
    label: "Repeat Subscription Orders"
    description: "Count of Repeat Orders where Is Order Placed From Subscription = Yes"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "Yes"]
  }

  measure: total_number_of_repeat_orders_by_subscribed_at_first {
    label: "Repeat Orders by Subscribed at First Customers"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", customer.is_subscription_at_first_order_company: "Yes"]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_customers {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders {
    label: "Repeat Non-Subscription Orders"
    description: "Count of Repeat Orders where Is Order Placed From Subscription = No"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "No"]
  }

  measure: total_number_of_subscription_repeat_orders_not_subscribed_at_first {
    label: "Repeat Subscription Orders by Non-Subscribers at First Customers"
    description: "Count of repeat subscription orders, placed by those who did not subscribe at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_subscribed_at_first {
    label: "Repeat Subscription Orders by Subscribers at First Customers"
    description: "Count of repeat subscription orders, placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders_not_subscribed_at_first {
    label: "Repeat Non-Subscription Orders by Non-Subscribers at First Customers"
    description: "Count of repeat non-subscription orders, placed by those who did not subscribe at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No",
      customer.is_subscription_at_first_order_company: "No"
    ]
  }

  measure: total_number_of_nonsubscription_repeat_orders_subscribed_at_first {
    label: "Repeat Non-Subscription Orders by Subscribers at First Customers"
    description: "Count of repeat non-subscription orders, placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "No",
      customer.is_subscription_at_first_order_company: "Yes"
    ]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first {
    label: "Repeat Subscription Orders by Subscribed at First Customers"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes"
    ]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first_churned {
    label: "Repeat Subscription Orders by Subscribed at First-Churned Customers"
    description: "Count of ALL repeat  sub orders placed by those who subscribed at first order and have previously cancelled"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first_curlycare {
    label: "Repeat Subscription Orders by Subscribed at First Customers-curlycare"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      order_contains_curlycare: "Yes"
    ]
  }

  measure: total_number_of_repeat_subsciption_orders_by_subscribed_at_first_supplements {
    label: "Repeat Subscription Orders by Subscribed at First Customers-Supplements"
    description: "Count of ALL repeat orders (sub and non-sub) placed by those who subscribed at first order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      order_contains_supplements: "Yes"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_customers_curlycare {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers-curlycare"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_curlycare: "Yes"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_customers_supplements {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers-Supplements"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "Yes"
    ]
  }

  measure: total_number_of_subscription_repeat_orders_sub_at_repeat_churned_customers {
    label: "Repeat Sub Orders by Subscribed at Repeat Customers-Churned"
    description: "Count of all sub-only repeat orders placed by those who subscribed at a repeat order"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  measure: total_repeat_sub_at_repeat_orders {
    label: "Repeat Sub at Repeat Orders"
    description: "Repeat Orders from those who subscribed at a repeat order - only includes subscription orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes"
    ]
  }

  measure: total_repeat_sub_at_repeat_orders_curlycare {
    label: "Repeat Sub at Repeat Orders - curlycare"
    description: "Repeat Orders containing curlycare from those who subscribed at a repeat order - only includes subscription orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_curlycare: "Yes"
    ]
  }

  measure: total_repeat_sub_at_repeat_orders_supplements {
    label: "Repeat Sub at Repeat Orders - Supplements"
    description: "Repeat Orders containing supplements from those who subscribed at a repeat order - only includes subscription orders"
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      order_contains_supplements: "yes"
    ]
  }

  measure: total_balance_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_balance_discount: "Yes"]
  }

  measure: total_gift_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_gift_discount: "Yes"]
  }

  measure: total_membership_gift_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_membership_gift_discount: "Yes"]
  }

  measure: total_new_customer_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_new_customer_discount: "Yes"]
  }

  measure: total_one_time_membership_gift_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_one_time_membership_gift_discount: "Yes"]
  }

  measure: total_promotion_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_promotion_discount: "Yes"]
  }

  measure: total_referral_advocate_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_referral_advocate_discount: "Yes"]
  }

  measure: total_referral_code_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_referral_code_discount: "Yes"]
  }

  measure: total_subscription_discount_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_subscription_discount: "Yes"]
  }

  measure: total_winback_gift_orders {
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [has_winback_gift_discount: "Yes"]
  }

  measure: total_number_orders_yesterday_py   {
    label: "Orders Yesterday PY"
    description: "Distinct count of order_pubkey"
    hidden:yes
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [yesterday_prior_year: "Yes"]
  }

  measure: total_number_orders_last_7_days_py   {
    label: "Orders Last 7 Days PY"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [last_7_days_prior_year: "Yes"]
  }

  measure: total_number_orders_last_30_days_py   {
    label: "Orders Last 30 Days PY"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [last_30_days_prior_year: "Yes"]
  }

  measure: total_number_orders_last_365_days_py   {
    label: "Orders Last 365 Days PY"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: count_distinct
    sql: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Order Counts"
    filters: [last_365_days_prior_year: "Yes"]
  }

  measure: total_number_orders_running_total  {
    label: "Orders Running Total"
    description: "Distinct count of order_pubkey"
    hidden: yes
    type: running_total
    sql: ${total_number_orders_daily_flash};;
    drill_fields: [detail*]
    group_label: "Order Counts"
  }

  ### End of order counts measures

  ### Beginning of Units measures

  measure: all_internal_operations_units {
    description: "Order total number of units (curly supplements core & booster considered two distinct products)"
    type: sum
    sql: ${TABLE}.count_units ;;
    group_label: "Units"
  }

  measure: all_customer_units {
    description: "Order total number of units (curly supplements core & booster considered one single product)"
    type: sum
    sql: ${TABLE}.count_customer_units ;;
    group_label: "Units"
  }

  measure: brush_units {
    description: "Total number of brush units in the order."
    type: sum
    sql: ${TABLE}.count_brush ;;
    group_label: "Units"
  }

  measure: conditioner_units {
    description: "Total number of conditioner units in the order."
    type: sum
    sql: ${TABLE}.count_conditioner ;;
    group_label: "Units"
  }

  measure: curl_cream_units {
    description:  "Total number of curl cream units in the order."
    type: sum
    sql: ${TABLE}.count_curl_cream ;;
    group_label: "Units"
  }

  measure: dry_shampoo_units {
    description:  "Total number of dry shampoo units in the order."
    type: sum
    sql: ${TABLE}.count_dry_shampoo ;;
    group_label: "Units"
  }

  measure: curly_mask_units {
    description:  "Total number of curly mask units in the order."
    type: sum
    sql: ${TABLE}.count_curly_mask ;;
    group_label: "Units"
  }

  measure: curly_oil_units {
    description:  "Total number of curly oil units in the order."
    type: sum
    sql: ${TABLE}.count_curlyoil ;;
    group_label: "Units"
  }

  measure: leavein_conditioner_units {
    description:  "Total number of leave-in conditioner units in the order."
    label: "Leave-in Conditioner Units"
    type: sum
    sql: ${TABLE}.count_leavein_conditioner ;;
    group_label: "Units"
  }

  measure: scalp_mask_units {
    description:  "Total number of scalp mask units in the order."
    type: sum
    sql: ${TABLE}.count_scalp_mask ;;
    group_label: "Units"
  }

  measure: shampoo_units {
    description:  "Total number of shampoo units in the order."
    type: sum
    sql: ${TABLE}.count_shampoo ;;
    group_label: "Units"
  }

  measure: shimmer_curly_oil_units {
    description:  "Total number of shimmer curly oil units in the order."
    type: sum
    sql: ${TABLE}.count_shimmer_curlyoil ;;
    group_label: "Units"
  }

  measure: styling_gel_units {
    description:  "Total number of styling gel units in the order."
    type: sum
    sql: ${TABLE}.count_styling_gel ;;
    group_label: "Units"
  }

  measure: supplement_core_units {
    description:  "Total number of supplement core units in the order."
    type: sum
    sql: ${TABLE}.count_supplement_core ;;
    group_label: "Units"
  }

  measure: supplement_booster_units {
    description:  "Total number of supplement booster units in the order."
    type: sum
    sql: ${TABLE}.count_supplement_booster ;;
    group_label: "Units"
  }

 measure: supplement_total_units {
    description: "Total number of supplement (core + booster) units in the order."
    type: sum
    sql: ${count_supplement_total};;
    group_label: "Units"
  }

  ### End of units measures

  ### Beginning of unit-level metrics measures

 measure: units_per_order  {
    description: "All Units / Orders"
    type: number
    sql: 1.0 * ${all_customer_units} / nullif(${total_number_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Unit-level Metrics"
  value_format_name: decimal_1
  }

  measure: gross_sales_per_unit {
    description: "Gross Sales USD / All Units "
    type: number
    sql: 1.0 * ${gross_sales_without_taxes_amount_USD} / nullif(${all_customer_units},0) ;;
    drill_fields: [detail*]
    group_label: "Unit-level Metrics"
    value_format_name: usd
  }

 measure: net_sales_per_unit {
    description: "Total Net Sales USD / All Units "
    type: number
    sql: 1.0 * ${total_net_sales_USD} / nullif(${all_customer_units},0) ;;
    drill_fields: [detail*]
    group_label: "Unit-level Metrics"
    value_format_name: usd
  }

  ### End of unit-level metrics measures

  ### Beginning of customer counts measures

  measure: distinct_customer_count  {
    type: count_distinct
    sql: ${customer_pubkey}  ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
  }

  measure: distinct_new_customer_count {
    type: count_distinct
    sql: ${customer_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes"]
  }

  measure: distinct_new_customer_count_yesterday_py {
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", yesterday_prior_year: "Yes"]
  }

  measure: distinct_new_customer_count_last_7_days_py {
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", last_7_days_prior_year: "Yes"]
  }

  measure: distinct_new_customer_count_last_30_days_py {
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", last_30_days_prior_year: "Yes"]
  }

  measure: distinct_new_customer_count_last_365_days_py {
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", last_365_days_prior_year: "Yes"]
  }

  measure: distinct_new_customer_count_daily_flash   {
    label: "New Customer Count | Daily Flash"
    description: "Distinct count of order_pubkey, fashioned to produce accurate time period bins."
    hidden: yes
    type: count_distinct
    sql: case when ${daily_flash_times} = 'Yesterday'
              then ${customer_pubkey_yesterday}
              when ${daily_flash_times} = 'Last 7 Days'
              then ${customer_pubkey_last_7_days}
              when ${daily_flash_times} = 'Last 30 Days'
              then ${customer_pubkey_last_30_days}
              when ${daily_flash_times} = 'Last 365 Days'
              then ${customer_pubkey_last_365_days}
              else null
              end;;
    drill_fields: [detail*]
    group_label: "Customer Counts"
    filters: [is_first_order: "yes"]
  }

  measure: distinct_customer_count_running_total  {
    label: "New Customer Count Running Total"
    description: "This running total is used in the daily flash crosstab calculation."
    hidden: yes
    type: running_total
    sql: ${distinct_new_customer_count_daily_flash}  ;;
    group_label: "Customer Counts"
  }

  measure: distinct_repeat_customer_count {
    label: "Repeat Customers"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "No"]
  }

  measure: distinct_new_customer_non_sub_count {
    label: "New Customers | Non-Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "No"]
  }

  measure: distinct_new_customer_sub_count {
    label: "New Customers | Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_subscription_at_first_order: "Yes"]
  }
  measure: distinct_new_customer_non_sub_count_test {
    label: "New Customers | Non-Sub_test"
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_order_placed_from_subscription: "No"]
  }

  measure: distinct_new_customer_sub_count_test {
    label: "New Customers | Sub_test"
    hidden: yes
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "Yes", is_order_placed_from_subscription: "Yes"]
  }

  measure: distinct_repeat_customer_sub_count {
    label: "Repeat Customers | Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "No",is_order_placed_from_subscription: "Yes"]
  }

  measure: distinct_repeat_customer_non_sub_count {
    label: "Repeat Customers | Non-Sub"
    type: count_distinct
    sql: ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [is_first_order: "No",is_order_placed_from_subscription: "No"]
  }

  measure: churned_customers_repeat_subsciption_orders_by_subscribed_at_first{
    label: "Churned Customers-Repeat Subscription Orders by Subscribed at First-Churned"
    description: "Count of churned customers who subscribed at first order and have previously cancelled"
    type: count_distinct
    sql:  ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "Yes",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  measure: churned_customers_repeat_subsciption_at_repeat{
    label: "Churned Customers-Repeat Subscription Orders by Subscribed at First-Churned"
    description: "Count of churned customers who subscribed at first order and have previously cancelled"
    type: count_distinct
    sql:  ${customer_pubkey} ;;
    group_label: "Customer Counts"
    filters: [
      is_first_order: "No",
      customer.is_subscription_at_first_order_company: "No",
      is_order_placed_from_subscription: "Yes",
      customer.has_ever_subscribed_company: "Yes",
      customer.is_customer_subscription_winback_company: "Yes"
    ]
  }

  ### End of customer counts measures

  ### Beginning of net sales measures

  measure: gross_sales_without_taxes_amount_USD  {
    label: "Gross Sales USD"
    type: sum_distinct
    sql:${TABLE}.gross_sales_without_taxes_USD  ;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    html: @{dynamic_currency_formatting_us} ;;
    value_format_name: usd_0
  }

  measure: total_net_sales_USD {
    label: "Total Net Sales USD"
    description: "Gross sales minus discounts, based on timing of when order is placed (does not include impact of deferred revenue) and includes orders that have been refunded. Without taxes and shipping."
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD  ;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    html: @{dynamic_currency_formatting_us} ;;
    value_format: "$#,##0.00"
  }

  measure: total_net_new_sales_USD {
    label: "Total New Net Sales USD"
    description: "Net Sales from new orders (new customers); includes sub and non-sub"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_repeat_sales_USD {
    label: "Total Repeat Net Sales USD"
    description: "Net Sales from all repeat orders (sub and non-sub)"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "No"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_subscription_net_sales_USD {
    type: sum
    description: "Net Sales from all subscription orders"
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_order_placed_from_subscription: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_non_subscription_net_sales_USD {
    label: "Total Non-Subscription Net Sales USD"
    description: "Net Sales from all non-subscription orders"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_order_placed_from_subscription: "No"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_new_subscription_at_first_net_sales_USD {
    label: "New Subscription at First Net Sales USD"
    description: "Net Sales from new orders by customers who subscribed at first order"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_new_non_subscription_at_first_net_sales_USD {
    label: "New Non-Subscription at First Net Sales USD"
    description: "Net Sales from new orders by customers who did not subscribe at first order"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "Yes", customer.is_subscription_at_first_order_company: "No"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_repeat_nonsub_net_sales_USD {
    label: "Repeat Non-Subscription Net Sales USD"
    description: "Repeat Net Sales for repeat non-sub orders"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "No"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_repeat_subscription_net_sales_USD {
    label: "Repeat Subscription Net Sales USD"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "No", is_order_placed_from_subscription: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_repeat_sub_at_first_net_sales_USD {
    label: "Repeat Sub at First Net Sales USD"
    description: "Repeat Net Sales from those who subscribed at first order - includes ALL repeat orders (sub and non-sub)"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [is_first_order: "No", customer.is_subscription_at_first_order_company: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_repeat_sub_at_repeat_net_sales_USD {
    label: "Repeat Sub at Repeat Net Sales USD"
    description: "Repeat Net Sales from those who subscribed at a repeat order - only includes subscription orders"
    type: sum
    sql: ${TABLE}.total_without_taxes_USD ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [
      is_first_order: "No",
      is_order_placed_from_subscription: "Yes",
      customer.is_subscription_at_first_order_company: "No",
      customer.has_ever_subscribed_company: "Yes"
    ]
    html: @{dynamic_currency_formatting_us} ;;
  }

  # The following measures were used in calculated the SDPY comparisons on the daily flash report

  measure: total_net_sales_USD_yesterday_py {
    label: "Total Net Sales USD | Yesterday PY"
    description: "Net sales from the same day of the week of yesterday in the prior year (not same date)."
    hidden: yes
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [yesterday_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_last_7_days_py {
    label: "Total Net Sales USD | Last 7 Days PY"
    description: "Net sales from the same days of the week of 7 days ago of the prior year (not same date)."
    hidden: yes
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [last_7_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_last_30_days_py {
    label: "Total Net Sales USD | Last 30 Days PY"
    description: "Net sales from the same days of 30 days ago of the prior year (not same date)."
    hidden: yes
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [last_30_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_last_365_days_py {
    label: "Total Net Sales USD | Last 365 Days PY"
    description: "Net sales from the same days of 365 days ago of the prior year (not same date)."
    hidden: yes
    type: sum_distinct
    sql: ${TABLE}.total_without_taxes_USD;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    filters: [last_365_days_prior_year: "Yes"]
    html: @{dynamic_currency_formatting_us} ;;
  }

  measure: total_net_sales_USD_running_total {
    label: "Total Net Sales USD Running Total"
    description: "Running total of net sales. This is integral in the daily flash crosstab to ensure accurate reporting in time binning."
    hidden: yes
    type: running_total
    sql: ${total_net_sales_USD} ;;
    drill_fields: [detail*]
    group_label: "Net Sales"
    html: @{dynamic_currency_formatting_us} ;;
  }

  ### End of net sales measures

  ### Beginning of refund measures

  measure: gross_refund_amount_USD  {
    label: "Refund Amount Without Taxes USD"
    type: sum
    sql:${TABLE}.gross_refund_amount_USD  ;;
    drill_fields: [detail*]
    group_label: "Refund Values"
    value_format_name: usd_0
  }

  measure: refund_amount_with_taxes_USD  {
    label: "Refund Amount With Taxes USD"
    type: sum
    sql:${TABLE}.refund_amount_with_taxes_USD  ;;
    drill_fields: [detail*]
    group_label: "Refund Values"
    value_format_name: usd_0
  }

  ### End of refund measures

  ### Beginning of mixed currency measures

  measure: gross_sales_without_taxes_amount  {
    hidden: yes
    type: sum
    sql:${TABLE}.gross_sales_without_taxes  ;;
    drill_fields: [detail*]
    group_label: "Mixed Currencies"
    value_format_name: usd_0
  }

  measure: total_net_sales  {
    hidden: yes
    type: sum
    sql: ${TABLE}.total_without_taxes ;;
    drill_fields: [detail*]
    group_label: "Mixed Currencies"
    value_format: "$#,##0.00"
  }

  measure: gross_refund_amount  {
    hidden: yes
    type: sum
    sql:${TABLE}.gross_refund_amount  ;;
    drill_fields: [detail*]
    group_label: "Mixed Currencies"
    value_format_name: usd_0
  }

  measure: refund_with_taxes_amount  {
    hidden: yes
    type: sum
    sql:${TABLE}.refund_amount_with_taxes  ;;
    drill_fields: [detail*]
    group_label: "Mixed Currencies"
    value_format_name: usd_0
  }

  ### End of mixed currency measures

  ### Beginning of sales proportion measures

  measure: new_pct_net_sales  {
    label: "New % of Net Sales"
    description: "% of Net Sales from new orders"
    type:  number
    sql: 1.0 * ${total_net_new_sales_USD} / NULLIF(${total_net_sales_USD},0);;
    drill_fields: [detail*]
    group_label: "Net Sales %s"
    value_format_name: percent_1
  }

  measure: repeat_pct_net_sales  {
    label: "Repeat % of Net Sales"
    description: "% of Net Sales from repeat orders"
    type:  number
    sql: 1.0 * ${total_repeat_sales_USD} / NULLIF(${total_net_sales_USD},0);;
    drill_fields: [detail*]
    group_label: "Net Sales %s"
    value_format_name: percent_1
  }

  measure: subscription_pct_net_sales  {
    label: "Subscription % of Net Sales"
    description: "% of Net Sales from Subscription - including products that are non-subscription in a subscription order"
    type:  number
    sql: 1.0 * ${total_subscription_net_sales_USD} / NULLIF(${total_net_sales_USD},0);;
    drill_fields: [detail*]
    group_label: "Net Sales %s"
    value_format_name: percent_1
  }

  measure: non_subscription_pct_net_sales  {
    label: "Non-Subscription % of Net Sales"
    description: "% of Net Sales from non-subscription orders"
    type:  number
    sql: 1.0 * ${total_non_subscription_net_sales_USD} / NULLIF(${total_net_sales_USD},0);;
    drill_fields: [detail*]
    group_label: "Net Sales %s"
    value_format_name: percent_1
  }

  ### End of sales proportion measures

  ### Beginning of AOV measures

  measure: gross_average_order_value_USD  {
    label: "Gross AOV USD"
    description: "Gross Sales / Orders"
    type: number
    sql: 1.0 * ${gross_sales_without_taxes_amount_USD} / nullif(${total_number_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: average_order_value_USD  {
    label: "Net Sales AOV USD"
    description: "Total Net Sales / Orders"
    type: number
    sql: 1.0 * ${total_net_sales_USD} / nullif(${total_number_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: sub_average_new_order_value_USD  {
    label: "Subscription AOV USD"
    description: "Net Sales from subscribed orders divided by the number of subscribed orders"
    type: number
    sql: 1.0 * ${total_subscription_net_sales_USD} / nullif(${total_number_of_placed_from_subscription_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

   measure: non_sub_average_new_order_value_USD  {
    label: "Non-Subscription AOV USD"
    description: "Net Sales from non-subscribed orders divided by the number of non-subscribed orders"
    type: number
    sql: 1.0 * ${total_non_subscription_net_sales_USD} / nullif(${total_number_of_non_subscription_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: average_new_order_value_USD  {
    label: "First Order AOV USD"
    description: "Net Sales from new orders divided by the number of new orders"
    type: number
    sql: 1.0 * ${total_net_new_sales_USD} / nullif(${total_number_of_new_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }


  measure: average_repeat_order_value_USD  {
    label: "Repeat Order AOV USD"
    description: "Net Sales from repeat orders divided by the number of repeat orders"
    type: number
    sql: 1.0 * ${total_repeat_sales_USD} / nullif(${total_number_of_repeat_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: new_non_sub_average_order_value_USD  {
    label: "New Non-Sub AOV USD"
    description: "Net Sales from new non-subscription orders divided by the number of new non subscription orders"
    type: number
    sql: 1.0 * ${total_new_non_subscription_at_first_net_sales_USD} / nullif(${total_number_of_new_orders_not_subscribed_at_first},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: new_sub_average_order_value_USD  {
    label: "New Sub at First AOV USD"
    description: "Net Sales from new subsription at first customers divided by the number of new subscription at first orders"
    type: number
    sql: 1.0 * ${total_new_subscription_at_first_net_sales_USD} / nullif(${total_number_of_new_orders_subscribed_at_first},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: repeat_nonsub_average_order_value_USD  {
    label: "Repeat Non-Subscription AOV USD"
    description: "Net Sales from repeat non subscription orders divdied by the number of repeat non subscription orders"
    type: number
    sql: 1.0 * ${total_repeat_nonsub_net_sales_USD} / nullif(${total_number_of_nonsubscription_repeat_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: repeat_sub_average_order_value_USD  {
    label: "Repeat Subscription AOV USD"
    type: number
    sql: 1.0 * ${total_repeat_subscription_net_sales_USD} / nullif(${total_number_of_subscription_repeat_orders},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: repeat_sub_at_first_average_order_value_USD  {
    label: "Repeat Sub at First AOV USD"
    description: "Amount of net sales from repeat sub at first orders divided by the number of repeat sub at first orders - ALL REPEAT ORDERS (INCLUDING NONSUBSCRIPTION)"
    type: number
    sql: 1.0 * ${total_repeat_sub_at_first_net_sales_USD} / nullif(${total_number_of_repeat_orders_by_subscribed_at_first},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  measure: repeat_sub_at_repeat_average_order_value_USD  {
    label: "Repeat Sub at Repeat AOV USD"
    description: "Amount of net sales from repeat sub at repeat orders divided by the number of repeat sub at repeat orders - ONLY SUBSCRIPTION ORDERS"
    type: number
    sql: 1.0 * ${total_repeat_sub_at_repeat_net_sales_USD} / nullif(${total_number_of_subscription_repeat_orders_sub_at_repeat_customers},0) ;;
    drill_fields: [detail*]
    group_label: "Average Order Values"
    value_format_name: usd
  }

  ### End of AOV measures

  ### Beginning of discount measures

  dimension: total_discount_usd {
    hidden: yes
    type:  number
    sql:  ${TABLE}.total_discount_usd ;;
    group_label: "Discount Values"
  }

  measure: total_discount_amount  {
    hidden: yes
    type: sum
    sql:${TABLE}.total_discount  ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: total_discount_amount_USD  {
    type: sum_distinct
    description: "Sum of discount amounts. Includes store credit as a discount"
    sql:${TABLE}.total_discount_usd  ;;
    sql_distinct_key: ${order_pubkey} ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    html: @{dynamic_currency_formatting_us} ;;
    value_format_name: usd_0
  }

  measure: discount_rate_USD  {
    type:  number
    description: "Total Discount Amount / Gross Sales"
    sql: 1.0 * ${total_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: average_discount_value {
    type: average
    sql: ${TABLE}.total_discount_usd ;;
    group_label: "Discount Values"
    value_format_name: usd
  }

  measure: other_discount_amount_USD  {
    description: "Includes: 'balance discount', 'gift discount', 'membership gift discount', 'new customer discount', 'one time membership gift discount', 'winback gift discount'"
    type: sum
    sql:
      ${TABLE}.balance_discount_amount_USD
      + ${TABLE}.gift_discount_amount_USD
      + ${TABLE}.membership_gift_discount_amount_USD
      + ${TABLE}.new_customer_discount_amount_USD
      + ${TABLE}.one_time_membership_gift_discount_amount_USD
      + ${TABLE}.winback_gift_discount_amount_USD;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: other_discount_rate_USD  {
    description: "Other Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${other_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: promotion_discount_amount_USD {
    type: sum
    sql:${TABLE}.promotion_discount_amount_USD  ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: promotion_discount_rate_USD  {
    description: "Promotion Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${promotion_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: referral_advocate_discount_amount_USD  {
    type: sum
    sql:${TABLE}.referral_advocate_discount_amount_USD ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: referral_advocate_discount_rate_USD  {
    description: "Referral Advocate Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${referral_advocate_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: referral_code_discount_amount_USD  {
    type: sum
    sql:${TABLE}.referral_code_discount_amount_USD ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: referral_code_discount_rate_USD  {
    description: "Referral Code Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${referral_code_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: subscription_discount_amount_USD  {
    type: sum
    sql:${TABLE}. subscription_discount_amount_USD ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: subscription_discount_rate_USD  {
    description: "Subscription Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${subscription_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: free_products_discount_amount_USD  {
    type: sum
    sql:${TABLE}. free_products_discount_amount_USD ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: free_products_discount_rate_USD  {
    description: "Subscription Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${free_products_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  measure: store_credit_discount_amount_USD {
    type: sum
    sql: ${TABLE}.store_credit_discount_amount_USD  ;;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: usd_0
  }

  measure: store_credit_discount_rate_USD  {
    description: "Store Credit Discount Amount / Gross Sales"
    type:  number
    sql: 1.0 * ${store_credit_discount_amount_USD} / NULLIF(${gross_sales_without_taxes_amount_USD},0);;
    drill_fields: [detail*]
    group_label: "Discount Values"
    value_format_name: percent_1
  }

  ### End of discount measures

  ### Beginning of customer LTV measures

  measure: customer_ltv_3_months {
    label: "Customer LTV | 3 Months"
    type: number
    sql: IF(SUM(${months_since_first_order}) BETWEEN 0 AND 3, ${total_net_sales_USD}, 0);;
    drill_fields: [detail*]
    group_label: "Customer LTV"
  }

  measure: customer_ltv_6_months {
    label: "Customer LTV | 6 Months"
    type: number
    sql: IF(SUM(${months_since_first_order}) BETWEEN 4 AND 6, ${total_net_sales_USD}, 0);;
    drill_fields: [detail*]
    group_label: "Customer LTV"
  }

  measure: customer_ltv_9_months {
    label: "Customer LTV | 9 Months"
    type: number
    sql: IF(SUM(${months_since_first_order}) BETWEEN 7 AND 9, ${total_net_sales_USD}, 0);;
    drill_fields: [detail*]
    group_label: "Customer LTV"
  }

  measure: customer_ltv_12_months {
    label: "Customer LTV | 12 Months"
    type: number
    sql: IF(SUM(${months_since_first_order}) BETWEEN 10 AND 12, ${total_net_sales_USD}, 0);;
    drill_fields: [detail*]
    group_label: "Customer LTV"
  }

}
