USE dingunit;

DROP TABLE IF EXISTS ClientData;

CREATE TABLE ClientData(
	ID            BIGINT         AUTO_INCREMENT NOT NULL,
    Identity      VARCHAR(14)    NULL,
    FullName      VARCHAR(50)    NULL,
    Email         VARCHAR(30)    NULL,
    Mobile        VARCHAR(15)    NULL,
    FirstTime     VARCHAR(1)     NULL,
    Address       VARCHAR(50)    NULL,
    PostCode      INT            NULL,
    City          VARCHAR(20)    NULL,
    State         VARCHAR(20)    NULL,
    PaymentDate   DATETIME       NOT NULL,
    AgenctCmp     VARCHAR(50)    NOT NULL,
    AgentName     VARCHAR(30)    NOT NULL,
    AgentPhone    VARCHAR(15)    NOT NULL,
    Remarks       VARCHAR(50)    NOT NULL,
    CreatedTime   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UserGUID      CHAR(36)       NOT NULL,
	
	CONSTRAINT PK_DS_USER PRIMARY KEY (ID),
    CONSTRAINT UQ_GUID UNIQUE (UserGUID)
);