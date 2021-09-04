/*
	Bài 3: Quản lý đề tài luận văn tốt nghiệp đại học
*/
CREATE TABLE SINHVIEN
	(
		MSSV 		CHAR(6) 								NOT NULL 		PRIMARY KEY,
		TENSV 		NVARCHAR2(40) 				NOT NULL,
		SODT 		CHAR(10)							NULL,
		LOP 			NVARCHAR2(20) 				NULL,
		DIACHI 	NVARCHAR2(100) 				NOT NULL
	);

CREATE TABLE DETAI
	(
		MSDT 		CHAR(6) 								NOT NULL 		PRIMARY KEY,
		TENDT 		NVARCHAR2(100) 				NOT NULL
	);

CREATE TABLE SV_DETAI
	(
		MSSV 		CHAR(6) 								NOT NULL,
		MSDT 		CHAR(6) 								NOT NULL,
		CONSTRAINT FK_SV_DETAI_SINHVIEN FOREIGN KEY (MSSV) REFERENCES SINHVIEN(MSSV),
		CONSTRAINT FK_SV_DETAI_DETAI FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
		PRIMARY KEY (MSSV, MSDT)
	);

CREATE TABLE HOCHAM
	(
		MSHH 		INT 								NOT NULL 		PRIMARY KEY,
		TENHH 	NVARCHAR2(30) 		NOT NULL
	);

CREATE TABLE HOCVI
	(
		MSHV 		INT 								NOT NULL 		PRIMARY KEY,
		TENHV 	NVARCHAR2(20) 		NOT NULL
	);

CREATE TABLE CHUYENNGANH
	(
		MSCN 		INT 								NOT NULL 		PRIMARY KEY,
		TENCN 	NVARCHAR2(30) 		NOT NULL
	);

CREATE TABLE GIAOVIEN
	(
		MSGV 			INT 									NOT NULL 		PRIMARY KEY,
		TENGV 			NVARCHAR2(40) 			NOT NULL,
		DIACHI 		NVARCHAR2(100) 			NOT NULL,
		SODT   		CHAR(10)						NULL,
		MSHHAM 	INT 									NULL,
			CONSTRAINT FK_GIAOVIEN_HOCHAM FOREIGN KEY (MSHHAM) REFERENCES HOCHAM(MSHH),
		NAMHH 		INT 									NOT NULL
	);

CREATE TABLE GV_HV_CN
	(
		MSGV 			INT 			NOT NULL,
			CONSTRAINT FK_GV_HV_CN_GIAOVIEN FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
		MSHV 			INT 			NOT NULL,
			CONSTRAINT FK_GV_HV_CN_HOCVI FOREIGN KEY (MSHV) REFERENCES HOCVI(MSHV),
		MSCN 			INT 			NOT NULL,
			CONSTRAINT FK_GV_HV_CN_CHUYENNGANH FOREIGN KEY (MSCN) REFERENCES CHUYENNGANH(MSCN),
		PRIMARY KEY (MSGV, MSHV, MSCN),
		NAM 			INT 			NULL
	);

CREATE TABLE GV_HDDT
	(
		MSGV 			INT 				NOT NULL,
			CONSTRAINT FK_GV_HDDT_GIAOVIEN FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
		MSDT 			CHAR(6) 		NOT NULL,
			CONSTRAINT FK_GV_HDDT_DETAI FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
		PRIMARY KEY (MSGV, MSDT),
		DIEM 			FLOAT 		NULL
	);

CREATE TABLE GV_PBDT
	(
		MSGV 			INT 				NOT NULL,
			CONSTRAINT FK_GV_PBDT_GIAOVIEN FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
		MSDT 			CHAR(6) 		NOT NULL,
			CONSTRAINT FK_GV_PBDT_DETAI FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
		PRIMARY KEY (MSGV, MSDT),
		DIEM 			FLOAT 		NOT NULL
	);

CREATE TABLE GV_UVDT
	(
		MSGV 			INT 				NOT NULL,
			CONSTRAINT FK_GV_UVDT_GIAOVIEN FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
		MSDT 			CHAR(6) 		NOT NULL,
			CONSTRAINT FK_GV_UVDT_DETAI FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
		PRIMARY KEY (MSGV, MSDT),
		DIEM 			FLOAT 		NULL
	);

CREATE TABLE HOIDONG
	(
		MSHD   			INT 								NOT NULL 			PRIMARY KEY,
		PHONG  			CHAR(10)					NULL,
		TGBD   				CHAR(10)					NULL,
		NGAYHD 			DATE 							NULL,
		TINHTRANG 	NVARCHAR2(30) 		NULL,
		MSGVCTHD 	INT 								NOT NULL,
			CONSTRAINT FK_HOIDONG_GIAOVIEN FOREIGN KEY (MSGVCTHD) REFERENCES GIAOVIEN(MSGV)
	);

CREATE TABLE HOIDONG_GV
	(	
		MSHD 			INT 				NOT NULL,
			CONSTRAINT FK_HOIDONG_GV_HOIDONG FOREIGN KEY (MSHD) REFERENCES HOIDONG(MSHD),
		MSGV 			INT 				NOT NULL,
			CONSTRAINT FK_HOIDONG_GV_GIAOVIEN FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
		PRIMARY KEY (MSHD, MSGV)
	);

CREATE TABLE HOIDONG_DT
	(
		MSHD 				INT 							NOT NULL,
			CONSTRAINT FK_HOIDONG_DT_HOIDONG FOREIGN KEY (MSHD) REFERENCES HOIDONG(MSHD),
		MSDT 				CHAR(6) 					NOT NULL,
			CONSTRAINT FK_HOIDONG_DT_DETAI FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
		PRIMARY KEY (MSHD, MSDT),
		QUYETDINH 	NVARCHAR2(15)	NULL
	);