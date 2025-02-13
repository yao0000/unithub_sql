USE dingunit;

CREATE TABLE User (
	ID            BIGINT         AUTO_INCREMENT NOT NULL,
	Username      VARCHAR(20)    NULL,
	Email         VARCHAR(30)    NULL,
	HashedPwd     VARCHAR(30)    NULL,
	Salt          VARCHAR(50)    NULL,
	Role          VARCHAR(5)     NOT NULL DEFAULT ('User'),
	AccessRight   VARCHAR(10)    NOT NULL DEFAULT ('Pending'),
    CreatedTime   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    GUID          CHAR(36)       NOT NULL DEFAULT (UUID()),
	
	CONSTRAINT PK_DS_USER PRIMARY KEY (ID),
    CONSTRAINT UQ_GUID UNIQUE (GUID)
);

CREATE TABLE Draft(
	ID            BIGINT         AUTO_INCREMENT NOT NULL,
    Title         VARCHAR(14)    NULL,
    Name          VARCHAR(50)    NULL,
    Email         VARCHAR(30)    NULL,
    Mobile        VARCHAR(15)    NULL,
    FirstTime     VARCHAR(1)     NULL,
    Address       VARCHAR(50)    NULL,
    PostCode      INT            NULL,
    City          VARCHAR(20)    NULL,
    State         VARCHAR(20)    NULL,
    PaymentDate   DATETIME       NOT NULL,
    AgencyCmp     VARCHAR(50)    NOT NULL,
    AgentName     VARCHAR(30)    NOT NULL,
    AgentPhone    VARCHAR(15)    NOT NULL,
    Remarks       VARCHAR(50)    NOT NULL,
    CreatedTime   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    AuthorGUID    CHAR(36)       NOT NULL,
    GUID          CHAR(36)       NOT NULL DEFAULT (UUID()),
	
	CONSTRAINT PK_ClientData PRIMARY KEY (ID),
    CONSTRAINT UQ_GUID UNIQUE (GUID)
);

CREATE TABLE Reservation (
	ID               BIGINT         AUTO_INCREMENT NOT NULL,
	AuthorGUID       CHAR(36)       NOT NULL,
    Status           VARCHAR(20)    NOT NULL,
    CreatedTime      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ClientDataGUID   CHAR(36)       NOT NULL DEFAULT (UUID()),
	
	CONSTRAINT PK_Reservation PRIMARY KEY (ID),
    CONSTRAINT UQ_GUID UNIQUE (ClientDataGUID)
);