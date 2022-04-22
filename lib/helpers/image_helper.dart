// 이전 version과 compatibility를 유지하기 위해서 S3 bucket <files.hellobell.net>에
// vue /images directory를 옮겨놓고 이를 secure한 uri로 변경한다.
const Map<String, String> prefixes = {
  'http://v2.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3',
  'http://files.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net',
  'https://bo.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3'
};

class ImageHelper {
  static String urlFix(String uri) {
    var matches = prefixes.keys
        .firstWhere((key) => uri.startsWith(key), orElse: () => '');

    if (matches != '') {
      var modified = uri.replaceFirst(matches, prefixes[matches]!);
      //print('conv url: $uri => $modified');
      return modified;
    }
    return uri;
  }
}
