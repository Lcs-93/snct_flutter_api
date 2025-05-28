const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const { createTicket, getTicketsByUser } = require("../controllers/ticket.controller");

router.post("/", auth, createTicket);
router.get("/user/:userId", auth, getTicketsByUser);

module.exports = router;