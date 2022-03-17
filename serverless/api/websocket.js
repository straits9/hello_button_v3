'use strict'

const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();
const CONNECTION_DB_TABLE = process.env.WSCONN_DB;

const successfulResponse = {
  statusCode: 200,
  body: 'success'
};
const failedResponse = (code, error) => ({
  statusCode : code,
  body: error
});

module.exports.connect = (event, context, callback) => {
  addConnection(event.requestContext.connectionId)
    .then(() => {
      callback(null, successfulResponse);
      // return successfulResponse;
    })
    .catch((err) => {
      callback(failedResponse(500, JSON.stringify(err)));
    });
};

module.exports.disconnect = (event, context, callback) => {
  deleteConnection(event.requestContext.connectionId)
    .then(() => {
      callback(null, successfulResponse);
      // return successfulResponse;
    })
    .catch((err) => {
      console.log(err);
      callback(failedResponse(500, JSON.stringify(err)));
    });
};

module.exports.broadcast = async (event, context, callback) => {
  sendMessageToAllConnected(event)
    .then(() => {
      callback(null, successfulResponse);
    })
    .catch((err) => {
      callback(failedResponse(500, JSON.stringify(err)));
    })
}

const addConnection = (connectionId) => {
  console.log(`connect try to ${CONNECTION_DB_TABLE} id: ${connectionId}`);
  const params = {
    TableName: CONNECTION_DB_TABLE,
    Item: {
      connectionId: connectionId
    }
  }
  return dynamo.put(params).promise()
}

const deleteConnection = (connectionId) => {
  const params = {
    TableName: CONNECTION_DB_TABLE,
    Key: {
      connectionId: connectionId
    }
  }
  return dynamo.delete(params).promise()
}

const getAllConnections = () => {
  const params = {
    TableName: CONNECTION_DB_TABLE,
    ProjectionExpression: 'connectionId'
  }

  return dynamo.scan(params).promise();
}

const send = (event, connectionId) => {
  const body = JSON.parse(event.body);
  let postData = body.data;
  console.log('Sending...');

  if (typeof postData == 'object') {
    postData = JSON.stringify(postData);
    console.log('make json stringify:', postData);
  } else if (typeof postData == 'string') {
    console.log('it\'s a string: ', postData);
  }

  const endpoint = event.requestContext.domainName + '/' + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion: '2018-11-29',
    endpoint: endpoint
  });

  const params = {
    ConnectionId: connectionId,
    Data: postData
  };

  return apigwManagementApi.postToConnection(params).promise();
}

const sendMessageToAllConnected = (event) => {
  return getAllConnections()
    .then((connectionData) => {
      return connectionData.Items.map((connectionId) => {
        return send(event, connectionId.connectionId);
      });
    });
};