const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send('Welcome to UMeGrow Happy NewYear');
});
app.listen(8000, () => {
  console.log('Listening on port 8000');
});
