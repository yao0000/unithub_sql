USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Get_List;

CREATE PROCEDURE SP_User_Get_List()
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Get_List - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS (SELECT 1 FROM User WHERE Role = 'User') THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response,
            id, Username, Email, Salt, Role, AccessRight, CreatedTime, GUID
        FROM User
        WHERE Role = 'User';
    END IF;
END //

DELIMITER ;
