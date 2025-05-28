const express = require('express');
const cors = require('cors');

const tramRoutes = require('./routes/tram.route');
const ticketRoutes = require('./routes/ticket.route');
const userRoutes = require('./routes/user.route');
const panneRoutes = require('./routes/panne.route');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/trams', tramRoutes);
app.use('/api/tickets', ticketRoutes);
app.use('/api/users', userRoutes);
app.use('/api/pannes', panneRoutes);

module.exports = app;
