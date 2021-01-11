# A working example of a Debian-based Docker image running in Lambda

## Build
To build the example Docker image, run the following command the project root:
```bash
docker build -t debianlambdaexample .
```


## Test Locally
Prerequisites:
- complete the `Build` step

To test the image locally, you can run the following commands:
```bash
docker run -p 9000:8080 debianlambdaexample
```

With the Docker image running, run the following command in a separate terminal:
```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

In the first terminal window, where the Docker container is running, you should see output similar to what is below. Notice the `INFO    hello world`. That is what we logged in app.js. It's working!
```
2021-01-11T03:30:34.705Z        undefined       INFO       Executing 'app.handler' in function directory '/var/task'
2021-01-11T03:30:34.716Z        077256b4-0ee5-4ba5-9854-ced7f6e893ad       INFO    hello world
END RequestId: 077256b4-0ee5-4ba5-9854-ced7f6e893ad
REPORT RequestId: 077256b4-0ee5-4ba5-9854-ced7f6e893ad     Init Duration: 0.31 ms  Duration: 73.16 msBilled Duration: 100 ms  Memory Size: 3008 MB    Max Memory Used: 3008 MB
```


## Deploy to Lambda
I recommend using CDK to deploy to Lambda. It's pretty easy. Maybe I'll drop in an example of deploying it through CDK.
