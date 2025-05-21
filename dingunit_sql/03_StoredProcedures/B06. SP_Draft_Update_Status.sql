USE dingunit;
DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Update_Status;
CREATE PROCEDURE SP_Draft_Update_Status(
    IN p_draft_guid CHAR(36),
    IN p_status TINYINT
)
BEGIN
    DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Update_Status - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM Draft WHERE GUID = p_draft_guid) THEN
        SELECT 'Draft not found' AS Message, -3 AS Response;
    ELSE
        UPDATE Draft
        SET 
            Status = p_status
        WHERE GUID = p_draft_guid;
        
        COMMIT;
        SELECT 'Draft status updated successfully' AS Message, 0 AS Response;
    END IF;

END //

DELIMITER ;