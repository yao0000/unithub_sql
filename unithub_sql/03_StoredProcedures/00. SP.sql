USE dingunit;

DELIMITER //

CREATE PROCEDURE SP_User_Login(
    IN p_email VARCHAR(30),
    IN p_password VARCHAR(30)
)
BEGIN
    IF NOT EXISTS ( SELECT 1 FROM User WHERE Email = p_email ) THEN
        SELECT 'Account not found' AS Message, -1 AS Response;
    ELSEIF NOT EXISTS ( SELECT 1 FROM User WHERE HashedPwd = p_password ) THEN
        SELECT 'Incorrect password' AS Message, -2 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Terminated' ) THEN
		SELECT 'Account is blocked' AS Message, -3 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Pending' ) THEN
		SELECT 'Account is pending approval.' AS Message, -4 AS Response;
	ELSEIF EXISTS ( SELECT 1 FROM User WHERE Email = p_Email AND HashedPwd = p_password AND AccessRight = 'Active' ) THEN
		SELECT 'Success' AS Message, 0 AS Response;
	ELSE
		SELECT 'Unknown validation' AS Message, -5 AS Response;
    END IF;
END //


CREATE PROCEDURE SP_User_Register(
    IN p_username VARCHAR(20),
    IN p_email VARCHAR(30),
    IN p_password VARCHAR(30)
)
BEGIN
    IF EXISTS (SELECT 1 FROM User WHERE Email = p_email) THEN
        SELECT 'Account with this email already exists.' AS Message, -1 AS Response;
    ELSEIF EXISTS (SELECT 1 FROM User WHERE Username = p_username) THEN
        SELECT 'Username already exists.' AS Message, -1 AS Response;
    ELSE
        INSERT INTO User (Username, Email, HashedPwd)
        VALUES (p_username, p_email, p_password);
        
        SELECT 'Registration successful' AS Message, 0 AS Response;
    END IF;
END //


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
