DELIMITER //

CREATE PROCEDURE `SP_User_Get_Details`(
	IN p_guid VARCHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception caught: SP_User_Get_Details', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS (SELECT 1 FROM User WHERE GUID = p_guid) THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        -- Fetch user details regardless of role
        SELECT 'Data returned successfully' AS Message, 0 AS Response,
            ID, Username, Email, Role, AccessRight, CreatedTime, GUID
        FROM User
        WHERE GUID = p_guid
        LIMIT 1;
    END IF;
END

DELIMITER ;