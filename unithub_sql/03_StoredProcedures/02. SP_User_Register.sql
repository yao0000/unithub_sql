USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Register;
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

DELIMITER ;
