USE dingunit;

DROP TABLE IF EXISTS User;

CREATE TABLE User (
	ID            BIGINT         AUTO_INCREMENT NOT NULL,
	Username      VARCHAR(20)    NULL,
	Email         VARCHAR(30)    NULL,
	HashedPwd     VARCHAR(30)    NULL,
	Salt          VARCHAR(50)     NULL,
	Role          VARCHAR(5)     NOT NULL DEFAULT ('User'),
	AccessRight   VARCHAR(10)    NOT NULL DEFAULT ('Pending'),
    CreatedDate   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT PK_DS_USER PRIMARY KEY CLUSTERED (ID ASC)
);
