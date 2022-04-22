import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {

  static handleError(Exception exception) {
    print(exception);
    if (exception is TimeoutException) {
      return exception.message;
    } else if (exception is OperationException) {
      print(exception.linkException is ServerException);
      if (exception.linkException is ServerException) {
        ServerException sexception = exception.linkException as ServerException;
        print('server exception $sexception');
        if (sexception.parsedResponse == null) {
          return sexception.originalException.toString();
        }
        print(sexception.parsedResponse?.errors?[0].extensions?['code']);
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
                backgroundId, background, theme, logoId, logo, validWithin
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
