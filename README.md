# HelloButton v3

HelloButton mobile web using flutter

## last note
ref: flutter/samples/navigation_and_routing (github)


## versions to do

### v3.0.0
- Flutter SPA로 web page 구성. 되도록 dependency가 없는 형태로 제작
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
  $ flutter build --base-href <directory> --web
  ```

## web request CORS 처리
- serverless lambda + API gateway의 경우, serverless 설정에서 cors: true로 만든다. (API gateway 설정)
- 추가로 lambda server code에서 response시 header에 'Access-Control-Allow-Origin': '*'를 추가해야한다.
- serverless에서 cors: true 하였기 때문에 (결국 이것은 api gateway의 cors enable이다) content-type이 json으로 실행해도 된다.

## adSense 추가
- 아직 테스트 하지 않음.
- pc@hellofactory.co.kr 계정으로 adsense 설정
- ref: [AdSense at Flutter Web application](https://stackoverflow.com/questions/57909791/is-it-possible-to-insert-google-adsense-at-flutter-web-application)
- ref: [AdMob support for Flutter web](https://stackoverflow.com/questions/67560795/is-there-admob-support-for-flutter-web)
- adMob은 app에 지원 flutter web은 adsense 연결

## Web page용 Deeplink 제작
- Getx와 같은 depencency를 사용하지 않고 만드는 방법
- url/#/과 같은 형태를 제거 (url_strategy plugin)
- 참고: [Understanding Flutter: deep links on the web](https://sellsbrothers.com/understanding-flutter-deep-links-on-the-web)
- 참고: [Let’s make the Flutter Navigator 2](https://medium.com/flutter-community/lets-make-the-flutter-navigator-2-bc5953251c3e)
- 참고: [Gallery web](https://github.com/aliyazdi75/gallery)

## AWS S3 deploy
- error시 처리부분을 error.html이 아니라 index.html로 변경 해준다. 이렇게 하면 SPA 지원이 된다.
- 참고: [S3 Static Sites
](https://gist.github.com/bradwestfall/b5b0e450015dbc9b4e56e5f398df48ff)
- 참고: [AWS를 이용해 SPA 호스팅하기](https://wormwlrm.github.io/2020/11/15/SPA-hosting-via-AWS.html)

## Nginx deploy
- mac brew 설치시 nginx 위치
  ```
  /usr/local/etc/nginx/nginx.conf
  ```
- root, sub directory 모두 설치 가능
  ```
  $ flutter build web --base-href
  ```
- nginx.config에 다음과 같이 추가
  ```
  ...
  location /<sub directory>/ {
    index  index.html index.thm;
    try_files $uri /<sub directory>/index.html;
  }
  ...
  ```

## Flutter web icon 설정
- refer: [How to configure icon for my flutter web application?](https://stackoverflow.com/questions/56745525/how-to-configure-icon-for-my-flutter-web-application)
