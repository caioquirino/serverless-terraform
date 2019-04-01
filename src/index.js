const express = require('express')
const bunyan = require('bunyan')
const UserRepo = require('./userRepo')
const env = process.env.ENVIRONMENT || "dev"
const region = process.env.AWS_REGION || "us-east-1"

const logLevel = process.env.LOG_LEVEL || 'debug'
const log = bunyan.createLogger({
  name: "serverless-terraform",
  stream: process.stdout,
  level: logLevel
})

const AWS = require("aws-sdk");
AWS.config.update({
  region
});
const documentClient = new AWS.DynamoDB.DocumentClient();

const userRepo = new UserRepo(log, documentClient, `${env}_users`);

log.info("Application starting...")

const app = express()


app.get('/', (req, res) => {
  log.info(`request received in route "/"`)
  res.send('Hello World!')
})

app.get('/version', (req, res) => res.json({
  version: "1.0.0",
  region: region,
  environment: env
}))

app.get('/users', async (req, res) => res.json(await userRepo.listAllUsers()))

app.get('/users/1', (req, res) => res.json({
  name: "Caio Quirino",
  email: "example@test.com",
}))

app.get('/health', (req, res) => res.sendStatus(200))

const isInLambda = !!process.env.LAMBDA_TASK_ROOT;
if (isInLambda) {
  const serverlessExpress = require('aws-serverless-express');
  const server = serverlessExpress.createServer(app);
  exports.main = (event, context) => serverlessExpress.proxy(server, event, context)
  log.info("Lambda function started")
} else {
  const port = process.env.PORT || 3000
  app.listen(port, () => log.info(`Example app listening on port ${port}`))
  exports = app
}
