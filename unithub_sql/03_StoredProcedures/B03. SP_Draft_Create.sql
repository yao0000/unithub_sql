USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Create;

CREATE PROCEDURE SP_Draft_Create(
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
    IN p_author_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Create - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;
    
    IF EXISTS (SELECT 1 FROM Draft
		WHERE Title = p_title AND Name = p_name AND Email = p_email AND Mobile = p_mobile AND FirstTime = p_first_time
            AND Address = p_address AND PostCode = p_postcode AND City = p_city AND State = p_state
            AND PaymentDate = p_payment_date AND AgencyCmp = p_agency_cmp
            AND AgentName = p_agent_name AND AgentPhone = p_agent_phone
            AND Remarks = p_remarks AND AuthorGUID = p_author_guid) THEN
		SELECT 'Record exists.' AS Message, -3 AS Response;
	ELSE
		INSERT INTO Draft
			(Title, Name, Email, Mobile, FirstTime, 
			Address, PostCode, City, State, PaymentDate,
			AgencyCmp, AgentName, AgentPhone, Remarks, AuthorGUID)
		VALUES
			(p_title, p_name, p_email, p_mobile, p_first_time,
			p_address, p_postcode, p_city, p_state, p_payment_date, 
			p_agency_cmp, p_agent_name, p_agent_phone, p_remarks, p_author_guid);
        
		COMMIT;
		SELECT 'Save successfully' AS Message, 0 AS Response;
	END IF;

END //

DELIMITER ;
