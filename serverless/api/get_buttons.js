'use strict';

var mysql = require('mysql')
var async = require('async')
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
pool_mariadb.queryFile = function (file, param, cb) {
	var me = this;

	fs.readFile(__dirname+'/'+file, 'utf8', function(err, data) {
		if (err) {
			// 파일 읽기 실패
      console.log('Error at readFile: ' + JSON.stringify(err));
			cb(err, null, null);
		} else {
			let strSQL = data;
			me.query(strSQL, param, function(err, rows, field) {
				cb(err, rows[1], field);
			});
		}
	});
};

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

module.exports.handler = function (event, context, callback) {
  async.waterfall([
    function(cb) {
      pool_mariadb.queryFile('sql/hbv2001.sql', ['00:00:00:00:00:12'], function(err, rows, fields) {
        if (!err) {
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
            result.forEach(function(value, index) {
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
          context.succeed(res);
        } else {
          context.succeed('');
        }
      } else {
        if (err == 400) {
          context.fail('Bad Request: YOu submitted invalid input');
        } else {
          context.fail('Internal Error: Internal Error');
        }
      }
    }
  );
}