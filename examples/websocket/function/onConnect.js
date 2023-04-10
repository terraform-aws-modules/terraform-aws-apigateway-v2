import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";

const ddb = new DynamoDBClient({ region: process.env.AWS_REGION });

exports.handler = async (event) => {
  console.log(JSON.stringify(event));

  const params = {
    TableName: process.env.TABLE_NAME,
    Item: {
      connectionId: event.requestContext.connectionId,
    },
  };

  try {
    await ddb.send(new PutItemCommand(params));
  } catch (err) {
    return {
      statusCode: 500,
      body: "Failed to connect: " + JSON.stringify(err),
    };
  }

  return { statusCode: 200, body: "Connected." };
};
