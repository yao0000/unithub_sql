DELIMITER //
DROP PROCEDURE IF EXISTS SP_Draft_Delete;
CREATE PROCEDURE SP_Draft_Delete(
    IN p_draft_guid CHAR(36)
)
BEGIN
    DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Delete - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END; 

    START TRANSACTION;
    
    IF (SELECT COUNT(*) FROM Draft WHERE GUID = p_draft_guid) = 0 THEN
        SELECT 'No record found.' AS Message, -3 AS Response;
    ELSEIF EXISTS (SELECT 1 FROM Reservation WHERE GUID = p_draft_guid) THEN
        SELECT 'Transaction existing, data is not allowed to be deleted' AS Message, -4 AS Response; 
    ELSE
        DELETE FROM Draft WHERE GUID = p_draft_guid;
        COMMIT;
        SELECT 'Draft deleted successfully.' AS Message, 0 AS Response;
    END IF;
END //
DELIMITER ;
