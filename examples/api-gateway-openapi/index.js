exports.lambdaHandler = async (myEvent) => {
  console.log(myEvent);

  return Promise.resolve({
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(
      {
        message: 'hello world',
      },
      null,
      2,
    ),
  });
};
