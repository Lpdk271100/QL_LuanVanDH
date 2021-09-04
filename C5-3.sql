/* 5.3 Các Stored Procedure với các tham số truyền vào (IN) */
/*
Câu 1: Tham số đưa vào là MSGV, TENGV, SODT, DIACHI, MSHH, NAMHHAM.
		Trước khi chèn dữ liệu cần kiểm tra MSHH đã tồn tại trong table HOCHAM chưa, nếu chưa trả ra thông báo lỗi. 
*/
CREATE OR REPLACE PROCEDURE P_553_CAU1
(
	p_MSGV		IN 	GIAOVIEN.MSGV%TYPE, 
	p_TENGV		IN 	GIAOVIEN.TENGV%TYPE, 
	p_DIACHI		IN 	GIAOVIEN.DIACHI%TYPE, 
	p_SODT		IN 	GIAOVIEN.SODT%TYPE, 
	p_MSHHAM	IN 	GIAOVIEN.MSHHAM%TYPE,
	p_NAMHH	IN 	GIAOVIEN.NAMHH%TYPE
)
AS
	FK_GIAOVIEN_HOCHAM	EXCEPTION;
	PRAGMA EXCEPTION_INIT(FK_GIAOVIEN_HOCHAM, -02291);
BEGIN
	INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
		VALUES (p_MSGV, p_TENGV, p_DIACHI, p_SODT, p_MSHHAM, p_NAMHH);
	
	EXCEPTION
		WHEN FK_GIAOVIEN_HOCHAM THEN
			DBMS_OUTPUT.PUT_LINE('Ma so hoc ham ' || p_MSHHAM || ' khong ton tai!!');
END P_553_CAU1;
/
EXECUTE P_553_CAU1(6, 'Khoa Pro', '1/60 TVĐ', '08632184', 10, 2019);
/
/*
Câu 2: Tham số đưa vào là:
		MSGV, TENGV, SODT, DIACHI, MSHH, NAMHHAM. 
		Trước khi chèn dữ liệu cần kiểm tra MSGV có trùng không, nếu trùng thông báo lỗi. 
*/
CREATE OR REPLACE PROCEDURE P_553_CAU2
(
	p_MSGV		IN 	GIAOVIEN.MSGV%TYPE, 
	p_TENGV		IN 	GIAOVIEN.TENGV%TYPE, 
	p_DIACHI		IN 	GIAOVIEN.DIACHI%TYPE, 
	p_SODT		IN 	GIAOVIEN.SODT%TYPE, 
	p_MSHHAM	IN 	GIAOVIEN.MSHHAM%TYPE,
	p_NAMHH	IN 	GIAOVIEN.NAMHH%TYPE
)
AS
	PK_GIAOVIEN	EXCEPTION;
	PRAGMA EXCEPTION_INIT(PK_GIAOVIEN, -00001);
BEGIN
	INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
		VALUES (p_MSGV, p_TENGV, p_DIACHI, p_SODT, p_MSHHAM, p_NAMHH);
	
	EXCEPTION
		WHEN PK_GIAOVIEN THEN
			DBMS_OUTPUT.PUT_LINE('Ma so giao vien ' || p_MSGV || ' da ton tai!!');
