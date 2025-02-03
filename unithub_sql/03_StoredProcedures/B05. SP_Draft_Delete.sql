USE dingunit;
DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Delete;
CREATE PROCEDURE SP_Draft_Delete(
	IN p_draft_guid CHAR(36),
    IN p_modifer_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Reservation_Get_Details - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END; 
    
    START TRANSACTION;
    
    IF (SELECT COUNT(*) FROM Draft WHERE GUID = p_draft_guid AND AuthorGUID = p_modifier_guid) = 0 THEN
		SELECT 'No record found.' AS Message, -3 AS Response;
	ELSE
		DELETE Draft
        WHERE GUID = p_draft_guid
			AND AuthorGUID = p_modifier_guid;
		
        COMMIT;
		SELECT 'Delete successfully.' AS Message, 0 AS Response;
	END IF;
END

DELIMITER ;
