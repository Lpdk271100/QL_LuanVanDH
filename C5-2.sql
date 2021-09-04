/*	5.2 Tạo Function*/
/*
Câu 1: Đưa vào MSDT (IN)
	Trả ra (Return): Điểm trung bình của đề tài đó
*/
CREATE OR REPLACE FUNCTION F_552_CAU1
(
	p_MSDT	IN	DETAI.MSDT%TYPE
)
	RETURN FLOAT
AS
	DTB FLOAT;
	DHD	FLOAT;
	DPB FLOAT;
	DUV FLOAT;
BEGIN
	SELECT	AVG(DIEM) INTO DHD
	FROM 		GV_HDDT
	WHERE	MSDT = p_MSDT;
	
	SELECT	AVG(DIEM) INTO DPB
	FROM 		GV_PBDT
	WHERE	MSDT = p_MSDT;
	
	SELECT	AVG(DIEM) INTO DUV
	FROM 		GV_UVDT
	WHERE	MSDT = p_MSDT;
		
	DTB := ROUND((DHD + DPB + DUV)/3, 2);
	RETURN DTB;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('DIEM TRUNG BINH LA: ' || F_552_CAU1('97003'));	
END;
/*
Câu 2: Đưa vào MSDT (IN) tính điểm trung bình và trả ra (Return) xếp loại cho sinh viên đã bảo vệ đề tài tốt nghiệp theo tiêu chuẩn sau: 
					Xếp Loại  
					Giỏi : Nếu DTB>=8 và DTB<=10 
					Khá : Nếu DTB>=7 
					TB : Nếu DTB>=5 
					Kém : còn lại 
	Trong đó: DTB là điểm trung bình được tính dựa vào các bảng GV_HDDT, GV_PBDT và GV_UVDT (DTB= (DIEMHD+DIEMPB+SUM(DIEMUV))/5) 
*/
CREATE OR REPLACE FUNCTION F_552_CAU2
(
	p_MSDT	IN	DETAI.MSDT%TYPE
)
	RETURN NVARCHAR2
AS
	DTB 	FLOAT;
	XL 	NVARCHAR2(20);
BEGIN
	DTB := F_552_CAU1(p_MSDT);
	
	IF DTB>=8 AND DTB<=10 THEN
		XL := 'GIOI';
	ELSIF DTB>=7 THEN
		XL := 'KHA';
	ELSIF DTB>=5 THEN
		XL := 'TB';
	ELSE
		XL := 'KEM';
	END IF;
	
	RETURN XL;
END F_552_CAU2;
/
DECLARE
	p_MSDT	DETAI.MSDT%TYPE := &Nhap_MSDT;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Xep loai: ' || F_552_CAU2(p_MSDT));
END;
/
/*
Câu 3: Đưa vào MSDT(IN), hãy đếm số lượng sinh viên cùng thực hiện một đề tài đó.
	Trả ra (Return): Số lượng sinh viên cùng thực hiện một đề tài. 
*/
CREATE OR REPLACE FUNCTION F_552_CAU3
(
	p_MSDT	IN	DETAI.MSDT%TYPE
)
	RETURN INT
AS
	SL_SV	INT;
BEGIN
	SELECT COUNT(MSSV) INTO SL_SV
	FROM SV_DETAI
	WHERE MSDT = p_MSDT;
	
	RETURN SL_SV;
END F_552_CAU3;
/
DECLARE
	p_MSDT	DETAI.MSDT%TYPE := '97005';
BEGIN
	DBMS_OUTPUT.PUT_LINE('So luong sinh vien thuc hien de tai la: ' || F_552_CAU3(p_MSDT));
END;
/
/*
Câu 4: Do sinh viên bảo vệ có thể rớt, nên sinh viên có thể bảo vệ 2, 3 lần. 
	Dùng function để đếm số lần bảo vệ rồi trả ra (Return) số lần bảo vệ đó.
*/
CREATE OR REPLACE FUNCTION F_552_CAU4
(
	p_MSSV	IN	SINHVIEN.MSSV%TYPE
)
	RETURN INT
AS
	SL_BaoVe	INT;
BEGIN
	SELECT DISTINCT COUNT(sv.MSSV) INTO SL_BaoVe
	FROM SINHVIEN sv INNER JOIN SV_DETAI sdt ON sv.MSSV = sdt.MSSV
					INNER JOIN HOIDONG_DT hdt ON sdt.MSDT = hdt.MSDT 
					INNER JOIN HOIDONG hd ON hdt.MSHD = hd.MSHD
	WHERE sv.MSSV = p_MSSV;
	
	RETURN SL_BaoVe;
END F_552_CAU4;
/
DECLARE
	p_MSSV	SINHVIEN.MSSV%TYPE := '97TH01';
BEGIN
	DBMS_OUTPUT.PUT_LINE('So lan sinh vien bao ve de tai la: ' || F_552_CAU4(p_MSSV));
END;
/