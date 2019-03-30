const express = require('express')
const app = express()
const port = process.env.PORT || 3000

app.get('/', (req, res) => res.send('Hello World!'))

app.get('/version', (req, res) => res.json({
  version: "1.0.0"
}))

app.get('/health', (req, res) => res.sendStatus(200))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
