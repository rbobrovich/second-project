CREATE OR REPLACE VIEW shipping_datamart AS 
SELECT shippingid, 
	vendorid, 
	transfer_type,
	EXTRACT(DAY FROM shipping_end_fact_datetime - shipping_start_fact_datetime) AS full_day_at_shipping,
	shipping_end_fact_datetime > shipping_plan_datetime AS is_delay,
	shipping_status.status = 'finished' AS is_shipping_finish,
	CASE WHEN shipping_end_fact_datetime > shipping_plan_datetime THEN EXTRACT(DAY FROM shipping_end_fact_datetime - shipping_plan_datetime) ELSE 0 END AS delay_day_at_shipping,
	payment_amount,
	payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate) AS vat,
	payment_amount * agreement_commission AS profit
FROM shipping_info
LEFT JOIN shipping_transfer USING (transfer_type_id)
LEFT JOIN shipping_status USING (shippingid)
LEFT JOIN shipping_country_rates USING (shipping_country_id)
LEFT JOIN shipping_agreement USING (agreementid)