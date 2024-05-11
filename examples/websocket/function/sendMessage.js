const { ApiGatewayManagementApiClient, PostToConnectionCommand } = require("@aws-sdk/client-apigatewaymanagementapi");
const { DynamoDBClient, } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, DeleteCommand, ScanCommand } = require("@aws-sdk/lib-dynamodb");

// DynamoDB clients
const ddbClient = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(ddbClient);

exports.handler = async (event) => {
  const scanCommand = new ScanCommand({
    ProjectionExpression: "connectionId",
    TableName: process.env.TABLE_NAME,
  });

  const scanData = await docClient.send(scanCommand);

  const domain = event.requestContext.domainName;
  const stage = event.requestContext.stage;
  const postData = JSON.parse(event.body).data;

  // API Gateway Management API client
  const apiClient = new ApiGatewayManagementApiClient({
    region: process.env.AWS_REGION,
    endpoint: `https://${domain}/${stage}`,
  });

  scanData.Items.map(async ({ connectionId }) => {
    try {
      const apiCommand = new PostToConnectionCommand({
        ConnectionId: connectionId,
        Data: postData,
      })
      const response = await apiClient.send(apiCommand);
      console.log(JSON.stringify(response));

    } catch (e) {
      if (e.name === 'GoneException') { return; }
      if (e.statusCode === 410) {
        console.log(`Found stale connection, deleting ${connectionId}`);
        const command = new DeleteCommand({
          TableName: process.env.TABLE_NAME,
          Key: { connectionId },
        });

        const response = await docClient.send(command);
        console.log(JSON.stringify(response));
      } else {
        throw e;
      }
    }
  });

  return { statusCode: 200, body: "Data sent." };
};
