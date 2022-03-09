# HB0001 - HelloButton 정보 조회
SET @mac	= ?;
# 0

# 1. 정보조회
SELECT b.store_no, s.name, b.serial, getBeaconSection(b.minor) AS section_no, getBeaconTable(b.minor) AS table_no
  FROM tbbell b
  LEFT OUTER JOIN tbstore s ON b.store_no = s.no
WHERE mac = @mac
;
