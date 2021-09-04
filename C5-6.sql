/* 5.6 Tạo Trigger */
/*
Câu 1:Tạo Trigger thỏa mãn điều kiện khi xóa một đề tài sẽ xóa các thông tin liên quan:
		Các bảng liên quan đến bảng DETAI như sau:
			1.Bảng SV_DETAI
			2.Bảng GV_HDDT
			3.Bảng GV_PBDT
			4.Bảng GV_UVDT
			5.Bảng 
*/
CREATE OR REPLACE TRIGGER TG_556_CAU1
BEFORE DELETE
ON DETAI
FOR EACH ROW
BEGIN
	IF :OLD.MSDT IS NOT NULL THEN
		DELETE SV_DETAI WHERE MSDT = :OLD.MSDT;
		DELETE GV_HDDT WHERE MSDT = :OLD.MSDT;
		DELETE GV_PBDT WHERE MSDT = :OLD.MSDT;
		DELETE GV_UVDT WHERE MSDT = :OLD.MSDT;
		DELETE HOIDONG_DT WHERE MSDT = :OLD.MSDT;
	
		DBMS_OUTPUT.PUT_LINE('Đề tài: '|| :OLD.MSDT ||' đã được xóa trong các bảng liên kết');
	END IF;
END TG_556_CAU1;
/
DECLARE
	p_MSDT	DETAI.MSDT%TYPE := &Nhap_MSDT;
BEGIN
	DELETE DETAI
	WHERE MSDT = p_MSDT;
END;
/*
Câu 2: Tạo Trigger thỏa mãn điều kiện khi xóa sinh viên sẽ xóa các thông tin liên quan.
	Các bảng có liên quan đến bảng SINHVIEN là bảng SV_DETAI.
*/
ALTER TABLE SV_DETAI DISABLE CONSTRAINT FK_SV_DETAI_SINHVIEN;
ALTER TABLE SV_DETAI DISABLE CONSTRAINT FK_SV_DETAI_DETAI;
/
CREATE OR REPLACE TRIGGER TG_556_CAU2
BEFORE DELETE
ON SINHVIEN
FOR EACH ROW
BEGIN
	IF :OLD.MSSV IS NOT NULL THEN
		DELETE SV_DETAI WHERE MSSV = :OLD.MSSV;
	
		DBMS_OUTPUT.PUT_LINE('Sinh viên: '|| :OLD.MSSV||' đã được xóa trong các bảng liên kết');
	END IF;
END TG_556_CAU2;
/
DECLARE
	p_MSSV	SINHVIEN.MSSV%TYPE := &Nhap_MSSV;
BEGIN
	DELETE SINHVIEN
	WHERE MSSV = p_MSSV;
END;
/
/*
Câu 3: Tạo Trigger thỏa mãn điều kiện khi xóa một HOI DONG sẽ xóa các thông tin liên quan:
		Các bảng liên quan đến bảng hội đồng HOIDONG
			1.Bảng HOIDONG_DT
			2.Bảng HOIDONG_GV
*/
CREATE OR REPLACE TRIGGER TG_556_CAU3
BEFORE DELETE
ON HOIDONG
FOR EACH ROW
BEGIN
	IF :OLD.MSHD IS NOT NULL THEN
		DELETE HOIDONG_DT WHERE MSHD = :OLD.MSHD;
		DELETE HOIDONG_GV WHERE MSHD = :OLD.MSHD;
		
		DBMS_OUTPUT.PUT_LINE('Hội đồng: '|| :OLD.MSHD||' đã được xóa trong các bảng liên kết');
	END IF;
END TG_556_CAU3;
/
DECLARE
	p_MSHD	HOIDONG.MSHD%TYPE := &Nhap_MSHD;
BEGIN
	DELETE HOIDONG
	WHERE MSHD = p_MSHD;
END;
/
/*
Câu 4: Tạo Trigger thỏa mãn ràng buộc là khi đổi một mã số đề tài (MSDT) trong bảng đề tài sẽ thay đổi các thông tin liên quan:
		Các bảng liên quan đến bảng DETAI như sau:
			1.Bảng SV_DETAI
			2.Bảng GV_HDDT
			3.Bảng GV_PBDT
			4.Bảng GV_UVDT
			5.Bảng HOIDONG_DT
*/
CREATE OR REPLACE TRIGGER TG_556_CAU4
AFTER UPDATE
ON DETAI
FOR EACH ROW 
BEGIN 
	IF :OLD.MSDT IS NOT NULL THEN
		-- Cập nhật bảng SV_DETAI
		UPDATE SV_DETAI
		SET MSDT   = :NEW.MSDT
		WHERE MSDT = :OLD.MSDT;
		-- Cập nhật bảng GV_HDDT
		UPDATE GV_HDDT
		SET MSDT   = :NEW.MSDT
		WHERE MSDT = :OLD.MSDT;
		-- Cập nhật bảng GV_PBDT
		UPDATE GV_PBDT
		SET MSDT   = :NEW.MSDT
		WHERE MSDT = :OLD.MSDT;
		-- Cập nhật bảng GV_UVDT
		UPDATE GV_UVDT
		SET MSDT   = :NEW.MSDT
		WHERE MSDT = :OLD.MSDT;
		-- Cập nhật bảng HOIDONG_DT
		UPDATE HOIDONG_DT
		SET MSDT   = :NEW.MSDT
		WHERE MSDT = :OLD.MSDT;
		
		DBMS_OUTPUT.PUT_LINE('Đã sửa thành công mã số đề tài '|| :OLD.MSDT || 'thành ' || :NEW.MSDT) ;
	END IF;
