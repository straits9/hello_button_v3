'use strict';

var mysql = require('mysql');
var async = require('async');
var fs = require('fs');

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

/**
 * SQL File 실행
 *
 * @param file
 * @param param
 * @param cb
 */
// pool_mariadb.queryFile_old = function (file, param, cb) {
// 	var me = this;

// 	fs.readFile(__dirname+'/'+file, 'utf8', function(err, data) {
// 		if (err) {
// 			// 파일 읽기 실패
//       console.log('Error at readFile: ' + JSON.stringify(err));
// 			cb(err, null, null);
// 		} else {
// 			let strSQL = data;
// 			me.query(strSQL, param, function(err, rows, field) {
// 				cb(err, rows[1], field);
// 			});
// 		}
// 	});
// };

pool_mariadb.queryFile = (file, ...params) => {
  return new Promise((resolve, reject) => {
    let strSQL;

    try {
      strSQL = fs.readFileSync(__dirname + '/' + file, 'utf8');
    } catch (e) {
      reject(e);
      return;
    }
    this.query(strSQL, params, (err, res) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(res);
    })
  });
}

// query return like below:
//[
//{
//    "fieldCount": 0,
//    "affectedRows": 0,
//    "insertId": 0,
//    "serverStatus": 10,
//    "warningCount": 0,
//    "message": "",
//    "protocol41": true,
//    "changedRows": 0
//}
//,[
//{
//    "store_no": 35,
//    "name": "Restaurant Demo",
//    "serial": "V100-00-00019",
//    "section_no": 1,
//    "table_no": 1
//}
//]]


//module.exports.handler = async event => {
//  return {
//    statusCode: 200,
//    body: JSON.stringify(
//      {
//        message: 'Go Serverless v1.0! Your function executed successfully!',
//        input: event,
//      },
//      null,
//      2
//    ),
//  };

//  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
//  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
//};

function AppException(code, icode, msg) {
  this.message = msg;
  this.code = icode;
  this.statusCode = code;
}

const getparams = (event, keys = []) => {
  var ps = {};
  try {
    if (event.body) {
      let body = JSON.parse(event.body);
      for (let i = 0; i < keys.length; i++) {
        let key = keys[i];
        let required = false;

        // string의 마지막 !는 필수를 의미한다
        if (key.slice(-1) == '!') {
          key = key.slice(0, -1);
          required = true;
        };

        if (key in body) ps[key] = body[key];
        else {
          if (required) throw new AppException(404, 1001, 'No parameter given');
          else ps[key] = null;
        }
      }
    } else throw new AppException(404, 1002, 'No data given');
  } catch (e) {
    throw new AppException(500, 500, e.message);
  }
  return ps;
}

const resp = (obj) => {
  return {
    statusCode: 200,
    body: JSON.stringify(obj, null, 2)
  }
}



module.exports.echo = async event => {
  return resp({
    message: 'Go Serverless v1.0! Your function executed successfully!',
    input: event,
  });
}

module.exports.getButtons = async (event, context) => {
  try {
    var param = getparams(event, ['mac!']);
  } catch (e) {
    return 
  }
  var mac;

  if (event.body) {
    let body = JSON.parse(event.body);
    if (body.mac) {
      mac = body.mac;
    } else {
      callback(JSON.stringify({
        errorType: "Not Found",
        httpStatus: 404,
        requestId: context.awsRequestId
      }));
    }
  } else {
      callback(JSON.stringify({
        errorType: "Not Found",
        httpStatus: 404,
        requestId: context.awsRequestId
      }));
  }

  async.waterfall([
    function (cb) {
      pool_mariadb.queryFile('sql/hbv2001.sql', ['00:00:00:00:00:12'], function (err, rows, fields) {
        if (!err) {
          console.log(JSON.stringify(rows));
          cb(null, rows);
        } else {
          console.log('Error while performing Query.', err);
          cb(500);
        }
      });
    }],

    function (err, result) {
      if (!err) {
        if (result.length > 0) {
          var res = [];

          try {
            result.forEach(function (value, index) {
              var temp = {};
              temp.name = value.name;
              temp.store_no = value.store_no;
              temp.section = value.section_no;
              temp.table = value.table_no;
              res.push(temp);
            });
          } catch (e) {
            if (e !== BreakException) throw e;
          }
          console.log('res: ', res);
          context.succeed(res);
        } else {
          context.succeed('');
        }
      } else {
        if (err == 400) {
          context.fail('Bad Request: You submitted invalid input');
        } else {
          context.fail('Internal Error: Internal Error');
        }
      }
    }
  );
};