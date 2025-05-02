USE dingunit;

DELIMITER //

CREATE PROCEDURE SP_User_Login(
    IN p_email VARCHAR(30)
)
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Login - ', IFNULL(err_msg, 'NULL error message'))  AS Message, -1 AS Response;
    END;
    
    IF NOT EXISTS ( SELECT 1 FROM User WHERE Email = p_email ) THEN
        SELECT 'Account not found' AS Message, -3 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND AccessRight = 'Block' ) THEN
		SELECT 'Account is blocked' AS Message, -5 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND AccessRight = 'Pending' ) THEN
		SELECT 'Account is pending approval.' AS Message, -6 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND AccessRight = 'Active' ) THEN
		SELECT 'Account is found, verifying in progress' AS Message, 0 AS Response, 
        HashedPwd, 
        CAST(GUID AS CHAR) AS GUID
        FROM User
        WHERE Email = p_Email AND AccessRight = 'Active';
	ELSE
		SELECT 'Unknown' AS Message, -2 AS Response;
    END IF;
END //

CREATE PROCEDURE SP_User_Register(
    IN p_username VARCHAR(20),
    IN p_email VARCHAR(30),
    IN p_password VARCHAR(100)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Register - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM User WHERE Email = p_email) THEN
        SELECT 'Email already exists.' AS Message, -3 AS Response;
    ELSE
        INSERT INTO User (Username, Email, HashedPwd, GUID)
        VALUES (p_username, p_email, p_password, UUID());

        COMMIT;
        SELECT 'Registration successful' AS Message, 0 AS Response;
    END IF;
END //

CREATE PROCEDURE SP_User_Get_List(
    IN page_start INT,
    IN page_size INT,
    IN search_term VARCHAR(255)
)
BEGIN
    DECLARE err_msg TEXT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Get_List - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    -- Validate pagination parameters
    IF page_start < 0 OR page_size <= 0 THEN
        SELECT 'Invalid pagination parameters' AS Message, -2 AS Response;
    ELSE
        -- Check if users exist
        IF NOT EXISTS (SELECT 1 FROM user WHERE Role = 'User') THEN
            SELECT 'No users found' AS Message, -3 AS Response;
        ELSE
            -- Return user list with status
            SELECT 
                'Data returned successfully' AS Message,
                0 AS Response,
                GUID, 
                Username, 
                AccessRight
            FROM 
                user
            WHERE 
                Role = 'User' 
                AND (Username LIKE CONCAT('%', IFNULL(search_term, ''), '%'))
            ORDER BY 
                CASE AccessRight
                    WHEN 'Pending' THEN 1
                    WHEN 'Active' THEN 2
                    WHEN 'Banned' THEN 3
                    ELSE 4
                END,
                CreatedTime DESC
            LIMIT page_start, page_size;
        END IF;
    END IF;
END //

CREATE PROCEDURE SP_User_Update_AccessRight(
	IN p_admin_guid VARCHAR(36),
    IN p_user_guid VARCHAR(36),
    IN p_access_right INT
)
BEGIN
	DECLARE err_msg TEXT;
	DECLARE var_access_right VARCHAR(10);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: User_Update_AccessRight - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
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

CREATE PROCEDURE SP_User_Get_Details(
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
            id, Username, Email, Salt, Role, AccessRight, CreatedTime, GUID
        FROM User
        WHERE GUID = p_guid
        LIMIT 1;
    END IF;
END //

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
