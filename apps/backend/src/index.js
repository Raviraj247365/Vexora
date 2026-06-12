const express = require('express');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'backend' });
});

app.get('/version', (req, res) => {
  res.json({ service: 'backend', version: process.env.npm_package_version || '0.1.0' });
});

app.listen(port, () => {
  console.log(`Vexora backend listening on http://localhost:${port}`);
});
