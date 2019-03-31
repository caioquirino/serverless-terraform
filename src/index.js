const express = require('express')
const bunyan = require('bunyan');

const logLevel = process.env.LOG_LEVEL || 'debug'


const log = bunyan.createLogger({
  name: "serverless-terraform",
  stream: process.stdout,
  level: logLevel
})

log.info("Application starting...")

const app = express()


app.get('/', (req, res) => {
  log.info(`request received in route "/"`)
  res.send('Hello World!')
})

app.get('/version', (req, res) => res.json({
  version: "1.0.0"
}))

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
