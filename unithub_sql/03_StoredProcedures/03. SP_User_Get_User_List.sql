USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Get_User_List;

CREATE PROCEDURE SP_User_Get_User_List()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An error occurred while fetching the user list' AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS (SELECT 1 FROM User WHERE Role = 'User') THEN
        SELECT 'No data found' AS Message, -1 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
               id, Username, Email, Salt, Role, AccessRight, CreatedDate
        FROM User 
        WHERE Role = 'User';
    END IF;
END //

DELIMITER ;
