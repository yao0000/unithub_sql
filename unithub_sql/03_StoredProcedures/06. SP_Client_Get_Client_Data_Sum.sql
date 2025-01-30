USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Client_Get_Client_Data_Summary;

CREATE PROCEDURE SP_Client_Get_Client_Data_Summary(
    IN p_author_guid CHAR(36)
)
BEGIN
	DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception caught: Client_Get_Client_Data_Summary - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    DROP TEMPORARY TABLE IF EXISTS temp_client_data_sum;

    CREATE TEMPORARY TABLE temp_client_data_sum AS
    SELECT * 
    FROM ClientData
    WHERE (p_author_guid IS NULL OR p_author_guid = '' OR AuthorGUID = p_author_guid);

    IF (SELECT COUNT(*) FROM temp_client_data_sum) = 0 THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, temp_client_data_sum.* 
        FROM temp_client_data_sum;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS temp_client_data_sum;
END //

DELIMITER ;
