import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();
  factory GlobalService() => _instance;

  static const config = {
    'local': {
      'graphqlAPI': 'http://localhost:3000/dev/v3/graphql',
    },
    'dev': {
      'graphqlAPI': 'https://api4-dev.hfb.kr/v3/graphql',
    },
    'prod': {
      'graphqlAPI': 'https://api4.hfb.kr/v3/graphql',
    },
  };

  GlobalService._internal() {
    print('init global service');
  }

  String version = '';
  String build = '';
  String stage = 'prod';
  ValueNotifier<GraphQLClient>? client;

  ValueNotifier<GraphQLClient> initGraphQL() {
    String? token = config[stage]?['token'];
    client ??= ValueNotifier(
      GraphQLClient(
        link: token != null
            ? AuthLink(getToken: () => 'Bearer $token')
                .concat(HttpLink(config[stage]!['graphqlAPI']!))
            : HttpLink(config[stage]!['graphqlAPI']!),
        cache: GraphQLCache(),
      ),
    );
    return client!;
  }

  @override
  String toString() => 'version: $version, build: $build, stage: $stage';
}
