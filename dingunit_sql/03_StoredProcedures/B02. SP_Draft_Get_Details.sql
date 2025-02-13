USE dingunit;

DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Get_Details;

CREATE PROCEDURE SP_Draft_Get_Details(
    IN p_draft_guid CHAR(36),
    IN p_author_guid CHAR(36)
)
BEGIN
    DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Get_Details - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    -- Check if the draft exists for the provided author and draft GUID
    IF (SELECT COUNT(*) FROM Draft WHERE AuthorGUID = p_author_guid AND GUID = p_draft_guid) = 0 THEN
        SELECT 'No data found' AS Message, -3 AS Response;
    ELSE
        -- Select the draft details and join with the User table to get additional info
        SELECT 'Data returned successfully' AS Message, 0 AS Response, 
            Draft.Title, Draft.Name, Draft.Email, Draft.Mobile,
            Draft.Address, Draft.PostCode, Draft.City, Draft.State, Draft.PaymentDate, 
            Draft.AgencyCmp, Draft.AgentName, Draft.AgentPhone, 
            Draft.Remarks, Draft.FirstTime, 
            Draft.CreatedTime, Draft.GUID, 
            User.HashedPwd AS Password
        FROM Draft
        INNER JOIN User ON Draft.AuthorGUID = User.GUID
        WHERE Draft.AuthorGUID = p_author_guid AND Draft.GUID = p_draft_guid
        LIMIT 1;
    END IF;
END //

DELIMITER ;
