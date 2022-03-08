'use strict';

var mysql = require('mysql')
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

module.exports.buttons = async event => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event,
      },
      null,
      2
    ),
  };

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
