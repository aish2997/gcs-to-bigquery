MERGE `${project_id}.assessment_srv.inventory_srv` srv
USING (
  SELECT * FROM (
    SELECT
      productId,
      `name`,
      quantity,
      category,
      subCategory,
      CONCAT(
        COALESCE(productId, 'null'), '~',
        COALESCE(`name`, 'null'), '~',
        COALESCE(CAST(quantity as STRING), 'null'), '~',
        COALESCE(category, 'null'), '~',
        COALESCE(subCategory, 'null')
      ) AS inventory_rk,
      ROW_NUMBER() OVER (
        PARTITION BY 
          productId,
          `name`,
          quantity,
          category,
          subCategory
      ) AS rnk
    FROM `${project_id}.assessment_stg.inventory_hst_v01`
  ) 
  WHERE rnk = 1
) stg
ON MD5(srv.inventory_rk) = MD5(stg.inventory_rk)
WHEN NOT MATCHED THEN 
INSERT (
  productId,
  `name`,
  quantity,
  category,
  subCategory,
  inventory_rk,
  serving_ingestion_time
)
VALUES (
  stg.productId,
  stg.`name`,
  stg.quantity,
  stg.category,
  stg.subCategory,
  MD5(inventory_rk),
  CURRENT_TIMESTAMP()
);