const express = require('express')
const app = express()
const port = process.env.PORT || 3000

app.get('/', (req, res) => res.send('Hello World!'))

app.get('/version', (req, res) => res.json({
  version: "1.0.0"
}))

app.get('/health', (req, res) => res.sendStatus(200))




const isInLambda = !!process.env.LAMBDA_TASK_ROOT;
if (isInLambda) {
  const serverlessExpress = require('aws-serverless-express');
  const server = serverlessExpress.createServer(app);
  exports.main = (event, context) => serverlessExpress.proxy(server, event, context)
} else {
  app.listen(port, () => console.log(`Example app listening on port ${port}!`))
  exports = app
}

