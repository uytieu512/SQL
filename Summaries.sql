--TASK 1: Tạo Bảng
CREATE TABLE Study.LDS_EMPLOYEE (
    EMPLOYEE_ID varchar (50) PRIMARY KEY,
    EMPLOYEE_NAME nvarchar(100),
    AGE tinyint,
    DOB date,
    EMAIL nvarchar(75) CHECK (EMAIL LIKE '%@gmail.com.vn'),
    ADDRESS nvarchar(50),
    CERTIFICATE nvarchar(50),
    INCOME_ACCOUNT_NUMBER varchar(50) CHECK (INCOME_ACCOUNT_NUMBER LIKE '19%'),
    DEPARTMENT_ID nvarchar(50),
    ROLE_ID nvarchar(25),
    BAND_ID nvarchar(25)
);

CREATE TABLE Study.LDS_DEPARTMENT (
    DEPARTMENT_ID varchar(25) NOT NULL ,
    DEPARTMENT_NAME nvarchar (100),
    ESTABLISH_DT date,
    DEPARTMENT_LEVEL nvarchar(25),
);

CREATE TABLE Study.LDS_ROLE(
    ROLE_ID nvarchar(25),
    ROLE_NAME nvarchar (100),
    ROLE_DESCRIPTION nvarchar (255),
    PROFESSIONAL nvarchar (255)
);

CREATE TABLE Study.LDS_BAND (
    BAND_ID nvarchar (50),
    MIN_SALARY int CHECK (MIN_SALARY > 5000000),
    MAX_SALARY int CHECK (MAX_SALARY < 1000000000),
    EXPERIENCE_YEAR tinyint,
    BENEFIT int NOT NULL ,
    INSURRANCE_LEVEL nvarchar (50)
);


--TASK 2: Viết code thực hiện tạo Primary key và Foreign key theo mô tả sau
--1. Table CHINHANH:
--Tạo primary key (PK_CN_MCH) trên column MA_CUA_HANG
SELECT * INTO Study.LDSChiNhanh FROM Retail.ChiNhanh;

DELETE FROM Study.LDSChiNhanh WHERE MA_CUA_HANG is null;

ALTER TABLE Study.LDSChiNhanh
ALTER COLUMN MA_CUA_HANG NVARCHAR (255) not null;

ALTER TABLE Study.LDSChiNhanh
ADD CONSTRAINT PK_CN_MCH_LDS PRIMARY KEY (MA_CUA_HANG);

--2. Table HANGHOA:
--Tạo primary key (PK_HH_MH) trên column MAT_HANG
SELECT * INTO Study.LDSHangHoa FROM Retail.HangHoa;

ALTER TABLE Study.LDSHangHoa
ALTER COLUMN MAT_HANG NVARCHAR(255) not null;

ALTER TABLE Study.LDSHangHoa
ADD CONSTRAINT PK_HH_MH_LDS PRIMARY KEY (MAT_HANG);

--3. Table KHACHHANG:
--Tạo primary key (PK_KH_MKH) trên column MA_KH
SELECT * INTO Study.LDSKhachHang FROM Retail.KhachHang;

ALTER TABLE Study.LDSKhachHang
ALTER COLUMN MA_KH NVARCHAR(255) not null;

ALTER TABLE Study.LDSKhachHang
ADD CONSTRAINT PK_KH_MKH_LDS PRIMARY KEY (MA_KH);

--4. Table NHANVIEN:
--Tạo primary key (PK_NV_MNV) trên column MA_NHAN_VIEN
SELECT * INTO Study.LDSNhanVien FROM Retail.NhanVien;

ALTER TABLE Study.LDSNhanVien
ALTER COLUMN MA_NHAN_VIEN NVARCHAR(255) not null;

ALTER TABLE Study.LDSNhanVien
ADD CONSTRAINT PK_NV_MNV_LDS PRIMARY KEY (MA_NHAN_VIEN);
 
--5. Table BANHANG: Tạo các foreign key
--	FK_BH_CN: Kết nối MA_CUA_HANG với MA_CUA_HANG của table CHINHANH
ALTER TABLE Study.LDSBanHang
ADD CONSTRAINT FK_BH_CN_LDS FOREIGN KEY 
(MA_CUA_HANG) REFERENCES Study.LDSChiNhanh (MA_CUA_HANG);

