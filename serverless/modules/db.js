'use strict'

const mysql = require('mysql');
const fs = require('fs');


const pool_mariadb = mysql.createPool({
	host				: process.env.DB_HOST,
	port				: 3306,
	user				: 'hellobell',
	password			: 'gntlr?znzl',
	database			: process.env.DB_NAME,
	connectionLimit		: 100,
	//connectTimeout      : 60 * 60 * 1000,
	//aquireTimeout       : 60 * 60 * 1000,
	//timeout             : 60 * 60 * 1000,
	waitForConnections	: true,
	multipleStatements	: true
});


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


pool_mariadb.querySync = function (sql, ...params) {
  return new Promise((resolve, reject) => {
    this.query(sql, params, (err, res) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(res);
    });
  });
};

module.exports.pool = pool_mariadb;