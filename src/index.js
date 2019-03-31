const express = require('express')
const bunyan = require('bunyan');

const port = process.env.PORT || 3000
const logLevel = process.env.LOG_LEVEL || 'debug'


const log = bunyan.createLogger({
  name: "serverless-terraform",
  stream: process.stdout,
  level: logLevel
})

const app = express()


app.get('/', (req, res) => {
  log.info(`request received in route "/"`)
  res.send('Hello World!')
})

app.get('/version', (req, res) => res.json({
  version: "1.0.0"
}))

app.get('/health', (req, res) => res.sendStatus(200))




const isInLambda = !!process.env.LAMBDA_TASK_ROOT;
if (isInLambda) {
  const serverlessExpress = require('aws-serverless-express');
  const server = serverlessExpress.createServer(app);
  exports.main = (event, context) => serverlessExpress.proxy(server, event, context)
  log.info("Lambda function started")
} else {
  app.listen(port, () => log.info(`Example app listening on port ${port}`))
  exports = app
}
