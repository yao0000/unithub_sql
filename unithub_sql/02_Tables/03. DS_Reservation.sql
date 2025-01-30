USE dingunit;

DROP TABLE IF EXISTS Reservation;

CREATE TABLE Reservation (
	ID               BIGINT         AUTO_INCREMENT NOT NULL,
	AuthorGUID       CHAR(36)       NOT NULL,
    Status           VARCHAR(20)    NOT NULL,
    CreatedTime      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ClientDataGUID   CHAR(36)       NOT NULL DEFAULT (UUID()),
	
	CONSTRAINT PK_Reservation PRIMARY KEY (ID),
    CONSTRAINT UQ_GUID UNIQUE (ClientDataGUID)
);