--FK_BH_HH: Kết nối MAT_HANG với MAT_HANG của table HANGHOA
ALTER TABLE Study.LDSBanHang
ADD CONSTRAINT FK_BH_HH_LDS FOREIGN KEY 
(MAT_HANG) REFERENCES Study.LDSHangHoa (MAT_HANG);

--FK_BH_KH: Kết nối MA_KH với MA_KH của table KHACHHANG
ALTER TABLE Study.LDSBanHang
ADD CONSTRAINT FK_BH_KH_LDS FOREIGN KEY 
(MA_KH) REFERENCES Study.LDSKhachHang (MA_KH);


--FK_BH_NV: Kết nối MA_NV_BAN với MA_NHAN_VIEN của table NHANVIEN
ALTER TABLE Study.LDSBanHang
ADD CONSTRAINT FK_BH_NV_LDS FOREIGN KEY 
(MA_NV_BAN) REFERENCES Study.LDSNhanVien (MA_NHAN_VIEN);


--TASK 3
--Liệt kê toàn bộ các loại hàng hóa của hệ thống bán hàng này. 
--Hiển thị thêm 1 column (PAY_USD) chỉ có giá trị là ‘USD’ với các loại hàng hóa được bán ít nhất 1 lần bằng tiền USD các mặt hàng còn lại để NULL.
SELECT HH.MAT_HANG, USD.LOAI_TIEN	-- lấy ra thông tin về [Mặt hàng] , [Loại tiền]
FROM Retail.HangHoa AS HH			-- từ bảng HANGHOA (lấy dữ liệu từ bảng HH vì bảng này chứa đầy đủ thông tin của các mặt hàng)
LEFT JOIN ( 
	SELECT DISTINCT MAT_HANG, LOAI_TIEN
	FROM Retail.BanHang AS BH
	WHERE LOAI_TIEN = 'USD'
	) USD -- lấy ra từ bảng BH các mặt hàng được thanh toán bằng USD (các mặt hàng đã được thanh toán bằng USD sẽ đc hiện thị và hiển thị này là duy nhất) đặt tên là bảng usd
ON HH.MAT_HANG = USD.MAT_HANG;

--TASK 4
--Để đánh giá tình hình nợ nần tính đến nay của khách hàng. 
--Anh/chị hãy viết 1 câu truy vấn lấy ra các thông tin bao gồm:
--	Ngày, tháng, năm xuất báo cáo (truy vấn)
--	Chi nhánh, Địa điểm của chi nhánh
--	Mã KH, Họ và tên của KH
--	Tất toán future (Cột này nhận 2 giá trị là NULL và YES. Giá trị là YES khi mà khách hàng cần phải thanh toán dư nợ trong tương lai tính từ thời điểm chạy truy vấn. Giá trị là NULL khi mà khách hàng đã tất toán tất cả dư nợ tính đến thời điểm chạy truy vấn)
SELECT DISTINCT
  YEAR(GETDATE()) AS NAM
, MONTH(GETDATE()) AS THANG
, DAY(GETDATE()) AS NGAY
, BH.MA_CUA_HANG
, CN.DIA_DIEM
, KH.MA_KH
, KH.TEN_KHACH_HANG
, DUNO.FUTURE
FROM Retail.BanHang AS BH
INNER JOIN Retail.ChiNhanh AS CN ON BH.MA_CUA_HANG = CN.MA_CUA_HANG
INNER JOIN Retail.KhachHang AS KH ON BH.MA_KH = KH.MA_KH
LEFT JOIN (
    SELECT DISTINCT MA_KH, 'YES' AS FUTURE 
    FROM Retail.BanHang
    WHERE DU_NO > 0
    AND NGAY_DEN_HAN > GETDATE()
    ) AS DUNO ON BH.MA_KH = DUNO.MA_KH


