CREATE TABLE IF NOT EXISTS shipping_agreement
(
	agreementid INT8 NOT NULL PRIMARY KEY,
	agreement_number BIGINT DEFAULT NULL,
	agreement_rate NUMERIC(14,3) DEFAULT NULL,
	agreement_commission NUMERIC(14,3) DEFAULT NULL
);

INSERT INTO shipping_agreement (agreementid, agreement_number, agreement_rate, agreement_commission)
SELECT DISTINCT vad[1]::INT8 AS agreementid, 
	SPLIT_PART(vad[2], '-', 2)::BIGINT AS agreement_number, 
	vad[3]::NUMERIC(14,3) AS agreement_rate, 
	vad[4]::NUMERIC(14,3) AS agreement_commission
FROM (SELECT REGEXP_SPLIT_TO_ARRAY(vendor_agreement_description, ':') AS vad
	  FROM shipping) AS sp
ORDER BY agreementid;

CREATE INDEX shipping_agreement_agreementid ON shipping_agreement(agreementid);