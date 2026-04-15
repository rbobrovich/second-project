CREATE TABLE IF NOT EXISTS shipping_transfer
(
	transfer_type_id INT8 GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	transfer_type TEXT NULL,
	transfer_model TEXT NULL,
	shipping_transfer_rate NUMERIC(14, 3) NULL
);

INSERT INTO shipping_transfer (transfer_type, transfer_model, shipping_transfer_rate)
SELECT DISTINCT std[1] AS transfer_type, 
	std[2] AS transfer_model, 
	shipping_transfer_rate::NUMERIC(14, 3)
FROM (SELECT REGEXP_SPLIT_TO_ARRAY(shipping_transfer_description, ':') AS std, shipping_transfer_rate
	  FROM shipping) AS sp;

CREATE INDEX shipping_transfer_transfer_type_id ON shipping_transfer(transfer_type_id);
