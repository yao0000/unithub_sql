USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Login;

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

DELIMITER ;
