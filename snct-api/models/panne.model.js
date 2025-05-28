const mongoose = require("mongoose");

const panneSchema = new mongoose.Schema({
  tramId: { type: mongoose.Schema.Types.ObjectId, ref: "Tram", required: true },
  description: { type: String, required: true },
  reportedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Panne", panneSchema);
