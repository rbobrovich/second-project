CREATE TABLE IF NOT EXISTS shipping_country_rates
(
	shipping_country_id INT8 GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	shipping_country TEXT DEFAULT NULL,
	shipping_country_base_rate NUMERIC(14,3)
);

INSERT INTO shipping_country_rates (shipping_country, shipping_country_base_rate)
SELECT DISTINCT shipping_country, shipping_country_base_rate
FROM shipping;

CREATE INDEX shipping_country_rates_shipping_country_id ON shipping_country_rates(shipping_country_id);
