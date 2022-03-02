class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  factory GlobalService() => _instance;

  GlobalService._internal() {
    print('init global service');
  }

  String _version = '';
  String _build = '';

  String get version => _version;
  set version(String value) {
    _version = value;
    print('set version: $value');
  }

  String get build => _build;
  set build(String value) => _build = value;
}
