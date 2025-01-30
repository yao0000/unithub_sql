USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Client_Create_Client_Data;

CREATE PROCEDURE SP_Client_Create_Client_Data(
    IN p_identity VARCHAR(14),
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
        SELECT CONCAT('Exception caught: Client_Create_Client_Data - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;
    
    INSERT INTO ClientData
		(Identity, Name, Email, Mobile, FirstTime, 
        Address, PostCode, City, State, PaymentDate,
        AgencyCmp, AgentName, AgentPhone, Remarks, AuthorGUID)
	VALUES
		(p_identity, p_name, p_email, p_mobile, p_first_time,
		p_address, p_postcode, p_city, p_state, p_payment_date, 
		p_agency_cmp, p_agent_name, p_agent_phone, p_remarks, p_author_guid);
        
    COMMIT;
    SELECT 'Save successfully' AS Message, 0 AS Response;

END //

DELIMITER ;
