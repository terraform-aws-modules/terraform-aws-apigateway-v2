const { DynamoDBClient, } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");

// DynamoDB clients
const ddbClient = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(ddbClient);

exports.handler = async (event) => {
  const command = new PutCommand({
    TableName: process.env.TABLE_NAME,
    Item: {
      connectionId: event.requestContext.connectionId,
    },
  });

  try {
    const response = await docClient.send(command);
    console.log(JSON.stringify(response));
  } catch (err) {
    return {
      statusCode: 500,
      body: "Failed to connect: " + JSON.stringify(err),
    };
  }

  return { statusCode: 200, body: "Connected." };
};
