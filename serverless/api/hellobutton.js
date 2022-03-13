'use strict';

// TODO: DB connection caching할것

const db = require('../modules/db');
const lambda = require('../modules/lambda');
const FIND_STORE = '\
SELECT b.store_no, s.name, s.use_hellobutton_yn, b.serial, b.no AS bell_no, getBeaconSection(b.minor) AS section_no, sec.name AS section_name, getBeaconTable(b.minor) AS table_no, \
       env.theme, env.noti_p_msg, env.noti_c_msg, env.url_chg_period, eapp.app_no, eapp.api_key, eapp.reg_dt \
  FROM tbbell b \
    LEFT OUTER JOIN tbstore s ON b.store_no = s.no \
    LEFT OUTER JOIN tbhb env ON b.store_no = env.store_no AND env.del_yn = "N" \
    LEFT OUTER JOIN tbsection sec ON b.store_no = sec.store_no AND getBeaconSection(b.minor) = sec.section \
    LEFT OUTER JOIN tbextapp eapp ON eapp.store_no = b.store_no AND eapp.name = "hellobutton" AND eapp.del_yn = "N" \
 WHERE mac = ? LIMIT 1;';
const GET_STORE = '\
SELECT s.no AS store_no, s.name, s.use_hellobutton_yn, \
       env.theme, env.noti_p_msg, env.noti_c_msg, env.url_chg_period, eapp.app_no, eapp.api_key, eapp.reg_dt \
  FROM tbstore s \
    LEFT OUTER JOIN tbhb env ON s.no = env.store_no AND env.del_yn = "N" \
    LEFT OUTER JOIN tbextapp eapp ON eapp.store_no = s.no AND eapp.name = "hellobutton" AND eapp.del_yn = "N" \
 WHERE no = 35 LIMIT 1;';
const GET_BUTTONS = '\
SELECT b.no, b.name, b.image, b.desc_img, b.division, b.tx, b.message, b.group_no, b.url, \
       b.type, b.title, b.text, b.items, b.flow_rule, b.prompt_type, b.prompt_length, b.el, \
       b.disposable, b.noti_p_type, b.noti_c_type, b.noti_p_msg, b.noti_c_msg, b.sel_desc, \
       a.and_host, a.and_scheme, a.and_package, a.and_store, a.ios_appname, a.ios_scheme \
  FROM tbhb_bell b\
	       LEFT OUTER JOIN tbhb_app a ON b.app_no = a.no\
 WHERE b.store_no = ?\
   AND b.use_yn = "Y"\
   AND b.del_yn = "N"\
 ORDER BY b.order_no;';


module.exports.echo = async event => {
  return lambda.response({
    message: 'Go Serverless v1.0! Your function executed successfully!',
    input: event,
  });
};

module.exports.getButtonsByMac = async (event, context) => {
  try {
    let param = lambda.getparams(event, ['mac!']);
    let resp = {};

    //
    // mac address로 store 정보를 찾는다.
    //
    let store = await db.pool.querySync(FIND_STORE, [param.mac]);
    // result가 존재하는지 check
    if (!(store && store.length)) return lambda.response({ code: 2001, message: 'Not use Hello Button' });
    store = store[0];
    // hellobutton을 사용하는 store인지 check
    if (store.use_hellobutton_yn != 'Y' || store.api_key == null)
      return lambda.response({ code: 2002, message: 'Not use Hello Button' });
    resp['store'] = store;

    //
    // button을 사용하는 store인 경우, button 정보를 가져온다
    //
    let buttons = await db.pool.querySync(GET_BUTTONS, [store.store_no]);
    resp['buttons'] = buttons;
    return lambda.response(resp);
  } catch (e) {
    console.log(JSON.stringify(e));
    return lambda.error(e);
  }
};

module.exports.getButtonsByStore = async (event, context) => {
  try {
    let param = lambda.getparams(event, ['store!']);
    let resp = {};

    //
    // store ID로 store 정보를 찾는다.
    //
    let store = await db.pool.querySync(GET_STORE, [param.store]);
    // result가 존재하는지 check
    if (!(store && store.length)) return lambda.response({ code: 2001, message: 'Not use Hello Button' });
    store = store[0];
    // hellobutton을 사용하는 store인지 check
    if (store.use_hellobutton_yn != 'Y' || store.api_key == null)
      return lambda.response({ code: 2002, message: 'Not use Hello Button' });
    resp['store'] = store;

    //
    // button을 사용하는 store인 경우, button 정보를 가져온다
    //
    let buttons = await db.pool.querySync(GET_BUTTONS, [store.store_no]);
    resp['buttons'] = buttons;
    return lambda.response(resp);
  } catch (e) {
    console.log(JSON.stringify(e));
    return lambda.error(e);
  }
};