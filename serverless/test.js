'use strict'

var mysql = require('mysql');
// var async = require('async');

const FIND_STORE = 'SET @mac=?;SELECT b.store_no, s.name, b.serial, getBeaconSection(b.minor) AS section_no, getBeaconTable(b.minor) AS table_no FROM tbbell b LEFT OUTER JOIN tbstore s ON b.store_no = s.no WHERE mac = @mac;';


var pool_mariadb = mysql.createPool({
	host				:'hf-dev.c1dsfak07rhb.ap-northeast-2.rds.amazonaws.com',
	port				: 3306,
	user				: 'hellobell',
	password			: 'gntlr?znzl',
	database			:'hellobell_v2',
	connectionLimit		: 100,
	//connectTimeout      : 60 * 60 * 1000,
	//aquireTimeout       : 60 * 60 * 1000,
	//timeout             : 60 * 60 * 1000,
	waitForConnections	: true,
	multipleStatements	: true
});

pool_mariadb.querySync = function (sql, ...params) {
  return new Promise((resolve, reject) => {
    this.query(sql, params, (err, res) => {
      console.log('result', err, res);
      if (err) {
        reject(err);
        return;
      }
      resolve(res);
    });
  });
};


const response = (data, status = 200) => {
  if (typeof data == 'string')
    return {
      statusCode: status,
      body: data
    };

  return {
    statusCode: status,
    body: JSON.stringify(data, null, 2)
  };
};

const error = (e) => {
  if (e.name && e.name == 'AppException')
    return response({ code: e.code, message: e.message }, e.statusCode);
  else
    return response({ message: e.message }, 500);
};

function AppException(code, icode, msg) {
  this.name = 'AppException';
  this.message = msg;
  this.code = icode;
  this.statusCode = code;
  console.log(this);
}

const getparams = (event, keys = []) => {
  var ps = {};
  if (event.body) {
    let body = JSON.parse(event.body);
    for (let i = 0; i < keys.length; i++) {
      let key = keys[i];
      let required = false;

      // string의 마지막 !는 필수를 의미한다
      if (key.slice(-1) == '!') {
        key = key.slice(0, -1);
        required = true;
      }

      if (key in body) ps[key] = body[key];
      else {
        if (required) throw new AppException(404, 1001, 'No parameter given');
        else ps[key] = null;
      }
    }
  } else throw new AppException(404, 1002, 'No data given');
  return ps;
}

const handler = async () => {
  try {
    var param = getparams({body: JSON.stringify({ mac: '00:00:00:00:00:12' })}, ['mac!', 'test']);
    // var param = getparams({}, ['mac!', 'test']);
    console.log(param);
    var resp = await pool_mariadb.querySync(FIND_STORE, [param.mac]);
    console.log('result: ', resp);
    console.log(response(resp));
  } catch (e) {
    console.log(error(e));
  }  
}

handler().then(() => {
  console.log('fine');  
});
return;