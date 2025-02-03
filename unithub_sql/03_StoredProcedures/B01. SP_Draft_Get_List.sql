USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Get_List;

CREATE PROCEDURE SP_Draft_Get_List()
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception caught: Draft_Get_Draft_Summary - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

	DROP TEMPORARY TABLE IF EXISTS output;
    
    CREATE TEMPORARY TABLE output AS
    SELECT * 
    FROM Draft
    WHERE (p_author_guid IS NULL OR p_author_guid = '' OR AuthorGUID = p_author_guid);

    IF (SELECT COUNT(*) FROM output) = 0 THEN
        SELECT 'No data found' AS Message, -3 AS Response;
	ELSE
		SELECT 'Data returned successfully' AS Message, 0 AS Response,
			output.Name, output.Email, output.GUID
		FROM output
    END IF;
    
	DROP TEMPORARY TABLE IF EXISTS output;

END //

DELIMITER ;
