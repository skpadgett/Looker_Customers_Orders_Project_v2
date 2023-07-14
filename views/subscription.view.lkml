view: subscription {
  sql_table_name: `customer.customer_bi_datamart_subscription.subscription`
    ;;

  dimension: event_timestamp {
    type: date_time
    description: "The grain of this dataset is each action (event) related to a customers actions pertaining to subscriptions"
    sql:  ${TABLE}.subscription_updated_at ;;
  }

  dimension_group: event_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    description: "date based on event_timestamp field"
    sql:  ${TABLE}.subscription_updated_at ;;
  }

  dimension: customer_pubkey {
    type: string
    description: "the customer id associated with the customer taking the action"
    sql: ${TABLE}.customer_pubkey ;;
  }

  dimension: subscription_pubkey {
    type: string
    description: "The subscription identifier associated with the subscription that has the action"
    sql: ${TABLE}.subscription_pubkey ;;
  }

  dimension: subscription_category {
    type: string
    description: "Either hair or skin for now"
    sql: ${TABLE}.subscription_category ;;
  }

  dimension: subscription_sub_category {
    type: string
    description: "Haircare, supplements..."
    sql: ${TABLE}.subscription_sub_category ;;
  }

  dimension: event_action_name {
    type: string
    description: "The name of the action that the customer took related subscription"
    sql: ${TABLE}.event_action_name ;;
  }

  dimension: change_type_company {
    type: string
    description: "How would we describe the subscription as a result of the customer taking action"
    sql: ${TABLE}.change_type_company ;;
  }

  dimension: change_type_category {
    type: string
    description: "How we would describe the subscription as a result of the customer taking action but at the subcategory level"
    sql: ${TABLE}.change_type_category ;;
  }

  dimension: customer_subscription_status {
    type: string
    description: "The 'new' status now associated with the customer based on the action the customer took; at customer level"
    sql: ${TABLE}.customer_subscription_status_company ;;
  }

  dimension: customer_subscription_status_supplements {
    type: string
    description: "The 'new' status now associated with the customer based on the action the customer took; at customer level"
    sql: ${TABLE}.customer_subscription_status_supplements ;;
  }

  dimension: customer_subscription_status_topicals {
    type: string
    description: "The 'new' status now associated with the customer based on the action the customer took; at customer level"
    sql: ${TABLE}.customer_subscription_status_topicals ;;
  }

  dimension_group: dag_ts_utc {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dag_ts_utc ;;
    hidden: yes
  }

  measure: count {
    type: number
    sql: count(*);;
  }
}
