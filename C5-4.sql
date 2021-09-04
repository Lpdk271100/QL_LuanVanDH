/* 5.4 Các Stored Procedure với các tham số truyền vào và ra (IN OUT) */
/*
Câu 1: Đưa vào TENHV
		Trả ra: Số GV thỏa học vị, nếu không tìm thấy thông báo lỗi.
*/
CREATE OR REPLACE PROCEDURE P_554_CAU1
(
	p_TENHV		IN		HOCVI.TENHV%TYPE,
	p_SOGV		OUT		INT
)
AS
BEGIN
	SELECT 	COUNT(DISTINCT MSGV) INTO p_SOGV
	FROM	GV_HV_CN
	WHERE	MSHV = (SELECT MSHV FROM HOCVI WHERE TENHV = p_TENHV);
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Không tìm thấy giảng viên nào!!');
END P_554_CAU1;
/
DECLARE
	p_TENHV		HOCVI.TENHV%TYPE := 'HN';
	SOGV		INT;
BEGIN
	P_554_CAU1(p_TENHV, SOGV);
	DBMS_OUTPUT.PUT_LINE('Co ' || SOGV || ' giao vien co bang ' || p_TENHV);
END;
/
/*
Câu 2: Đưa vào TENDT
		Cho biết: Điểm trung bình của đề tài, nếu không tìm thấy thông báo lỗi
*/
CREATE OR REPLACE PROCEDURE P_554_CAU2
(
	p_TENDT		IN		DETAI.TENDT%TYPE,
	p_DIEMTB	OUT		FLOAT
)
AS
	msdt	DETAI.MSDT%TYPE;
BEGIN
	-- Lấy msdt từ tên đề tài nhập vào
	SELECT MSDT INTO msdt
	FROM DETAI
	WHERE TENDT LIKE p_TENDT;
	
	p_DIEMTB := F_552_CAU1(msdt);
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Không tìm thấy đề tài!!');
END P_554_CAU2;
/
DECLARE
	p_TENDT		DETAI.TENDT%TYPE := 'Quản lý thư viện';
	p_DIEMTB	FLOAT;
BEGIN
	P_554_CAU2(p_TENDT, p_DIEMTB);
	DBMS_OUTPUT.PUT_LINE('Đề tài ' || p_TENDT || ' có điểm trung bình là: ' || p_DIEMTB);
END;
/
/*
Câu 3: Đưa vào TENGV
		Trả ra: Số điện thoại của giáo viên, nếu không tìm thấy thông báo lỗi
*/
CREATE OR REPLACE PROCEDURE P_554_CAU3
(
	p_TENGV		IN		GIAOVIEN.TENGV%TYPE,
	p_SDT		OUT		GIAOVIEN.SODT%TYPE
)
AS
BEGIN
	SELECT SODT INTO p_SDT
	FROM GIAOVIEN
	WHERE TENGV LIKE '%p_TENGV%';
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Ten GV: '|| p_TENGV ||' khong ton tai');
END P_554_CAU3;
/
DECLARE
	p_TENCTHD		GIAOVIEN.TENGV%TYPE;
	p_SDT			GIAOVIEN.SODT%TYPE;
BEGIN
	P_554_CAU3('A', p_SDT);
	DBMS_OUTPUT.PUT_LINE(p_TENCTHD || ' co sdt la: ' || p_SDT);
END;
/
/*
Câu 4: Đưa vào MSHD
		Trả ra: Tên chủ tịch hội đồng và Số điện thoại, nếu không tìm thấy thông báo lỗi 
*/
CREATE OR REPLACE PROCEDURE P_554_CAU4
(
	p_MSHD		IN 		HOIDONG.MSHD%TYPE,
	p_TENCTHD	OUT		GIAOVIEN.TENGV%TYPE,
	p_SDT		OUT		GIAOVIEN.SODT%TYPE
)
AS
BEGIN
	SELECT gv.TENGV, gv.SODT INTO p_TENCTHD, p_SDT
	FROM HOIDONG hd INNER JOIN GIAOVIEN gv ON hd.MSGVCTHD = gv.MSGV
	WHERE hd.MSHD = p_MSHD;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Ma HD '|| p_MSHD ||' khong ton tai');
END P_554_CAU4;
/
DECLARE
	p_MSHD		 	HOIDONG.MSHD%TYPE;
	p_TENCTHD		GIAOVIEN.TENGV%TYPE;
	p_SDT			GIAOVIEN.SODT%TYPE;
BEGIN
	P_554_CAU4(1, p_TENCTHD, p_SDT);
	DBMS_OUTPUT.PUT_LINE(p_TENCTHD || ' co sdt la: ' || p_SDT);
END;