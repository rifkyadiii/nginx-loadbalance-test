const express = require('express');
const os = require('os');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send(`Hello from ${os.hostname()}`);
});

app.get('/api/delay/:ms', (req, res) => {
    const delay = parseInt(req.params.ms);
    setTimeout(() => {
        res.json({ 
            message: `Response after ${delay}ms delay`,
            hostname: os.hostname(),
            time: new Date().toISOString()
        });
    }, delay);
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
