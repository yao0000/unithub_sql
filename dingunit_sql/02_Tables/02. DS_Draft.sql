USE dingunit;

DROP TABLE IF EXISTS Draft;

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