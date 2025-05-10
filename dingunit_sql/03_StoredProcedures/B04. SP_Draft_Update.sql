USE dingunit;
DELIMITER //

DROP PROCEDURE IF EXISTS SP_Draft_Update;
CREATE PROCEDURE SP_Draft_Update(
    IN p_draft_guid CHAR(36),
    IN p_author_guid CHAR(36),
    IN p_mhub_email VARCHAR(50),        
    IN p_mhub_password VARCHAR(50),     
    IN p_project_name VARCHAR(100),     
    IN p_block_name VARCHAR(20),        
    IN p_unit_name VARCHAR(20),         
    IN p_identity_type VARCHAR(50),
    IN p_identity_number VARCHAR(50),
    IN p_title VARCHAR(14),
    IN p_full_name VARCHAR(100),
    IN p_preferred_name VARCHAR(50),
    IN p_client_email VARCHAR(30),
    IN p_country_code VARCHAR(50),        
    IN p_mobile VARCHAR(15),
    IN p_address VARCHAR(50),
    IN p_postcode INT,
    IN p_city VARCHAR(20),
    IN p_state VARCHAR(40),
    IN p_country VARCHAR(50),
    IN p_first_time VARCHAR(1),
    IN p_payment_date DATETIME,
    IN p_agency_cmp VARCHAR(50),
    IN p_agent_name VARCHAR(30),
    IN p_agent_phone VARCHAR(15),
    IN p_remarks VARCHAR(50)
)
BEGIN
    DECLARE err_msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('Exception: Draft_Update - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;

    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM Draft WHERE GUID = p_draft_guid AND AuthorGUID = p_author_guid) THEN
        SELECT 'Draft not found or access denied' AS Message, -3 AS Response;
    ELSE
        UPDATE Draft
        SET 
            MhubEmail      = p_mhub_email,        
            MhubPassword   = p_mhub_password,     
            ProjectName    = p_project_name,      
            BlockName      = p_block_name,        
            UnitName       = p_unit_name,         
            IdentityType   = p_identity_type,
            IdentityNumber = p_identity_number,
            Title          = p_title,
            FullName       = p_full_name,
            PreferredName  = p_preferred_name,
            ClientEmail    = p_client_email,
            CountryCode    = p_country_code,
            Mobile         = p_mobile,
            Address        = p_address,
            PostCode       = p_postcode,
            City           = p_city,
            State          = p_state,
            Country        = p_country,
            FirstTime      = p_first_time,
            PaymentDate    = p_payment_date,
            AgencyCmp      = p_agency_cmp,
            AgentName      = p_agent_name,
            AgentPhone     = p_agent_phone,
            Remarks        = p_remarks,
            CreatedTime    = NOW() 
        WHERE GUID = p_draft_guid AND AuthorGUID = p_author_guid;
        
        COMMIT;
        SELECT 'Draft updated successfully' AS Message, 0 AS Response;
    END IF;

END //

DELIMITER ;
