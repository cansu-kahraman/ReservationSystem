--SELECT1
WITH TopHotels AS (
  SELECT TOP 3 otel_id
  FROM tblRezervasyon
  WHERE YEAR(rezervasyon_bitisTarihi) = YEAR(GETDATE()) - 1
    AND Otel_id IN (
      SELECT otel_id
      FROM tblOtel
      WHERE IlKodu = (
        SELECT il_kod
        FROM tblIl
        WHERE il_ad = 'Yalova'
      )
    )
  GROUP BY otel_id
  ORDER BY COUNT(*) DESC
)
SELECT
  tblOdaTuru.odaturu_ad AS PreferredRoomType,
  COUNT(tblMusteri.musteri_id) AS PreferenceCount,
  COUNT(DISTINCT tblMusteri.musteri_id) AS UniqueCustomers
FROM
  tblRezervasyon
  INNER JOIN tblOda ON tblRezervasyon.Oda_id = tblOda.oda_id
  INNER JOIN tblOdaTuru ON tblOda.odaturu_id = tblOdaTuru.odaturu_id
  INNER JOIN tblMusteri ON tblRezervasyon.Musteri_id = tblMusteri.musteri_id
WHERE
  YEAR(tblRezervasyon.rezervasyon_bitisTarihi) = YEAR(GETDATE())
  AND tblOdaTuru.odaturu_id IN (
    SELECT odaturu_id
    FROM tblOdaTuru
    GROUP BY odaturu_id
    HAVING COUNT(*) > 0
  )
  AND tblRezervasyon.Otel_id IN (
    SELECT otel_id
    FROM TopHotels
  )
GROUP BY
  tblOdaTuru.odaturu_ad
HAVING
  COUNT(tblMusteri.musteri_id) > 0
ORDER BY
  CASE WHEN COUNT(tblMusteri.musteri_id) > 10 THEN tblOdaTuru.odaturu_ad END ASC,
  CASE WHEN COUNT(tblMusteri.musteri_id) <= 10 THEN tblOdaTuru.odaturu_ad END DESC;




--SELECT2
  --
 DECLARE @CurrentYear INT = YEAR(GETDATE())
DECLARE @CurrentMonth INT = MONTH(GETDATE())

SELECT
    otel.otel_ad AS OtelAdi,
    AVG(CASE WHEN YEAR(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentYear - 1 AND MONTH(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentMonth THEN DATEDIFF(DAY, rezervasyon.rezervasyon__baslangicTarihi, rezervasyon.rezervasyon_bitisTarihi) END) AS GecenYilOrtalamaSuresi,
    AVG(CASE WHEN YEAR(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentYear AND MONTH(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentMonth THEN DATEDIFF(DAY, rezervasyon.rezervasyon__baslangicTarihi, rezervasyon.rezervasyon_bitisTarihi) END) AS BuYilOrtalamaSuresi
FROM
    tblOtel AS otel
    INNER JOIN tblRezervasyon AS rezervasyon ON otel.otel_id = rezervasyon.Otel_id
GROUP BY
    otel.otel_ad
HAVING
    AVG(CASE WHEN YEAR(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentYear - 1 AND MONTH(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentMonth THEN DATEDIFF(DAY, rezervasyon.rezervasyon__baslangicTarihi, rezervasyon.rezervasyon_bitisTarihi) END) > AVG(CASE WHEN YEAR(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentYear AND MONTH(rezervasyon.rezervasyon__baslangicTarihi) = @CurrentMonth THEN DATEDIFF(DAY, rezervasyon.rezervasyon__baslangicTarihi, rezervasyon.rezervasyon_bitisTarihi) END);
