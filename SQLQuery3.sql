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
-- �ki farkl� durumu sim�le eden IndeksOda1 tablosunu olu�tur (PRIMARY KEY)
CREATE TABLE IndeksOda1 (
    oda_id INT ,
    odaturu_id INT,
    oda_numara VARCHAR(4),
    oda_dolulukDurumu VARCHAR(4)
)

-- �ki farkl� durumu sim�le eden IndeksOda2 tablosunu olu�tur (NONCLUSTERED INDEX)
CREATE TABLE IndeksOda2 (
    oda_id INT PRIMARY KEY,
    odaturu_id INT,
    oda_numara VARCHAR(4),
    oda_dolulukDurumu VARCHAR(4)
)
DROP INDEX idxIndexOda2 ON IndexOda2
-- Nonclustered index olu�tur
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
        SET @odaturu_id = 1  -- Dolu odalar�n odaturu_id'si, uygun bir de�er atay�n
    END
    ELSE
    BEGIN
        SET @oda_dolulukDurumu = 'bos'
        SET @odaturu_id = 2  -- Bo� odalar�n odaturu_id'si, uygun bir de�er atay�n
    END

    INSERT INTO tblOda (odaturu_id, oda_dolulukDurumu) VALUES (@odaturu_id, @oda_dolulukDurumu)
    INSERT INTO IndeksOda1 (oda_id, odaturu_id, oda_numara, oda_dolulukDurumu) VALUES (@x, @odaturu_id, CONVERT(VARCHAR(4), @x), @oda_dolulukDurumu)
    INSERT INTO IndeksOda2 (oda_id, odaturu_id, oda_numara, oda_dolulukDurumu) VALUES (@x, @odaturu_id, CONVERT(VARCHAR(4), @x), @oda_dolulukDurumu)

    SET @x += 1
END

-- STATISTICS IO'yu a�
SET STATISTICS IO ON

-- Sorgular� �al��t�r
-- tblOda tablosu i�in
SELECT * FROM tblOda WHERE oda_id > 5000
SELECT * FROM tblOda WHERE oda_dolulukDurumu = 'dolu'

-- IndeksOda1 tablosu i�in (PRIMARY KEY)
SELECT * FROM IndeksOda1 WHERE oda_id > 5000
SELECT * FROM IndeksOda1 WHERE oda_dolulukDurumu = 'dolu'

-- IndeksOda2 tablosu i�in (NONCLUSTERED INDEX)
SELECT * FROM IndeksOda2 WHERE oda_id > 5000
SELECT * FROM IndeksOda2 WHERE oda_dolulukDurumu = 'dolu'
