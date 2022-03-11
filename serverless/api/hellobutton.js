'use strict';

// TODO: DB connection caching할것
// TODO: query file operation을 const string으로 변경할것

const db = require('../modules/db');
const lambda = require('../modules/lambda');


module.exports.echo = async event => {
  return lambda.response({
    message: 'Go Serverless v1.0! Your function executed successfully!',
    input: event,
  });
}

module.exports.getButtons = async (event, context) => {
  try {
    var param = lambda.getparams(event, ['mac!']);
    var resp = await db.pool.querySync(FIND_STORE, [param.mac]);
    return lambda.response(resp);
  } catch (e) {
    return lambda.error(e);
  }
};