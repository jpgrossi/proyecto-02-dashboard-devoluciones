--Volumen de devoluciones por país
SELECT SIT_SITE_ID AS pais,
       COUNT(*) AS cantidad_devoluciones,
       SUM(GMV_USD_SHP) AS total_usd_mercaderia
FROM DATA#RETURNS_BASE$
GROUP BY SIT_SITE_ID
ORDER BY cantidad_devoluciones DESC;

--Impacto por acortar o alargar el plazo de reclamo
SELECT SIT_SITE_ID AS pais,
       COUNT(*) AS reclamos_fuera_plazo,
       SUM(PAGO_BPP_USD) AS monto_pagado_fuera_plazo
FROM DATA#RETURNS_BASE$
WHERE CASE_DATE > DATEADD(day, 3, DT_SHP_STATUS_FINAL)
GROUP BY SIT_SITE_ID
ORDER BY reclamos_fuera_plazo DESC;

--Categorias prioritrias para Triage
SELECT t1.VERTICAL AS categoria,
       COUNT(*) AS cantidad_devoluciones,
       SUM(t1.GMV_USD_SHP) AS total_usd_devuelto,
       t2.STATUS_ENCENDIDO AS triage_activo
FROM DATA#RETURNS_BASE$ AS t1
LEFT JOIN DATA#CATEGORIAS_TRIAGE$ AS t2
  ON t1.CAT_CATEG_ID = t2.CATEG_ID
GROUP BY t1.VERTICAL, t2.STATUS_ENCENDIDO
ORDER BY categoria , total_usd_devuelto DESC;

--Historial de reclamos fuera de plazo por seller
SELECT t1.CUS_CUST_ID AS seller,
       COUNT(*) AS reclamos_fuera_plazo
FROM [DATA#RETURNS_BASE$] t1
WHERE t1.CASE_DATE > DATEADD(day, 3, t1.DT_SHP_STATUS_FINAL)
GROUP BY t1.CUS_CUST_ID
ORDER BY reclamos_fuera_plazo DESC;

--Categoría del producto y valor GMV
SELECT t1.SHP_SHIPMENT_ID,
       t1.CUS_CUST_ID AS seller,
       t1.VERTICAL AS categoria_producto,
       t1.GMV_USD_SHP AS valor_gmv_usd
FROM [DATA#RETURNS_BASE$] t1;

--Frecuencia de devoluciones por item
SELECT t1.ITE_ITEM_ID,
       COUNT(*) AS frecuencia_devoluciones_item
FROM [DATA#RETURNS_BASE$] t1
GROUP BY t1.ITE_ITEM_ID
ORDER BY frecuencia_devoluciones_item DESC;

--Reclamos fuera de plazo por seller y por mes
SELECT t1.CUS_CUST_ID AS seller,
       FORMAT(t1.CASE_DATE, 'yyyy-MM') AS mes,
       COUNT(*) AS reclamos_fuera_plazo
FROM [DATA#RETURNS_BASE$] t1
WHERE t1.CASE_DATE > DATEADD(day, 3, t1.DT_SHP_STATUS_FINAL)
GROUP BY t1.CUS_CUST_ID,
         FORMAT(t1.CASE_DATE, 'yyyy-MM')
ORDER BY mes, reclamos_fuera_plazo DESC;

