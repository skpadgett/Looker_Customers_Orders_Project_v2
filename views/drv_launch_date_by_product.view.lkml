view: drv_launch_date_by_product {


    derived_table: {
      sql:
      select distinct product_name, product_target_sub_category, target_sub_category, min(order_date_at_tz_ny) over (partition by product_name order by product_name) as launch_date FROM `customer.customer_bi_datamart_growth_customer_ltv_customer_order.order_items`
      where item_type ='formula' ;;
    }

  dimension: product_name{
    primary_key: yes
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: target_sub_category {
    type: string
    sql: ${TABLE}.target_sub_category ;;
  }

    dimension: product_target_sub_category {
      type: string
      sql: ${TABLE}.product_target_sub_category ;;
    }

  dimension_group: launch_date {
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.launch_date ;;
  }


  }
