function AppException(code, icode, msg) {
  this.name = 'AppException';
  this.message = msg;
  this.code = icode;
  this.statusCode = code;
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
};

const response = (data, status = 200) => {
  if (typeof data == 'string')
    return {
      statusCode: status,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': true,
      },
      body: data,
    };

  return {
    statusCode: status,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': true,
    },
    body: JSON.stringify(data, null, 2),
  };
};

const error = (e) => {
  if (e.name && e.name == 'AppException')
    return response({ code: e.code, message: e.message }, e.statusCode);
  else
    return response({ message: e.message }, 500);
};

module.exports.getparams = getparams;
module.exports.response = response;
module.exports.error = error;