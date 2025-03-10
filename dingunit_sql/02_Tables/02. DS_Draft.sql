USE dingunit;

DROP TABLE IF EXISTS Draft;

CREATE TABLE Draft (
    GUID           CHAR(36) NOT NULL DEFAULT (UUID()), 
    AuthorGUID     CHAR(36) NOT NULL,                   
    IdentityType   VARCHAR(50) NOT NULL,               
    IdentityNumber VARCHAR(50) NOT NULL,               
    Title         VARCHAR(14) NOT NULL,                
    FullName      VARCHAR(100) NOT NULL,               
    PreferredName VARCHAR(50) NOT NULL,                
    Email         VARCHAR(30) NOT NULL,               
    Mobile        VARCHAR(15) NOT NULL,                
    Address       VARCHAR(50) NOT NULL,                
    PostCode      VARCHAR(10) NOT NULL,                      
    City          VARCHAR(20) NOT NULL,                
    State         VARCHAR(40) NOT NULL,                
    FirstTime     VARCHAR(1) NOT NULL,                 
    PaymentDate   DATETIME NOT NULL,                   
    AgencyCmp     VARCHAR(50) NOT NULL,                
    AgentName     VARCHAR(30) NOT NULL,               
    AgentPhone    VARCHAR(15) NOT NULL,                
    Remarks       VARCHAR(50) NOT NULL,                
    CreatedTime   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
    Status        VARCHAR(10) NOT NULL DEFAULT 'Unused',
    
    CONSTRAINT PK_Draft PRIMARY KEY (GUID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
