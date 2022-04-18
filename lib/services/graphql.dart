import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

//const url =
//    'https://vkmawdwa6h.execute-api.ap-northeast-2.amazonaws.com/dev/graphql/v3';
const url = 'http://localhost:3000/dev/graphql/v3';
//const url = 'http://192.168.0.19:3000/dev/graphql/v3';

class GraphqlConfig {
  static final HttpLink _httpLink = HttpLink(url);

  //
  // for Graphql Auth
  //
  // static final AuthLink _authLink = AuthLink(
  //   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  // );
  // static final Link link = _authLink.concat(_httpLink);
  static final Link _link = _httpLink;

  static ValueNotifier<GraphQLClient> initClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: _link,
        cache: GraphQLCache(),
      ),
    );
    return client;
  }

  static handleError(Exception exception) {
    if (exception is TimeoutException) {
      return exception.message;
    } else if (exception is OperationException) {
      print(exception.linkException is ServerException);
      if (exception.linkException is ServerException) {
        ServerException sexception = exception.linkException as ServerException;
        print('server exception');
        print(sexception.parsedResponse?.errors?[0].message);
        return sexception.parsedResponse?.errors?[0].extensions?['code'];
      } else {
        if (exception.graphqlErrors[0].message.contains('error_code')) {
          print('first error');
        }
        return exception.graphqlErrors[0].message;
      }
    }
    return 'error unclassified';
  }
}

class Queries {
  static const String site = """
    query site(\$siteid: ID!) {
      site(id: \$siteid) {
        id, name, desc, country, useButton
        buttons(order: ASC) {
            id, title, image, order, active, actionId,
            action {
                __typename
                ... on Call {
                    message
                    eventId
                }
                ... on CallMessage {
                    message
                    userinput {
                        __typename
                        ... on UserInput {
                            title
                            text
                        }
                        ... on Selection {
                            title
                            text
                            items
                        }
                    }
                }
                ... on Group {
                    groupId
                    message
                    userinput {
                        __typename
                        ... on UserInput {
                            title
                            text
                        }
                        ... on Selection {
                            title
                            text
                            items
                        }
                    }
                }
                ... on Link {
                    url
                }
            }
        }
      }
    }
  """;

  static const String mac = """
    query mac(\$mac: MAC!) {
        deviceByMac(mac: \$mac) {
            id, sn, siteId
            site {
                id, name, desc, country, tz, locale, category, active, useButton
                backgroundId, background, theme, logoId, logo
                createdAt, updatedAt
                buttons(order: ASC) {
                    id, title, image, order, active, actionId, desc
                    action {
                        __typename
                        ... on Call {
                            message
                            eventId
                        }
                        ... on CallMessage {
                            message
                            userinput {
                                __typename
                                ... on UserInput {
                                    title
                                    text
                                }
                                ... on Selection {
                                    title
                                    text
                                    items
                                }
                            }
                        }
                        ... on Group {
                            groupId
                            message
                            userinput {
                                __typename
                                ... on UserInput {
                                    title
                                    text
                                }
                                ... on Selection {
                                    title
                                    text
                                    items
                                }
                            }
                        }
                        ... on Link {
                            url
                        }
                    }
                }
            }
        }
    }
  """;
}
