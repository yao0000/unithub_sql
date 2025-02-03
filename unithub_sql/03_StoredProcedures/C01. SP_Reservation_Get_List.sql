USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Reservation_Get_Summary;
CREATE PROCEDURE SP_Reservation_Get_Summary(
	IN p_mode CHAR(20),
    IN p_author_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Reservation_Get_Summary - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END; 

    DROP TEMPORARY TABLE IF EXISTS output;
    
    CREATE TEMPORARY TABLE output AS
    SELECT CLIENT.* 
    FROM Reservation AS RESERVE
    INNER JOIN ClientData AS CLIENT ON CLIENT.GUID = RESERVE.ClientDataGUID
    WHERE (p_author_guid IS NULL OR p_author_guid = '' OR CLIENT.GUID = p_author_guid);
    
    IF (SELECT COUNT(*) FROM output) = 0 THEN
		SELECT 'No data found' AS Message, -3 AS Response;
	ELSEIF p_mode = 'SUMMARY' THEN
		SELECT 'Data return successfully' ASMessage, 0 AS Response, output.Name, output.Email
        FROM output;
	ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
			output.Identity, output.Name, output.Email, output.Mobile,
            output.Address, output.PostCode, output.State,
            output.AgencyCmp, output.AgentName, output.AgentPhone, 
            output.Remarks, output.FirstTime, output.PaymentDate
        FROM output;
    END IF;
    
    DROP TEMPORARY TABLE IF EXISTS output;
END //

DELIMITER ;
