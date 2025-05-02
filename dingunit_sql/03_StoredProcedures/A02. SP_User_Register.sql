USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Register;
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

DELIMITER ;
