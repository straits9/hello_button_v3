import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();
  factory GlobalService() => _instance;

  static const config = {
    'local': {
      'graphqlAPI': 'http://localhost:3000/dev/v3/graphql',
      'wsAPI': 'ws://localhost:3001',
    },
    'dev': {
      'graphqlAPI': 'https://api4-dev.hfb.kr/v3/graphql',
      'wsAPI': 'wss://ws-dev.hfb.kr/',
    },
    'prod': {
      'graphqlAPI': 'https://api4.hfb.kr/v3/graphql',
      'wsAPI': 'wss://ws.hfb.kr/',
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
    String? wsurl = config[stage]?['wsAPI'];

    Link link = HttpLink(config[stage]!['graphqlAPI']!);
    link = token != null
        ? AuthLink(getToken: () => 'Bearer $token').concat(link)
        : link;
    link = wsurl != null
        ? link.concat(WebSocketLink(wsurl,
            config: SocketClientConfig(
                autoReconnect: true,
                inactivityTimeout: const Duration(seconds: 30),
                initialPayload: {
                  'headers': {'Authorization': token},
                })))
        : link;
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
