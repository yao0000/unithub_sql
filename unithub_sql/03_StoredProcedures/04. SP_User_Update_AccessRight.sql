USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Update_AccessRight;
CREATE PROCEDURE SP_User_Update_AccessRight(
	IN p_admin_guid VARCHAR(36),
    IN p_user_guid VARCHAR(36),
    IN p_access_right INT
)
BEGIN
	DECLARE var_access_right VARCHAR(10);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Exception catch: SP_User_Update_AccessRight' AS Message, -1 AS Response;
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS ( SELECT 1 FROM User WHERE Role = 'Admin' AND GUID = p_admin_guid ) THEN
		SELECT 'Invalid access' AS Message, -3 AS Response;
	ELSEIF NOT EXISTS ( SELECT 1 FROM User WHERE GUID = p_user_guid ) THEN 
		SELECT 'User not found' AS Message, -4 AS Response;
	ELSE
		IF (p_access_right = 0) THEN
			SET var_access_right = 'Active';
		ELSEIF (p_access_right = 1) THEN
			SET var_access_right = 'Pending';
		ELSE
			SET var_access_right = 'Block';
		END IF;
            
		UPDATE User
        SET AccessRight = var_access_right
        WHERE GUID = p_user_guid;
        
        COMMIT;
        SELECT 'Update successfully' AS Message, 0 AS Response;
	END IF;
END //

DELIMITER ;