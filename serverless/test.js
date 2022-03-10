'use strict'

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
  console.log('ret: ', ps);
  return ps;
}

const resp = (obj) => {
  return {
    statusCode: 200,
    body: JSON.stringify(obj, null, 2)
  }
}

try {
  var param = getparams({body: JSON.stringify({ mac: '00:00:00:00:00:02' })}, ['mac!', 'test']);
  console.log(resp(param));
} catch (e) {
  console.log('error:', JSON.stringify(e));
}