USE rezervasyon
GO
/* �ncelikle log tablosu ekliyoruz. yoksa ekle. 
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


-- �nceki trigger'� kald�r�n
DROP TRIGGER IF EXISTS trPersonelUpdate;


-- create triggerdan sonraki islem. 
-- iv. Trigger'� test etmek i�in bir �rnek INSERT i�lemi
-- Bu i�lem 'Ferdi Kanat' isimli bir personeli eklemeye �al��acakt�r, ancak trigger taraf�ndan engellenecektir.
INSERT INTO tblPersonel (personel_ad, personel_soyad, personel_telefon, OtelId, IlKodu, IlceKodu, personel_dogumTarihi, personel_TC, personel_cinsiyet)
VALUES ('Ferdi', 'Kanat', '1234567890', 1, 1, 1, '1990-01-01', '12345678930','erkek');
