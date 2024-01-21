

IF OBJECT_ID('kalanMusteriSayisi') IS NOT NULL
BEGIN
DROP FUNCTION kalanMusteriSayisi
END
GO

-- Girilen tarihler arasýnda otelde kaç müþterinin kaldýðýný veren fonksiyon.
CREATE OR ALTER FUNCTION kalanMusteriSayisi(@baslangicTarihi DATE, @bitisTarihi DATE)
RETURNS INT
AS
BEGIN
    DECLARE @kalanMusteriSayisi INT;

    SELECT @kalanMusteriSayisi = SUM(rezervasyon_kisiSayisi)
    FROM (
        SELECT DISTINCT R.rezervasyon_id, R.rezervasyon_kisiSayisi
        FROM tblRezervasyon R
        INNER JOIN tblMusteri M ON R.musteri_id = M.musteri_id
        WHERE (R.rezervasyon__baslangicTarihi <= @bitisTarihi AND R.rezervasyon_bitisTarihi >= @baslangicTarihi)
    ) AS Rezervasyonlar;

    RETURN ISNULL(@kalanMusteriSayisi, 0);
END;

SELECT dbo.kalanMusteriSayisi('2022-08-05', '2022-09-22') as kalanMusteriSayisi;


-- Müþterilerin konaklama tarihine göre otelde bulunma durumlarýný gösteren view
CREATE OR ALTER VIEW vwKalanMusteriSayisi AS
SELECT
    R.rezervasyon_id,
    M.musteri_ad,
    CASE 
        WHEN R.rezervasyon_bitisTarihi < GETDATE() THEN 'Tamamlanan'
		WHEN R.rezervasyon__baslangicTarihi > GETDATE() THEN 'HENÜZ KONAKLAMADI'
        ELSE 'Otelde'
    END AS musteri_durumu,
    dbo.kalanMusteriSayisi(R.rezervasyon__baslangicTarihi, R.rezervasyon_bitisTarihi) AS kalan_musteri_sayisi,
    FORMAT(R.rezervasyon__baslangicTarihi, 'dd/MM/yyyy') AS baslangic_tarihi,
    FORMAT(R.rezervasyon_bitisTarihi, 'dd/MM/yyyy') AS bitis_tarihi
FROM tblRezervasyon R
INNER JOIN tblMusteri M ON R.musteri_id = M.musteri_id
--WHERE (R.rezervasyon__baslangicTarihi <= GETDATE() AND R.rezervasyon_bitisTarihi >= GETDATE());



SELECT * FROM vwKalanMusteriSayisi;