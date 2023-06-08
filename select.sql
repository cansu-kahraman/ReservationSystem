SELECT personel_ad, personel_soyad, personel_dogumTarihi
FROM tblPersonel
WHERE MONTH(personel_dogumTarihi) = MONTH(GETDATE()) AND DAY(personel_dogumTarihi) = DAY(GETDATE());
