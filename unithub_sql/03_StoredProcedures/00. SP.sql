USE dingunit;

DELIMITER //

CREATE PROCEDURE SP_User_Login(
    IN p_email VARCHAR(30),
    IN p_password VARCHAR(30)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Exception catch: SP_User_Login' AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS ( SELECT 1 FROM User WHERE Email = p_email ) THEN
        SELECT 'Account not found' AS Message, -3 AS Response;
    ELSEIF NOT EXISTS ( SELECT 1 FROM User WHERE HashedPwd = p_password ) THEN
        SELECT 'Incorrect password' AS Message, -4 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Block' ) THEN
		SELECT 'Account is blocked' AS Message, -5 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Pending' ) THEN
		SELECT 'Account is pending approval.' AS Message, -6 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Active' ) THEN
		SELECT 'Success' AS Message, 0 AS Response, 
        CAST(GUID AS CHAR) AS GUID 
        FROM User
        WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Active';
	ELSE
		SELECT 'Unknown' AS Message, -2 AS Response;
    END IF;
END //


CREATE PROCEDURE SP_User_Register(
    IN p_username VARCHAR(20),
    IN p_email VARCHAR(30),
    IN p_password VARCHAR(30)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Exception caught: SP_User_Register' AS Message, -1 AS Response;
    END;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM User WHERE Email = p_email) THEN
        SELECT 'Email already exists.' AS Message, -3 AS Response;
    ELSEIF EXISTS (SELECT 1 FROM User WHERE Username = p_username) THEN
        SELECT 'Username already exists.' AS Message, -4 AS Response;
    ELSE
        INSERT INTO User (Username, Email, HashedPwd, GUID)
        VALUES (p_username, p_email, p_password, UUID());

        COMMIT;
        SELECT 'Registration successful' AS Message, 0 AS Response;
    END IF;
END //


CREATE PROCEDURE SP_User_Get_User_List()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Exception caught: SP_User_Get_User_List' AS Message, -1 AS Response;
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
