'usr strict'

export const FIND_STORE = 'SET @mac = ?; \
SELECT b.store_no, s.name, b.serial, getBeaconSection(b.minor) AS section_no, getBeaconTable(b.minor) AS table_no \
  FROM tbbell b \
  LEFT OUTER JOIN tbstore s ON b.store_no = s.no \
WHERE mac = @mac;';