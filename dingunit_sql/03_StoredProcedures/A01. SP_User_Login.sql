USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Login;

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

DELIMITER ;
