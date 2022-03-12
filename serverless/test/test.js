'use strict'

const { exit } = require('process');
var db = require('../modules/db');
var lambda = require('../modules/lambda');

const FIND_STORE = 'SET @mac=?;SELECT b.store_no, s.name, b.serial, getBeaconSection(b.minor) AS section_no, getBeaconTable(b.minor) AS table_no FROM tbbell b LEFT OUTER JOIN tbstore s ON b.store_no = s.no WHERE mac = @mac;';


const handler = async () => {
  try {
    var param = lambda.getparams({body: JSON.stringify({ mac: '00:00:00:00:00:12' })}, ['mac!', 'test']);
    // var param = getparams({}, ['mac!', 'test']);
    var resp = await db.pool.querySync(FIND_STORE, [param.mac]);
    console.log(lambda.response(resp));
  } catch (e) {
    console.log(lambda.error(e));
  }  
}

handler().then(() => {
  console.log('fine');  
  exit(1);
});
