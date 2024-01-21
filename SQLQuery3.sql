EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'


-- tblOda tablosundaki verileri sil
DELETE FROM tblOda;
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'


IF OBJECT_ID('IndexOda1') IS NOT NULL
            DROP TABLE IndexOda1
GO
IF OBJECT_ID('IndexOda2') IS NOT NULL
            DROP TABLE IndexOda2
GO
-- Ýki farklý durumu simüle eden IndeksOda1 tablosunu oluþtur (PRIMARY KEY)
CREATE TABLE IndeksOda1 (
    oda_id INT ,
    odaturu_id INT,
    oda_numara VARCHAR(4),
    oda_dolulukDurumu VARCHAR(4)
)

-- Ýki farklý durumu simüle eden IndeksOda2 tablosunu oluþtur (NONCLUSTERED INDEX)
CREATE TABLE IndeksOda2 (
    oda_id INT PRIMARY KEY,
    odaturu_id INT,
    oda_numara VARCHAR(4),
    oda_dolulukDurumu VARCHAR(4)
)
DROP INDEX idxIndexOda2 ON IndexOda2
-- Nonclustered index oluþtur
CREATE NONCLUSTERED INDEX idxIndeksOda2 ON IndeksOda2 (oda_id)
WITH (PAD_INDEX = ON, FILLFACTOR = 90, DROP_EXISTING = OFF)

-- Verileri ekle
DECLARE @x INT = 1
DECLARE @oda_dolulukDurumu VARCHAR(4)
DECLARE @odaturu_id INT

WHILE @x <= 10000
BEGIN
    IF @x > 5000
    BEGIN
        SET @oda_dolulukDurumu = 'dolu'
        SET @odaturu_id = 1  -- Dolu odalarýn odaturu_id'si, uygun bir deðer atayýn
    END
    ELSE
    BEGIN
        SET @oda_dolulukDurumu = 'bos'
        SET @odaturu_id = 2  -- Boþ odalarýn odaturu_id'si, uygun bir deðer atayýn
    END

    INSERT INTO tblOda (odaturu_id, oda_dolulukDurumu) VALUES (@odaturu_id, @oda_dolulukDurumu)
    INSERT INTO IndeksOda1 (oda_id, odaturu_id, oda_numara, oda_dolulukDurumu) VALUES (@x, @odaturu_id, CONVERT(VARCHAR(4), @x), @oda_dolulukDurumu)
    INSERT INTO IndeksOda2 (oda_id, odaturu_id, oda_numara, oda_dolulukDurumu) VALUES (@x, @odaturu_id, CONVERT(VARCHAR(4), @x), @oda_dolulukDurumu)

    SET @x += 1
END

-- STATISTICS IO'yu aç
SET STATISTICS IO ON

-- Sorgularý çalýþtýr
-- tblOda tablosu için
SELECT * FROM tblOda WHERE oda_id > 5000
SELECT * FROM tblOda WHERE oda_dolulukDurumu = 'dolu'

-- IndeksOda1 tablosu için (PRIMARY KEY)
SELECT * FROM IndeksOda1 WHERE oda_id > 5000
SELECT * FROM IndeksOda1 WHERE oda_dolulukDurumu = 'dolu'

-- IndeksOda2 tablosu için (NONCLUSTERED INDEX)
SELECT * FROM IndeksOda2 WHERE oda_id > 5000
SELECT * FROM IndeksOda2 WHERE oda_dolulukDurumu = 'dolu'
