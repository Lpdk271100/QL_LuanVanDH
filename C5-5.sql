/* 5.5 Tạo Cursor */
/*
Câu 1: Tạo thử bảng TamA lưu thông tin về mã số đề tài:
		Viết Cursor lấy thông tin từ bảng Đề Tài là Mã số đề tài(MSDT) để lưu vào bảng TamA.
		Trong đó ta dùng cấu trúc lồng hàm trong Cursor hàm for…in … loop…end loop;
*/
CREATE TABLE TamA
(
	MSDT	CHAR(6)			NOT NULL,
	TENDT	NVARCHAR2(100)	NOT NULL
);
/
DECLARE
	CURSOR cs_555_CAU1  IS SELECT * FROM DETAI;
BEGIN
	FOR I IN cs_555_CAU1
	LOOP
		INSERT INTO TamA VALUES(I.MSDT, I.TENDT);
	END LOOP;
END;
/
SELECT * FROM TamA;
/*		
Câu 2: Tạo thử bảng TamA lưu thông tin về mã số đề tài:
		-Viết Cursor lấy thông tin từ bảng Đề Tài là Mã số đề tài(MSDT) để lưu vào bảng TamA.
		Trong đó ta dùng cấu trúc lồng hàm trong Cursor hàm Fetch cursor into ...
*/
DELETE TamA;
/
DECLARE
	CURSOR cs_555_CAU2  IS SELECT * FROM DETAI;
	p_MSDT	DETAI.MSDT%TYPE;
	p_TENDT	DETAI.TENDT%TYPE;
BEGIN
	OPEN cs_555_CAU2;
	
	LOOP
		FETCH cs_555_CAU2 INTO p_MSDT, p_TENDT;
		EXIT WHEN cs_555_CAU2%NOTFOUND;
		INSERT INTO TamA VALUES (p_MSDT, p_TENDT);
	END LOOP;
	
	CLOSE cs_555_CAU2;
END;
/
SELECT * FROM TamA;
/*
Câu 3: Thêm 2 cột DIEMTB và XLOAI vào Table SV_DETAI:
		Dùng cursor cập nhật điểm đề tài và xếp loại theo quy tắc:
		(DIEMHD+DIEMPB+3*DIEMUV)/5
		9<=DIEMTB<=10    XLOAI: Giỏi
		7<=DIEMTB<9   		XLOAI: Khá 
		5<=DIEMTB<7    		XLOAI: Trung bình 
		DIEMTB<5    			XLOAI: Không đạt 
*/
ALTER TABLE SV_DETAI ADD 
(
	DIEMTB	FLOAT,
	XL		NVARCHAR2(20)
);
/
DECLARE
	CURSOR cs_555_CAU3 
	IS
		SELECT 	MSSV, MSDT
		FROM 	SV_DETAI;
	p_MSSV		SV_DETAI.MSSV%TYPE;
	p_MSDT		SV_DETAI.MSDT%TYPE;
BEGIN
	OPEN cs_555_CAU3;
	
	LOOP
		FETCH cs_555_CAU3 INTO p_MSSV, p_MSDT;
		EXIT WHEN cs_555_CAU3%NOTFOUND;
		UPDATE 	SV_DETAI
		SET 		DIEMTB 	= F_552_CAU1(p_MSDT),
				XL		= F_552_CAU2(p_MSDT)
		WHERE 	MSSV = p_MSSV AND MSDT = p_MSDT;
	END LOOP;
	
	CLOSE cs_555_CAU3;
END;
/
SELECT * FROM SV_DETAI;
/*
Câu 4: Giả sử trên bảng DETAI thêm cột số lượng
		DETAI(MSDT, TENDT, SOLUONG)
		Dùng cơ chế Cursor đếm số lượng sinh viên cùng thực hiện và cập nhật vào cột Số lượng (SOLUONG)
*/
ALTER TABLE DETAI ADD SOLUONG INT;
SELECT * FROM DETAI;
/
DECLARE
	CURSOR cs_555_CAU4
	IS
		SELECT MSDT, COUNT(MSSV)
		FROM SV_DETAI
		GROUP BY MSDT;
		
	p_MSDT 		DETAI.MSDT%TYPE;
	p_SOLUONG 	INT;
BEGIN
	OPEN cs_555_CAU4;
	LOOP
		FETCH cs_555_CAU4 INTO p_MSDT, p_SOLUONG;
		EXIT WHEN cs_555_CAU4%NOTFOUND;
		
		UPDATE DETAI
		SET SOLUONG = p_SOLUONG
		WHERE MSDT  = p_MSDT;
	END LOOP;
	CLOSE cs_555_CAU4;
END;
/*
Câu 5: Do sinh bảo vệ có thể rớt, nên Sinh Viên có thể bảo vệ 2,3 lần.
		Nếu thêm cột SOLAN vào bảng 
		SINHVIEN(MSSV, TENSV, LOP, SODT, DIACHI, SOLAN). 
		Dùng cursor để cập nhật lại cột SOLAN.
*/
ALTER TABLE SINHVIEN ADD SOLAN INT;
SELECT *
FROM SINHVIEN;
/
DECLARE
	CURSOR cs_555_CAU5
	IS
		SELECT sv.MSSV, COUNT(svdt.MSSV)
		FROM SINHVIEN sv, SV_DETAI svdt, HOIDONG hd, HOIDONG_DT hddt
		WHERE sv.MSSV  = svdt.MSSV
			AND svdt.MSDT = hddt.MSDT
			AND hd.MSHD   = hddt.MSHD
		GROUP BY sv.MSSV;
		
	p_MSSV 		SINHVIEN.MSSV%TYPE;
	p_SOLAN 	INT;
BEGIN
	OPEN cs_555_CAU5;
	LOOP
		FETCH cs_555_CAU5 INTO p_MSSV, p_SOLAN;
		EXIT WHEN cs_555_CAU5%NOTFOUND;

		UPDATE SINHVIEN
		SET SOLAN  = p_SOLAN
		WHERE MSSV = p_MSSV;
	END LOOP;
	CLOSE cs_555_CAU5;
END;