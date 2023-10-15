%%raw(`
const express = require('express');
const multer = require('multer');
const path = require('path');

const app = express();
const port = 80;
const staticPath = path.resolve(module.path, '..', '..', '..', '..', 'test-browser');
console.log(staticPath);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(multer().none());
app.use(express.static(staticPath));

app.get('/get', (req, res) => {
  res.json(req.query);
});

app.post('/post', (req, res) => {
  res.json(req.body);
});

app.listen(port, () => {
  console.log("Example app listening on port " + port);
});
`)