--TASK 5
--Sử dụng csdl Retail thực hiện câu truy vấn cho báo cáo sau:
--Để tìm doanh số năm 2019 của STORE 99 theo từng nhân viên.
--Lưu ý: Chỉ hiển thị các nhân viên có tổng số tiền giao dịch được > 1 tỷ
--Anh/chị hãy viết 1 câu lệnh duy nhất để hiện thị đầy đủ các thông tin sau:
--	Năm, Mã chi nhánh, người quản lý
--	Mã nhân viên, Họ tên nhân viên
--	Thâm niên làm việc của nhân viên (Gồm 3 loại giá trị: Từ 0-2 năm, Từ 3-5 năm, Trên 6 năm).
--	Tổng số tiền nhân viên bán được
--	Số tiền hoa hồng cao nhất mà 1 nhân viên nhận được từ 1 giao dịch là bao nhiêu biết Số tiền hoa hồng = TRI_GIA * PHAN_TRAM_HOA_HONG / 100
SELECT CN.MA_CUA_HANG
	 , CN.QUAN_LY_CH
	 , NV.MA_NHAN_VIEN
	 , NV.TEN_NHAN_VIEN
	 , NV.THAM_NIEN
	 , BH1.TONG_TIEN
	 , BH1.HOA_HONG_CAO_NHAT
FROM (
	SELECT MA_CUA_HANG
		 , SUM(TRI_GIA) AS TONG_TIEN
		 , MA_NV_BAN
		 , MAX((TRI_GIA * PHAN_TRAM_HOA_HONG) / 100) AS HOA_HONG_CAO_NHAT
	FROM [Retail].[BanHang] AS BH
	WHERE YEAR(NGAY_GIAO_DICH) = 2019 AND MA_CUA_HANG = 'STORE 99'
	GROUP BY MA_NV_BAN, MA_CUA_HANG
	HAVING SUM(TRI_GIA) > 1000000000
	) AS BH1
INNER JOIN [Retail].[ChiNhanh] AS CN
	ON BH1.MA_CUA_HANG = CN.MA_CUA_HANG
INNER JOIN (
	SELECT *,
	CASE
		WHEN DATEDIFF(YEAR,NGAY_VAO_LAM,GETDATE()) BETWEEN 0 AND 2 THEN N'Từ 0-2 năm'
		WHEN DATEDIFF(YEAR,NGAY_VAO_LAM,GETDATE()) BETWEEN 3 AND 5 THEN N'Từ 3-5 năm'
		ELSE N'Trên 6 năm'
	END AS THAM_NIEN
	FROM [Retail].[NhanVien]
	) AS NV
	ON BH1.MA_NV_BAN = NV.MA_NHAN_VIEN

--TASK 6
--Anh/chị hãy tạo 1 View V_KHACHHANG yêu cầu có các thông tin như sau:
--MA_KHACH_HANG, TEN_KHACH_HANG
--DIA_CHI (Chỉ có 10 chữ cái đầu tiên được hiển thị) SUBSTR
--SO_DIEN_THOAI (Hiển thị '09xx.xxx.xxx' cho toàn bộ KH)
--LOAI_KH (Nếu phân hạng kh = 1 thì là 'VVIP' còn lại sẽ là 'VIP')
CREATE VIEW V_khachhang AS
SELECT MA_KH, TEN_KHACH_HANG,
SUBSTRING(DIA_CHI_KH,1,10) AS Dia_chi_KH,
'0' + left(SO_DIEN_THOAI,1) + REPLICATE('x',2) + REPLICATE('.xxx',2) AS SDT,
CASE WHEN HANG_KH=1 THEN 'VVip' ELSE 'Vip' END AS Loai_KH
FROM Retail.KhachHang

