USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Update;

CREATE PROCEDURE SP_Draft_Update(
    IN p_title VARCHAR(14),
    IN p_name VARCHAR(50),
    IN p_email VARCHAR(30),
    IN p_mobile VARCHAR(15),
    IN p_first_time VARCHAR(1),
    IN p_address VARCHAR(50),
    IN p_postcode INT,
    IN p_city VARCHAR(20),
    IN p_state VARCHAR(20),
    IN p_payment_date DATETIME, 
    IN p_agency_cmp VARCHAR(50),
    IN p_agent_name VARCHAR(30),
    IN p_agent_phone VARCHAR(15),
    IN p_remarks VARCHAR(50),
    IN p_draft_guid CHAR(36),
    IN p_reader_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Update - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM Draft WHERE GUID = p_draft_guid AND AuthorGUID = p_reader_guid) THEN
		SELECT 'Record not found' AS Message, -3 AS Response;
	ELSE
		UPDATE Draft
		SET 
			Title = p_title,
			Name = p_name,
			Email = p_email,
			Mobile = p_mobile,
			FirstTime = p_first_time,
			Address = p_address,
			PostCode = p_postcode,
			City = p_city,
			State = p_state,
			PaymentDate = p_payment_date,
			AgencyCmp = p_agency_cmp,
			AgentName = p_agent_name,
			AgentPhone = p_agent_phone,
			Remarks = p_remarks
		WHERE GUID = p_draft_guid AND AuthorGUID = p_reader_guid;
        
		COMMIT;
		SELECT 'Update successfully' AS Message, 0 AS Response;
	END IF;

END //

DELIMITER ;
