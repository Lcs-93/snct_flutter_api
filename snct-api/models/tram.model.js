const mongoose = require("mongoose");

const scheduleSchema = new mongoose.Schema({
  departureTime: String,
  arrivalTime: String
});

const tramSchema = new mongoose.Schema({
  name: { type: String, required: true },
  from: { type: String, required: true },
  to: { type: String, required: true },
  schedule: [scheduleSchema],
  status: { type: String, enum: ["OK", "Delayed", "Down"], default: "OK" }
});

module.exports = mongoose.model("Tram", tramSchema);