END TG_556_CAU4;
/
UPDATE DETAI
SET MSDT   = '97003'
WHERE MSDT = '97004';
/*
Câu 5: Tạo Trigger thỏa mãn ràng buộc là khi đổi một mã số giáo viên (MSGV). Sẽ thay đổi các thông tin liên quan.
	GV_HV_CN, GV_HDDT, GV_PBDT, GV_UVDT, HOIDONG, HOIDONG_GV
*/
CREATE OR REPLACE TRIGGER TG_556_CAU5
AFTER UPDATE
ON GIAOVIEN
FOR EACH ROW 
BEGIN 
	IF :OLD.MSGV IS NOT NULL THEN
		-- Cập nhật bảng GV_HV_CN
		UPDATE GV_HV_CN
		SET MSGV   = :NEW.MSGV
		WHERE MSGV = :OLD.MSGV;
		-- Cập nhật bảng GV_HDDT
		UPDATE GV_HDDT
		SET MSGV   = :NEW.MSGV
		WHERE MSGV = :OLD.MSGV;
		-- Cập nhật bảng GV_PBDT
		UPDATE GV_PBDT
		SET MSGV   = :NEW.MSGV
		WHERE MSGV = :OLD.MSGV;
		-- Cập nhật bảng GV_UVDT
		UPDATE GV_UVDT
		SET MSGV   = :NEW.MSGV
		WHERE MSGV = :OLD.MSGV;
		-- Cập nhật bảng HOIDONG
		UPDATE HOIDONG
		SET MSGVCTHD   = :NEW.MSGV
		WHERE MSGVCTHD = :OLD.MSGV;
		-- Cập nhật bảng HOIDONG_GV
		UPDATE HOIDONG_GV
		SET MSGV   = :NEW.MSGV
		WHERE MSGV = :OLD.MSGV;
		
		DBMS_OUTPUT.PUT_LINE('Đã sửa thành công giảng viên '|| :OLD.MSGV || 'thành ' || :NEW.MSGV) ;
	END IF;
END TG_556_CAU5;
/
/*
Câu 6: Tạo Trigger thỏa mãn ràng buộc là khi đổi một mã số hội đồng (MSHD) HOIDONG. Sẽ thay đổi các thông tin liên quan.
	HOIDONG_GV, HOIDONG_DT
*/
CREATE OR REPLACE TRIGGER TG_556_CAU6
AFTER UPDATE
ON HOIDONG
FOR EACH ROW 
BEGIN 
	IF :OLD.MSHD IS NOT NULL THEN
		-- Cập nhật bảng HOIDONG_GV
		UPDATE HOIDONG_GV
		SET MSHD   = :NEW.MSHD
		WHERE MSHD = :OLD.MSHD;
		-- Cập nhật bảng HOIDONG_DT
		UPDATE HOIDONG_DT
		SET MSHD   = :NEW.MSHD
		WHERE MSHD = :OLD.MSHD;

		DBMS_OUTPUT.PUT_LINE('Đã sửa thành công mã số hội đồng '|| :OLD.MSHD || 'thành ' || :NEW.MSHD) ;
	END IF;
END TG_556_CAU6;
/
/*
Câu 7: Tạo Trigger thỏa mãn các ràng buộc là một HOIDONG không quá 3 DETAI.
*/
CREATE OR REPLACE TRIGGER TG_556_CAU7
BEFORE INSERT
ON HOIDONG_DT
FOR EACH ROW
DECLARE
	mshd	HOIDONG.MSHD%TYPE;
	sl_DETAI	INT;
BEGIN
	-- Đếm số lượng đề tài của hội đồng
	SELECT MSHD, COUNT(MSDT) INTO mshd, sl_DETAI 
	FROM HOIDONG_DT
	GROUP BY MSHD;
	-- Kiểm tra số lượng đề tài
	IF sl_DETAI > 3 THEN
		RAISE_APPLICATION_ERROR(-20991, 'Thôi bạn ơi, số lượng đề tài lớn hơn 3 rồi!! Chấm ít thôi.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Thêm thành công');
	END IF;
END TG_556_CAU7;
/
-- Gọi TRIGGER khi thêm HOIDONG_DT
INSERT INTO HOIDONG_DT(MSHD,MSDT,QUYETDINH) VALUES (1,'97003','Được');