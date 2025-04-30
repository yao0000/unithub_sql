DELIMITER //
DROP PROCEDURE IF EXISTS SP_Draft_Get_List;
CREATE PROCEDURE SP_Draft_Get_List(
    IN p_author_guid CHAR(36)
)
BEGIN
    DECLARE err_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Get_List - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    IF (SELECT COUNT(*) FROM Draft WHERE AuthorGUID = p_author_guid) = 0 THEN
        SELECT 'No drafts found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
            FullName, ClientEmail, CreatedTime, GUID, Status
        FROM Draft
        WHERE AuthorGUID = p_author_guid;
    END IF;
END //
DELIMITER ;

