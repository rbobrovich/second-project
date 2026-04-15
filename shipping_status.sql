CREATE TABLE IF NOT EXISTS shipping_status
(
	shippingid INT8 PRIMARY KEY,
	status TEXT NULL,
	state TEXT NULL,
	shipping_start_fact_datetime TIMESTAMP NULL,
	shipping_end_fact_datetime TIMESTAMP NULL
);

INSERT INTO shipping_status (shippingid, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
WITH cte AS (
SELECT shippingid, status, state, state_datetime, ROW_NUMBER() OVER (PARTITION BY shippingid ORDER BY state_datetime DESC) AS row_by_datetime
FROM shipping
)
SELECT cte.shippingid, 
	cte.status, 
	cte.state, 
	c1.state_datetime AS shipping_start_fact_datetime,
	c2.state_datetime AS shipping_end_fact_datetime
FROM cte
LEFT JOIN cte AS c1 ON cte.shippingid = c1.shippingid AND c1.state = 'booked'
LEFT JOIN cte AS c2 ON cte.shippingid = c2.shippingid AND c2.state = 'recieved'
WHERE cte.row_by_datetime = 1;

CREATE INDEX shipping_status_shippingid ON shipping_status(shippingid);