USE dingunit;
DELIMITER //

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

CREATE PROCEDURE SP_Draft_Create(
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
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        ROLLBACK;        
        SELECT CONCAT('Exception: Draft_Create - ', IFNULL(err_msg, 'NULL error message')) AS Message, -1 AS Response;
    END;
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM User WHERE GUID = p_author_guid AND AccessRight = 'Active') THEN
		SELECT 'Invalid Access' AS Message, -2 AS Response;
    ELSEIF EXISTS (SELECT 1 FROM Draft
		WHERE 
            MhubEmail = p_mhub_email         
            AND MhubPassword = p_mhub_password   
            AND ProjectName = p_project_name     
            AND BlockName = p_block_name         
            AND UnitName = p_unit_name           
            AND IdentityType = p_identity_type 
            AND IdentityNumber = p_identity_number
            AND Title = p_title 
            AND FullName = p_full_name 
            AND PreferredName = p_preferred_name 
            AND ClientEmail = p_client_email
            AND CountryCode = p_country_code
            AND Mobile = p_mobile 
            AND Address = p_address 
            AND PostCode = p_postcode 
            AND City = p_city 
            AND State = p_state
            AND Country = p_country
            AND FirstTime = p_first_time 
            AND PaymentDate = p_payment_date 
            AND AgencyCmp = p_agency_cmp 
            AND AgentName = p_agent_name 
            AND AgentPhone = p_agent_phone 
            AND Remarks = p_remarks 
            AND AuthorGUID = p_author_guid
        ) THEN
		SELECT 'Record exists.' AS Message, -3 AS Response;
	ELSE
		INSERT INTO Draft
			(AuthorGUID, IdentityType, MhubEmail, MhubPassword,ProjectName,BlockName, 
            UnitName,  IdentityNumber, Title, FullName, PreferredName, ClientEmail, CountryCode,
        Mobile, Address, PostCode, City, State,CountryName, FirstTime, PaymentDate, AgencyCmp,
        AgentName, AgentPhone, Remarks)
		VALUES
			(p_author_guid, p_identity_type, p_mhub_email, p_mhub_password, p_project_name,p_block_name, 
            p_unit_name, p_identity_number, p_title, p_full_name, p_preferred_name, p_client_email, p_country_code,           
        p_mobile, p_address, p_postcode, p_city, p_state, p_country_name, p_first_time,p_payment_date, p_agency_cmp,
        p_agent_name, p_agent_phone, p_remarks);
        
		COMMIT;
		SELECT 'Save successfully' AS Message, 0 AS Response;
	END IF;

END //

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
            CountryCode  = p_country_code,
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
