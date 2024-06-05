MERGE `${project_id}.assessment_srv.orders_srv` srv
USING (
  SELECT * FROM (
    SELECT
      orderId,
      productId,
      currency,
      quantity,
      shippingCost,
      amount,
      channel,
      channelGroup,
      campaign,
      `dateTime`,
      CONCAT(
        COALESCE(orderId, 'null'), '~',
        COALESCE(productId, 'null'), '~',
        COALESCE(currency, 'null'), '~',
        COALESCE(CAST(quantity AS STRING), 'null'), '~',
        COALESCE(CAST(shippingCost AS STRING), 'null'),'~',
        COALESCE(CAST(amount AS STRING), 'null'),'~',
        COALESCE(channel, 'null'),'~',
        COALESCE(channelGroup, 'null'),'~',
        COALESCE(campaign, 'null'),'~',
        COALESCE(CAST(`dateTime` as STRING), 'null')
      ) AS orders_rk,
      ROW_NUMBER() OVER (
        PARTITION BY 
          orderId,
      productId,
      currency,
      quantity,
      CAST(shippingCost AS STRING),
      CAST(amount AS STRING),
      channel,
      channelGroup,
      campaign,
      `dateTime`
      ) AS rnk
    FROM `${project_id}.assessment_stg.orders_hst_v01`
  ) 
  WHERE rnk = 1
) stg
ON MD5(srv.orders_rk) = MD5(stg.orders_rk)
WHEN NOT MATCHED THEN 
INSERT (
orderId,
      productId,
      currency,
      quantity,
      shippingCost,
      amount,
      channel,
      channelGroup,
      campaign,
      `dateTime`,
  orders_rk,
  serving_ingestion_time
)
VALUES (
  stg.orderId,
      stg.productId,
      stg.currency,
      stg.quantity,
      stg.shippingCost,
      stg.amount,
      stg.channel,
      stg.channelGroup,
      stg.campaign,
      stg.`dateTime`,
  MD5(orders_rk),
  CURRENT_TIMESTAMP()
);