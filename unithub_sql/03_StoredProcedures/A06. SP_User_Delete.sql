USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Delete;
CREATE PROCEDURE SP_User_Delete(
	IN p_admin_guid VARCHAR(36),
    IN p_user_guid VARCHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Delete - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS ( SELECT 1 FROM User WHERE Role = 'Admin' AND GUID = p_admin_guid ) THEN
		SELECT 'Invalid access' AS Message, -3 AS Response;
	ELSEIF NOT EXISTS ( SELECT 1 FROM User WHERE GUID = p_user_guid ) THEN 
		SELECT 'User not found' AS Message, -4 AS Response;
	ELSE
		DELETE FROM User
        WHERE GUID = p_user_guid;
        
        COMMIT;
        SELECT 'Delete successfully' AS Message, 0 AS Response;
	END IF;
END //

DELIMITER ;