--TASK 7
--Sử dụng database Retail, giám đốc yêu cầu phân tích đặc điểm của nhóm
--khách hàng có địa chỉ ở Hà Nội tại năm 2019.
--Bạn hãy viết 1 câu WITH … AS lấy ra các thông tin theo mô tả như sau:
--	Mã của toàn bộ khách hàng có địa chỉ ở Hà Nội.
--	Tên tương ứng của KH, Số ĐT.
--	Số hóa đơn đã mua trong năm 2019.
--	Tổng số tiền mua hàng của hóa đơn trong năm 2019.
--	Tổng số tiền chậm trả trong toàn bộ lịch sử tiêu dùng của những KH này.
WITH
   HN2019 AS (
           SELECT BH.MA_KH
                , KH.TEN_KHACH_HANG
                , KH.SO_DIEN_THOAI
                , COUNT(BH.MA_HOA_DON) AS TONG_HD
                , SUM(BH.TRI_GIA) AS TONG_TIEN_GD
           FROM Retail.BANHANG AS BH
           INNER JOIN Retail.KhachHang AS KH ON BH.MA_KH = KH.MA_KH
           WHERE YEAR(BH.NGAY_GIAO_DICH) = 2019
           AND KH.DIA_CHI_KH = N'Hà Nội'
           GROUP BY BH.MA_KH
                , KH.TEN_KHACH_HANG
                , KH.SO_DIEN_THOAI
   ),
   DUNO AS ( --TOÀN BỘ DƯ NỢ CỦA TOÀN BỘ KH
   SELECT MA_KH, SUM(DU_NO) AS DU_NO
   FROM Retail.BANHANG
   GROUP BY MA_KH
   )
SELECT HN2019.*, DUNO.DU_NO
FROM HN2019
   INNER JOIN DUNO ON HN2019.MA_KH = DUNO.MA_KH



--TASK 8
--Sử dụng database Movies.
--Hãy cung cấp thông tin của những bộ phim ra mắt sau năm 1991 và có kinh phí lớn hơn 300 triệu dollar ($).
--Yêu cầu hiển thị:
--	Tên Studio sản xuất
--	Thể loại phim
--	Tên giám đốc sản xuất
--	Tên bộ phim
--	Kinh phí sản xuất
--	Thời lượng bộ phim 
--(Biết rằng 
--	nếu <60 phút thì hiển thị “Less than 1 hour” 
--	nếu >60 phút và <120 phút thì hiển thị “1 hour – 2 hours” 
--	nếu >120 phút thì hiển thị “More than 2 hours” )
--Các đơn vị tính trong Data Base đều theo $ và thời gian bộ phim tính theo phút.
SELECT ST.Studio		AS TEN_STUDIO
	 , GN.Genre			AS THE_LOAI
	 , DT.FullName		AS TEN_DAO_DIEN
	 , FM.Title			AS TEN_PHIM
	 , FM.BudgetDollars	AS KINH_PHI
	 , CASE 
			WHEN FM.RunTimeMinutes < 60 THEN 'Less than 1 hour'
			WHEN FM.RunTimeMinutes > 60 AND FM.RunTimeMinutes < 120 THEN '1 hour - 2 hours'
			WHEN FM.RunTimeMinutes > 120 THEN 'More than 2 hours'
	 END				AS THOI_LUONG_PHIM
FROM [Movies].[Film] AS FM
INNER JOIN [Movies].[Studio] AS ST
	ON FM.StudioID = ST.StudioID
INNER JOIN [Movies].[Genre] AS GN
	ON FM.GenreID = GN.GenreID
INNER JOIN [Movies].[Director] AS DT
	ON FM.DirectorID = DT.DirectorID
WHERE YEAR(FM.ReleaseDate) > 1991 AND FM.BudgetDollars > 300000000;

