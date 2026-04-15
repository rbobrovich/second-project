CREATE TABLE IF NOT EXISTS shipping_info
(
	shippingid INT8 PRIMARY KEY,
	transfer_type_id INT8,
	shipping_country_id INT8,
	agreementid INT8,
	vendorid INT8,
	payment_amount numeric(14, 2) NULL,
	shipping_plan_datetime timestamp NULL,
	FOREIGN KEY (transfer_type_id) REFERENCES shipping_transfer (transfer_type_id) ON UPDATE CASCADE,
	FOREIGN KEY (agreementid) REFERENCES shipping_agreement (agreementid) ON UPDATE CASCADE,
	FOREIGN KEY (shipping_country_id) REFERENCES shipping_country_rates (shipping_country_id) ON UPDATE CASCADE
);

INSERT INTO shipping_info (shippingid, transfer_type_id, shipping_country_id, agreementid, vendorid, payment_amount, shipping_plan_datetime)
SELECT DISTINCT shippingid,
	shipping_transfer.transfer_type_id,
	shipping_country_rates.shipping_country_id,
	split_part(vendor_agreement_description, ':', 1)::INT8 AS agreementid,
	vendorid, 
	payment_amount, 
	shipping_plan_datetime
FROM shipping
LEFT JOIN shipping_transfer ON shipping.shipping_transfer_description = CONCAT_WS(':', shipping_transfer.transfer_type, shipping_transfer.transfer_model)
LEFT JOIN shipping_country_rates USING (shipping_country);

CREATE INDEX shipping_info_shippingid ON shipping_info(shippingid);