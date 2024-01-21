USE rezervasyon
GO
/* öncelikle log tablosu ekliyoruz. yoksa ekle. 
CREATE TABLE tblPersonelLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    LogType VARCHAR(50) NOT NULL,
    LogDate DATETIME NOT NULL,
    PersonelID INT,
    PersonelAd VARCHAR(20),
    PersonelSoyad VARCHAR(20),
    PersonelTelefon CHAR(10),
    OtelID INT,
    IlKodu INT,
    IlceKodu INT
);
*/


-- Önceki trigger'ý kaldýrýn
DROP TRIGGER IF EXISTS trPersonelUpdate;


-- create triggerdan sonraki islem. 
-- iv. Trigger'ý test etmek için bir örnek INSERT iþlemi
-- Bu iþlem 'Ferdi Kanat' isimli bir personeli eklemeye çalýþacaktýr, ancak trigger tarafýndan engellenecektir.
INSERT INTO tblPersonel (personel_ad, personel_soyad, personel_telefon, OtelId, IlKodu, IlceKodu, personel_dogumTarihi, personel_TC, personel_cinsiyet)
VALUES ('Ferdi', 'Kanat', '1234567890', 1, 1, 1, '1990-01-01', '12345678930','erkek');
