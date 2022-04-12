import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

//const url =
//    'https://vkmawdwa6h.execute-api.ap-northeast-2.amazonaws.com/dev/graphql/v3';
const url = 'http://localhost:3000/dev/graphql/v3';

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
}

class Queries {
  static const String site = """
    query site(\$siteid: ID!) {
      site(id: \$siteid) {
        id, name, desc, country, useButton
        buttons {
            title, image, order, active, actionId,
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
}