--TASK 9
--Sử dụng database Movies.
--Để phục vụ trao giải cống hiến năm 2004 trong hạng mục dành cho các diễn viên.
--Bạn vui lòng viết 1 câu truy vấn duy nhất lấy các thông tin như sau:
--	Tên diễn viên
--	Tổng số bộ phim đã làm trong năm 2004
--	Tổng số lần được đề cử Oscar trong năm 2004
--	Diễn viên đã từng cộng tác với các hãng phim nào từ khi vào nghề? Số lượng bộ phim đã làm với từng hãng đó là bao nhiêu
WITH
	ACT AS (--Khối con này đi tìm các diễn viên, phim diễn viên đó tham gia, số đề cử đạt được trong năm 2004
		SELECT AC.ActorID, AC.FullName 
			, COUNT(DISTINCT FM.FilmID) AS SO_PHIM
			, SUM(OscarNominations) AS DE_CU_OSCAR
		FROM [Movies].[Film] AS FM
		INNER JOIN [Movies].[Role] AS RL
			ON FM.FilmID = RL.FilmID
		INNER JOIN [Movies].[Actor] AS AC
			ON AC.ActorID = RL.ActorID
		WHERE YEAR(FM.ReleaseDate) = 2004
		GROUP BY AC.ActorID, AC.FullName
	),
	ACT_COOP AS (--Khối con này đi tìm các diễn viên đã cộng tác với các hãng phim nào từ khi vào nghề
				 --và số phim đã đóng cùng các NSX đó là bao nhiêu trong toàn bộ lịch sử
		SELECT AC.ActorID, ST.Studio, COUNT(DISTINCT FM.FilmID) AS SO_PHIM_CUNG_STUDIO
		FROM [Movies].[Actor] AS AC
		INNER JOIN [Movies].[Role] AS RL
			ON AC.ActorID = RL.ActorID
		INNER JOIN [Movies].[Film] AS FM
			ON RL.FilmID = FM.FilmID
		INNER JOIN [Movies].[Studio] AS ST
			ON FM.StudioID = ST.StudioID
		GROUP BY AC.ActorID, ST.Studio
	)
SELECT *
FROM ACT
INNER JOIN ACT_COOP
	ON ACT.ActorID = ACT_COOP.ActorID
ORDER BY ACT.ActorID

--TASK 10
-- Hãy cung cấp Tên và ngày ra mắt của những bộ phim phát hành sau năm 2000 và có kinh phí lớn hơn 300 triệu dollar ($).
-- Biết rằng các đơn vị tính trong DB đều theo $.
SELECT Title, ReleaseDate
FROM [Movies].[Film]
WHERE YEAR(ReleaseDate) > 2000 AND BudgetDollars > 300000000;

--CÂU 2
-- Hãy cho biết top 3 ngôn ngữ được sử dụng để làm ra nhiều bộ phim nhất.
-- Yêu cầu kết quả chứa các thông tin sau:
--	Tên ngôn ngữ.
--	Số lượng bộ phim đã sản xuất của ngôn ngữ đó.
--	Tổng kinh phí đã sử dụng để sản xuất phim với ngôn ngữ đó.
--	Tổng số diễn viên đã tham gia các bộ phim đóng bởi ngôn ngữ đó

SELECT  LG.Language AS NGON_NGU
		, COUNT(DISTINCT FM.FilmID) AS SO_PHIM
		, KINHPHI.BudgetDollars AS KINH_PHI
		, COUNT(DISTINCT RL.ActorID) AS SO_DIEN_VIEN
FROM [Movies].[Film] AS FM
INNER JOIN [Movies].[Language] AS LG
	ON FM.LanguageID = LG.LanguageID
INNER JOIN (
	SELECT LanguageID, SUM(BudgetDollars) BudgetDollars
	FROM [Movies].[Film] AS FM 
	GROUP BY LanguageID) KINHPHI
	ON LG.LanguageID = KINHPHI.LanguageID
LEFT JOIN [Movies].[Role] AS RL
	on FM.FilmID = RL.FilmID
GROUP BY FM.LanguageID, LG.Language, KINHPHI.BudgetDollars
	HAVING COUNT(DISTINCT FM.FilmID) >= ANY (
	SELECT TOP 3 SO_PHIM 
	FROM (
			SELECT DISTINCT COUNT(DISTINCT FilmID) so_phim
			FROM [Movies].[Film]
			GROUP BY LanguageID
		 ) SRC ORDER BY SO_PHIM DESC
) ORDER BY SO_PHIM DESC;

