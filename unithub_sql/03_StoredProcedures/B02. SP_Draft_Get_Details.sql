USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Get_Details;

CREATE PROCEDURE SP_Draft_Get_Details(
    IN p_draft_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception caught: Draft_Get_Draft_Details - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    CREATE TEMPORARY TABLE output AS
    SELECT * 
    FROM Draft
    WHERE (p_draft_guid IS NULL OR p_draft_guid = '' OR GUID = p_draft_guid)
    LIMIT 1;

    IF (SELECT COUNT(*) FROM output) = 0 THEN
        SELECT 'No data found' AS Message, -3 AS Response;
	ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
			output.Title, output.Name, output.Email, output.Mobile,
            output.Address, output.PostCode, output.State,
            output.AgencyCmp, output.AgentName, output.AgentPhone, 
            output.Remarks, output.FirstTime, output.PaymentDate, output.GUID
        FROM output;
    END IF;

END //

DELIMITER ;
