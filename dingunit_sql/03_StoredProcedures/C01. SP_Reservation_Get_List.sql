DELIMITER //
DROP PROCEDURE IF EXISTS SP_Reservation_Get_List;
CREATE PROCEDURE SP_Reservation_Get_List(
    IN p_author_guid CHAR(36)
)
BEGIN
    DECLARE err_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Reservation_Get_List - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    IF (SELECT COUNT(*) FROM Reservation WHERE AuthorGUID = p_author_guid) = 0 THEN
        SELECT 'No reservations found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
            FullName, Email, Status, CreatedTime, GUID
        FROM Reservation
        WHERE AuthorGUID = p_author_guid;
    END IF;
END //
DELIMITER ;
