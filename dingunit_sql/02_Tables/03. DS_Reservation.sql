USE dingunit;

DROP TABLE IF EXISTS Reservation;

CREATE TABLE Reservation (
	AuthorGUID       CHAR(36)       NOT NULL,
    Status           VARCHAR(20)    NOT NULL,
    CreatedTime      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DraftGUID        CHAR(36)       NOT NULL
);
