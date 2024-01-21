-- Trigger'ý tekrar oluþturun
USE rezervasyon
GO
CREATE OR ALTER TRIGGER trPersonelUpdate
ON tblPersonel
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- ii. Trigger, tblPersonel tablosundaki kayýtlarý kontrol eder ve koþula uymayanlarý iptal eder.
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        WHERE i.personel_ad = 'Ferdi' AND i.personel_soyad = 'Kanat' OR i.personel_TC = '12345678901'
    )
    BEGIN
        -- Eðer þart saðlanmýyorsa iþlemi geri al ve hata mesajýný yazdýr
        ROLLBACK;
        PRINT 'Transaction rolled back. Invalid personnel information or duplicate TC number.';
        RETURN;
    END

    -- iii. Trigger, tblPersonelLog tablosuna deðiþiklikleri loglar.
    INSERT INTO tblPersonelLog (
        LogType,
        LogDate,
        PersonelID,
        PersonelAd,
        PersonelSoyad,
        PersonelTelefon,
        OtelID,
        IlKodu,
        IlceKodu
    )
    SELECT
        CASE
            WHEN EXISTS(SELECT 1 FROM DELETED) THEN 'Update'
            ELSE 'Insert'
        END,
        GETDATE(),
        COALESCE(i.personel_id, d.personel_id),
        COALESCE(i.personel_ad, d.personel_ad),
        COALESCE(i.personel_soyad, d.personel_soyad),
        COALESCE(i.personel_telefon, d.personel_telefon),
        COALESCE(i.OtelId, d.OtelId),
        COALESCE(i.IlKodu, d.IlKodu),
        COALESCE(i.IlceKodu, d.IlceKodu)
    FROM INSERTED i
    FULL OUTER JOIN DELETED d ON i.personel_id = d.personel_id;

END;
