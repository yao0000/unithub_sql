
DELIMITER //

DROP PROCEDURE IF EXISTS SP_User_Get_List;

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


DELIMITER ;
