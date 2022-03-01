var crypto = require('crypto');

var iv = 'hEl0loF1aCt3oRy3';
var key = 'Z9HF6BED46L1D3O3C3DEBE8U26T74FNY';

function enc(text) {
    let cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
    let crypted = cipher.update(text, 'utf8', 'hex');

    crypted += cipher.final('hex');
    console.log('crypted:', crypted);
    return crypted;
}

function dec(text) {
    let decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
    decipher.setAutoPadding(false);

    let decrypted = decipher.update(text, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    console.log('decrypted: ', decrypted);
    decrypted = decrypted.replace(/\4/g, '');
    decrypted = decrypted.replace(/\0/g, '');
    console.log('after replace: ', decrypted);
    return decrypted;
}


var iat = Date.now();
var mac = 'E2:5A:F4:49:F4:19';
console.log('base: "' + iat + ' ' + mac + '"');

var e = enc(iat + ' ' + mac);
var d = dec(e);

