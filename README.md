# HelloButton v3

HelloButton mobile web using flutter

## last note
ref: flutter/samples/navigation_and_routing (github)


## versions to do

### v3.0.0
- 기존의 hello button과 동일한 spec으로 정리
- 기존 vue에서 server-side build 부분을 rest API로 추가해서 새로운 서버 (version: )와 연결
- 기존 hello-bell-v2 (gitlab)의 sql/hb/hb0001.sql, hb0002.sql을 추가 api로 구성
- hellobutton으로 넘어오는 url (http://hbtn.kr/hb/<secure string>)에서 secure string에 대한 crypto 부분을 flutter로 변경
- 각 button에 대한 image를 기존 url 그대로 사용 (files.hellobell.net/...)

### v3.1.0
- 각 button의 image url을 amazon url로 변경 (https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/...) 그리고 secure https로 변경
- http://hbtn.kr/hb/... url을 https로 load balancer를 사용하여 redirect
- 페이지의 background와 theme을 확장

### v3.2.0
- store의 menu를 hellobutton에서 보여줄 수 있도록 추가

### v3.5.0
- Hello order와 결합

### v3.6.0
- 새로운 형태의 order 방식 추가 (출력된 QR code를 이용하여 table #를 입력받아서 order 진행)
- C400에서의 호출과 동시에 static한 QR code (https://hbtn.kr/hs/<store key>)를 사용하여 console table과 연동하는 부분을 추가
- 출력된 QR code (store 정보를 가진것)로 부터 메뉴를 보여주고 order cart를 작성하여 버튼으로 스태프를 호출, 또는 직접 control tablet에 정보를 보내는 방법을 추가

## required

- remove /#/ query string: url_strategy
- change base href not root ('/') ref: ./web/index.html
  ```
  $ flutter build --base-href <directory>
  ```

## AWS S3 deploy
- error시 처리부분을 error.html이 아니라 index.html로 변경 해준다. 이렇게 하면 SPA 지원이 된다.

## Nginx deploy
- root, sub directory 모두 설치 가능
- nginx.config에 다음과 같이 추가
  ```
  ...
  location /<sub directory>/ {
    index  index.html index.thm;
    try_files $uri /<sub directory>/index.html;
  }
  ...
  ```