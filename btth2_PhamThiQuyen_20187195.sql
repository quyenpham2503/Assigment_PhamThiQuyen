--1.
select * from CAUTHU;

--2.
select * from CAUTHU
where SO = 7 and VITRI = N'Tiền vệ ';

--3.
-- Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cảcác huấn luyện viên.
select TENHLV, NGAYSINH, DIACHI
from HUANLUYENVIEN;

--4.Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ Becamex Bình Dương
select *  from CAUTHU 
where MAQG in ( select MAQG from QUOCGIA where TENQG = N'Việt Nam') 
and MACLB in (Select MACLB from CAULACBO where TENCLB = N'Becamex Bình Dương')

--5.Cho biết mã số, họtên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch “Bra-xin”
select *  from CAUTHU 
where MAQG in ( select MAQG from QUOCGIA where TENQG = N'Brazil') 
and MACLB in (Select MACLB from CAULACBO where TENCLB = N'SHB Đà Nẵng')

--6.Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An”
select * from CAUTHU 
where MACLB in 
(select MACLB from CAULACBO where MASAN in 
(select MASAN from SANVD where TENSAN = N'Sân Long An'))

select * 
from CAUTHU ct join CAULACBO clb 
on ct.MACLB = clb.MACLB 
join SANVD svd
on clb.MASAN = svd.MASAN 
where TENSAN = N'Sân Long An'


--7.Cho biết kết quả(MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009
select MATRAN, NGAYTD, TENSAN, MACLB1, MACLB2, KETQUA 
from TRANDAU, SANVD
where VONG = 2 and NAM = 2009

--8.Cho biết mã huấn luyện viên, họtên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “ViệtNam”
select hlv.MAHLV , hlv.TENHLV, hlv.NGAYSINH, hlv.DIACHI,h2.VAITRO, clb.TENCLB
from HUANLUYENVIEN hlv join HLV_CLB h2
on hlv.MAHLV = h2.MAHLV
join QUOCGIA qg on qg.MAQG= hlv.MAQG
and TENQG = N'Việt Nam'
join CAULACBO clb on h2.MACLB = clb.MACLB


--9.Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3, năm 2009
select top 3 clb.TENCLB
from BANGXH bxh join CAULACBO clb
on clb.MACLB = bxh.MACLB
and bxh.NAM =2009
and bxh.VONG =3
order by bxh.DIEM desc

--10.Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương.
select hlv.MAHLV, TENHLV, NGAYSINH, DIACHI, VAITRO, TENCLB
from HUANLUYENVIEN hlv 
join HLV_CLB c on hlv.MAHLV = c.MAHLV
join CAULACBO clb on clb.MACLB = c.MACLB
join TINH t on t.MATINH = clb.MATINH
where t.TENTINH = N'Bình Dương'


--1.Thống kê số lượng cầu thủ của mỗi câu lạc bộ
select TENCLB, COUNT (distinct MACT) as Soluong
from CAUTHU ct join CAULACBO clb
on ct.MACLB = clb.MACLB
group by TENCLB


--2.Thống kê sốlượng cầu thủ nước ngoài (có quốc tịch ViệtNam) của mỗi câu lạc bộ
select TENCLB, count (distinct MACT) as soluong
FROM CAUTHU ct join CAULACBO clb
on ct.MACLB = clb.MACLB
join QUOCGIA qg
on qg.MAQG = ct.MAQG where qg.MAQG in (select MAQG from QUOCGIA where TENQG != N'Việt Nam')
group by TENCLB

--3.Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉvà sốlượng cầu thủnước ngoài (có quốc tịch khác Việt Nam) tương ứng của các
--câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
select TENCLB, clb.MACLB, TENSAN, svd.DIACHI, count (distinct MACT) as soluong
FROM CAUTHU ct join CAULACBO clb
on ct.MACLB = clb.MACLB
join SANVD svd 
on svd.MASAN = clb.MASAN
join QUOCGIA qg
on qg.MAQG = ct.MAQG where qg.MAQG in (select MAQG from QUOCGIA where TENQG != N'Việt Nam')
group by TENCLB, clb.MACLB, TENSAN, svd.DIACHI
having count (MACT) >= 2


--4.Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý 
select TENTINH, VITRI, count (distinct MACT) as soluong
from TINH t join CAULACBO clb
on t.MATINH = clb.MATINH
join CAUTHU ct
on ct.MACLB = clb.MACLB where VITRI in (select VITRI from CAUTHU where VITRI = N'Tiền Đạo' )
group by TENTINH, VITRI

--5.Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng vòng 3, năm 2009
select top 1 TENCLB, TENTINH
from CAULACBO clb join BANGXH bxh
on VONG = 3 and NAM = 2009
join TINH t
on t.MATINH = clb.MATINH

--1.Cho biết tên huấn luyện viên đang nắm giữ một vịtrí trong một câu lạc bộ mà chưa có số điện thoại
select TENHLV, VAITRO
from HUANLUYENVIEN hlv JOIN HLV_CLB c
on hlv.MAHLV = c.MAHLV
where hlv.DIENTHOAI is NULL

--2.Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào
SELECT * FROM HUANLUYENVIEN AS HLV
WHERE HLV.MAHLV NOT IN (SELECT HLV_CLB.MAHLV FROM HLV_CLB)
AND HLV.MAQG = 'VN'
 

--3.Liệt kê các cầu thủđang thi đấu trong các câu lạc bộcó thứhạng ởvòng 3 năm 2009 lớn hơn 6 hoặc nhỏ  hơn 3
SELECT CT.MACT, CT.HOTEN, CT.VITRI, CT.NGAYSINH, CT.DIACHI, CT.MACLB, CT.MAQG, CT.SO FROM BANGXH
JOIN CAULACBO AS CLB ON CLB.MACLB = BANGXH.MACLB
JOIN CAUTHU AS CT ON CT.MACLB = BANGXH.MACLB
WHERE BANGXH.VONG = 3 AND BANGXH.NAM = 2009 AND (BANGXH.HANG > 3 OR BANGXH.HANG < 6)

--4.Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ(CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009
SELECT MATRAN, NGAYTD, CLB1.TENCLB, CLB2.TENCLB, KETQUA FROM TRANDAU
JOIN CAULACBO AS CLB1 ON CLB1.MACLB = TRANDAU.MACLB1
JOIN CAULACBO AS CLB2 ON CLB2.MACLB = TRANDAU.MACLB2
WHERE CLB1.MACLB IN (SELECT TOP 1 MACLB FROM BANGXH WHERE VONG = 3 AND NAM = 2009 ORDER BY DIEM DESC)
OR CLB2.MACLB IN (SELECT TOP 1 MACLB FROM BANGXH WHERE VONG = 3 AND NAM = 2009 ORDER BY DIEM DESC)
ORDER BY TRANDAU.MATRAN
