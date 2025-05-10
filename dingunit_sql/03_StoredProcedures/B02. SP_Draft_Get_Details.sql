DELIMITER //
DROP PROCEDURE IF EXISTS SP_Draft_Get_Details;
CREATE PROCEDURE SP_Draft_Get_Details(
    IN p_author_guid CHAR(36)
)
BEGIN
    DECLARE err_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Get_Details - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    IF (SELECT COUNT(*) FROM Draft WHERE GUID = p_author_guid) = 0 THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
            MhubEmail,MhubPassword,ProjectName,BlockName,UnitName,
            IdentityType,IdentityNumber,Title,FullName,PreferredName,         
            ClientEmail, CountryCode, Mobile, Address, PostCode, City, 
            State, Country, FirstTime, PaymentDate, 
            AgencyCmp, AgentName, AgentPhone, Remarks, CreatedTime, GUID, AuthorGUID

        FROM Draft
        WHERE GUID = p_author_guid
        LIMIT 1;
    END IF;

END //
DELIMITER ;