END P_553_CAU2;
/
EXECUTE P_553_CAU2(5, 'Khoa Pro', '1/60 TVĐ', '08632184', 10, 2019);
/
/*
Câu 3: Giống câu 1 và câu 2 kiểm tra xem MSGV có trùng không. MSHH tồn tại chưa. Nếu
		MSGV trùng thông báo lỗi.Nếu MSHH chưa tồn tại thông báo lỗi, ngược lại cho chèn dữ liệu.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU3
(
	p_MSGV		IN 	GIAOVIEN.MSGV%TYPE, 
	p_TENGV		IN 	GIAOVIEN.TENGV%TYPE, 
	p_DIACHI		IN 	GIAOVIEN.DIACHI%TYPE, 
	p_SODT		IN 	GIAOVIEN.SODT%TYPE, 
	p_MSHHAM	IN 	GIAOVIEN.MSHHAM%TYPE,
	p_NAMHH	IN 	GIAOVIEN.NAMHH%TYPE
)
AS
	PK_GIAOVIEN	EXCEPTION;
	PRAGMA EXCEPTION_INIT(PK_GIAOVIEN, -00001);
	FK_GIAOVIEN_HOCHAM	EXCEPTION;
	PRAGMA EXCEPTION_INIT(FK_GIAOVIEN_HOCHAM, -02291);
BEGIN
	INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
		VALUES (p_MSGV, p_TENGV, p_DIACHI, p_SODT, p_MSHHAM, p_NAMHH);
	
	EXCEPTION
		WHEN PK_GIAOVIEN THEN
			DBMS_OUTPUT.PUT_LINE('Ma so giao vien ' || p_MSGV || ' da ton tai!!');
		WHEN FK_GIAOVIEN_HOCHAM THEN
			DBMS_OUTPUT.PUT_LINE('Ma so hoc ham ' || p_MSHHAM || ' khong ton tai!!');
END P_553_CAU3;
/
EXECUTE P_553_CAU3(6, 'Khoa Pro', '1/60 TVĐ', '08632184', 1, 2019);
/
/*
Câu 4: Đưa vào MSDT cũ, TENDETAI mới. Hãy cập nhật TENDETAI mới với MSDT cũ không đổi, 
	nếu không tìm thấy thông báo lỗi ngược lại cập nhật và thông báo thành công.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU4
(
	p_MSDT		IN 	DETAI.MSDT%TYPE, 
	p_TENDT		IN 	DETAI.TENDT%TYPE
)
AS
BEGIN
	UPDATE DETAI
	SET TENDT = p_TENDT
	WHERE MSDT = p_MSDT;

	IF SQL%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Mã số đề tài không tồn tại!!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Procedure successfully completed');
	END IF;
END P_553_CAU4;
/
EXECUTE P_553_CAU4('97001', 'Quản lí thư viện');
/
/*
Câu 5: Tham số đưa vào MSSV cũ, TENSV mới, DIACHI mới. Thủ tục dùng để cập nhật SINHVIEN trên. 
		Nếu không tìm thấy thông báo lỗi, ngược lại cập nhật.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU5
(
	p_MSSV		IN 	SINHVIEN.MSSV%TYPE, 
	p_TENSV		IN 	SINHVIEN.TENSV%TYPE,
	p_DIACHI		IN 	SINHVIEN.DIACHI%TYPE
)
AS
BEGIN
	UPDATE SINHVIEN
	SET TENSV = p_TENSV, DIACHI = p_DIACHI
	WHERE MSSV = p_MSSV;

	IF SQL%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Sinh viên không tồn tại!!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Procedure successfully completed');
	END IF;
END P_553_CAU5;
/
EXECUTE P_553_CAU5('97TH01', 'NGUYỄN VĂN AN', '13 NTMK');
/
/*
Câu 6: Đưa vào MSDT hãy chuyển đổi sao cho đề tài của GVHD sẽ chuyển thành GVPB và
		GVPB sẽ thành GVHD. Nếu không tìm thấy thông báo lỗi.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU6
(
	p_MSDT		IN 	GV_HDDT.MSDT%TYPE
)
AS
BEGIN
	UPDATE GV_PBDT gvpb
	SET MSDT = p_MSDT
	WHERE gvpb.MSGV = (	SELECT 	gvhd.MSGV
						FROM	GV_HDDT gvhd);

	IF SQL%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Giảng viên không tồn tại!!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Procedure successfully completed');
	END IF;
	
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			DBMS_OUTPUT.PUT_LINE('Multiple rows meet criteria !!');
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Not a valid mssv, msgv !!');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Undefined error occured');
END P_553_CAU6;
/
EXECUTE P_553_CAU6('97001');
/		
/*
Câu 7: Đưa vào TENGV, TENSV. Hãy chuyển đề tài của sinh viên đó cho giáo viên mới hướng dẫn với TENGV là tham số vào. 
	Nếu không tìm thấy tên sinh viên và tên giáo viên, hoặc tìm thấy tên sinh viên và tên giáo viên nhưng không duy nhất thì thông báo lỗi.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU7
(
	p_TENGV		IN 	GIAOVIEN.TENGV%TYPE,
	p_TENSV		IN 	SINHVIEN.TENSV%TYPE
)
AS
	msdt	DETAI.MSDT%TYPE;
	msgv	GIAOVIEN.MSGV%TYPE;
BEGIN
	-- Lấy mã số đề tài từ tên sinh viên nhập vào
	SELECT svdt.MSDT INTO msdt
	FROM SINHVIEN sv INNER JOIN SV_DETAI svdt ON sv.MSSV = svdt.MSSV
	WHERE sv.TENSV = p_TENSV;
	
	-- Lấy mã giáo viên hướng dẫn mới từ tên nhập vào
	SELECT MSGV INTO msgv
	FROM GIAOVIEN
	WHERE TENGV = p_TENGV;

	UPDATE GV_HDDT
	SET MSDT = msdt
	WHERE MSGV = msgv;

	IF SQL%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Tên giảng viên hoặc sinh viên không tồn tại!!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Procedure successfully completed');
	END IF;
	
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			DBMS_OUTPUT.PUT_LINE('Multiple rows meet criteria !!');
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Not a valid mssv, msgv !!');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Undefined error occured');
END P_553_CAU7;
/
EXECUTE P_553_CAU7();
/		
/*		
Câu 8: Đưa vào TENGV nếu không vi phạm toàn vẹn về khóa ngoại thì xóa. Ngược lại thông báo lỗi.
*/
CREATE OR REPLACE PROCEDURE P_553_CAU8
(
	p_TENGV		IN 	GIAOVIEN.TENGV%TYPE
)
AS
	FK_GIAOVIEN	EXCEPTION;
	PRAGMA EXCEPTION_INIT(FK_GIAOVIEN, -02291);
BEGIN
	DELETE GIAOVIEN
	WHERE TENGV LIKE '%p_TENGV%';
	
	EXCEPTION
		WHEN FK_GIAOVIEN THEN
			DBMS_OUTPUT.PUT_LINE('Không thể xóa giảng viên này!!');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Undefined error occured');
END P_553_CAU8;
/
CREATE OR REPLACE PROCEDURE CAU_53_8
(
    p_TENGV IN GIAOVIEN.TENGV%TYPE
)
AS
     P_MSGV  GIAOVIEN.MSGV%TYPE;
     FK_GIAOVIEN EXCEPTION ;
     PRAGMA EXCEPTION_INIT(FK_GIAOVIEN,-02291);
BEGIN
      Select MSGV into P_MSGV from GIAOVIEN where TENGV = p_TENGV;
      
      DELETE FROM GIAOVIEN WHERE MSGV=P_MSGV;
      dbms_output.put_line('da xoa thanh cong: ' || p_TENGV || '');
      EXCEPTION       
        WHEN  FK_GIAOVIEN THEN
            dbms_output.put_line('Khong the xoa:' || p_TENGV || ' vi pham khoa ngoai');
        WHEN NO_DATA_FOUND THEN
            Dbms_output.Put_line ('Không tìm thấy data ' ||p_TENGV ) ;
END CAU_53_8;