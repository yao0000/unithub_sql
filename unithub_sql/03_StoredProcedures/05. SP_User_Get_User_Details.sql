DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Get_User_Details;

CREATE PROCEDURE SP_User_Get_User_Details(
	IN p_guid VARCHAR(36)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Exception caught: SP_User_Get_User_Details' AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS (SELECT 1 FROM User WHERE Role = 'User' AND GUID = p_guid) THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response,
            id, Username, Email, Salt, Role, AccessRight, CreatedTime, GUID
        FROM User
        WHERE Role = 'User'
        AND GUID = p_guid;
    END IF;
END //

DELIMITER ;
