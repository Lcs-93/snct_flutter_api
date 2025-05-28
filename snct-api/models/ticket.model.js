const mongoose = require("mongoose");

const ticketSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  tramId: { type: mongoose.Schema.Types.ObjectId, ref: "Tram", required: true },
  departureDate: { type: Date, required: true },
  qrData: { type: String, required: true }
});

module.exports = mongoose.model("Ticket", ticketSchema);