--TASK 11
--Tìm nam diễn viên đóng nhiều phim thuộc thể loại Hành động (Action) nhất.
--Yêu cầu hiển thị:
--	Tên đầy đủ
--	Năm sinh
--	Số bộ phim Hành động đã đóng
--	Số giải Oscar mà nam diễn viên đã giành được với toàn bộ các thể loại phim.
WITH
	DV_NAM AS(
		SELECT TOP 1
			   AC.ActorID
			 , AC.FullName
			 , YEAR(AC.DoB) AS NAM_SINH
			 , COUNT(DISTINCT FM.FilmID) AS SO_PHIM_HD
		FROM [Movies].[Actor] AS AC
		INNER JOIN [Movies].[Role] AS RL
			ON AC.ActorID = RL.ActorID
		INNER JOIN [Movies].[Film] AS FM
			ON RL.FilmID = FM.FilmID
		INNER JOIN [Movies].[Genre] AS GN
			ON FM.GenreID = GN.GenreID
		WHERE AC.Gender = 'Male' AND GN.Genre = 'Action'
		GROUP BY AC.ActorID, AC.FullName, YEAR(AC.DoB)
		ORDER BY COUNT(DISTINCT FM.FilmID) DESC
	),
	GIAI_OSCAR AS(
		SELECT AC.ActorID, SUM(FM.OscarWins) AS SO_GIAI_OSCAR
		FROM [Movies].[Actor] AS AC
		INNER JOIN [Movies].[Role] AS RL
			ON AC.ActorID = RL.ActorID
		INNER JOIN [Movies].[Film] AS FM
			ON RL.FilmID = FM.FilmID
		INNER JOIN [Movies].[Genre] AS GN
			ON FM.GenreID = GN.GenreID
		WHERE AC.Gender = 'Male'
		GROUP BY AC.ActorID
	)
SELECT DV_NAM.FullName, DV_NAM.NAM_SINH, DV_NAM.SO_PHIM_HD, GIAI_OSCAR.SO_GIAI_OSCAR
FROM DV_NAM
INNER JOIN GIAI_OSCAR
	ON DV_NAM.ActorID = GIAI_OSCAR.ActorID

--TASK 12
--Để tìm ra diễn viên xuất sắc nhất mọi thời đại.
--Bạn vui lòng viết 1 câu truy vấn duy nhất lấy ra 5 diễn viên có số lần đạt giải oscar nhiều nhất, yêu cầu có các thông tin như sau:
--	Tên đầy đủ của diễn viên, năm sinh
--	Tổng số bộ phim đã làm trong toàn bộ sự nghiệp tính đến hiện tại
--	Tổng số lần được đề cử Oscar trong toàn bộ sự nghiệp
--	Tổng số lần chiến thắng giải Oscar trong toàn bộ sự nghiệp
--	Tỷ lệ % số oscar đạt được so với đề cử là bao nhiêu
--	Tỷ lệ % đạt được oscar khi tham gia 1 bộ phim là bao nhiêu
WITH 
A AS
	(SELECT TOP 5 AC.ActorID, AC.FullName, year(AC.DoB) AS NAMSINH,
	COUNT(DISTINCT(FM.FilmID)) AS SOPHIM, 
	SUM(FM.OscarNominations) AS TONGDECUOSCAR,
	SUM(FM.OscarWins) AS TONGOSCAR
	FROM [Movies].[Actor] AS AC
	INNER JOIN [Movies].[Role] AS RL 
		ON AC.ActorID = RL.ActorID
	INNER JOIN [Movies].[Film] AS FM 
		ON FM.FilmID = RL.FilmID
	GROUP BY AC.ActorID, AC.FullName, YEAR(AC.DoB)
	ORDER BY TONGOSCAR DESC),-- khối này lấy ra top 5 diễn viên có nhiều giải oscar nhất
B AS
	(SELECT AC.ActorID, AC.FullName, COUNT(DISTINCT(FM.FilmID)) AS SOPHIMWIN
	FROM [Movies].[Actor] AS AC
	INNER JOIN [Movies].[Role] AS RL 
		ON AC.ActorID = RL.ActorID
	INNER JOIN [Movies].[Film] AS FM 
		ON FM.FilmID = RL.FilmID
	WHERE FM.OscarWins>0 
	GROUP BY AC.ActorID, AC.FullName) -- khối này lấy ra số phim win theo từng diễn viên
SELECT A.*, A.TONGOSCAR*100/A.TONGDECUOSCAR AS TILETHANGDECU,
B.SOPHIMWIN*100/A.SOPHIM AS TILEPHIMWIN
FROM A LEFT JOIN B ON A.ActorID = B.ActorID




