USE dingunit;
DELIMITER //

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

CREATE PROCEDURE SP_Reservation_Create_Data(
	IN p_author_guid CHAR(36),
    IN p_status CHAR(20),
    IN p_draft_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Reservation_Create_Data - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END; 
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT COUNT(*) FROM Draft WHERE GUID = p_draft_guid) THEN
		SELECT 'No data found' AS Message, -3 AS Response;
	ELSE
		INSERT INTO Reservation(AuthorGUID, Status, DraftGUID)
        VALUES (p_author_guid, p_status, p_draft_guid);
        COMMIT;
		SELECT 'Action success. Please return to manage page for retrieve the result' AS Message, 0 AS Response;
	END IF;

END //

DELIMITER ;
