const Ticket = require("../models/ticket.model");

exports.createTicket = async (req, res) => {
  try {
    const ticket = new Ticket(req.body);
    const saved = await ticket.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.getTicketsByUser = async (req, res) => {
  try {
    const tickets = await Ticket.find({ userId: req.params.userId }).populate("tramId");
    res.json(tickets);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
