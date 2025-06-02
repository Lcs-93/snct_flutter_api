const mongoose = require("mongoose");

const billetSchema = new mongoose.Schema({
  idUser: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User' },
  idTrams: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'Tram' },
  nomUser: String,
  tramName: String,
  from: String,
  to: String,
  schedule: String,
});

module.exports = mongoose.model("Billet2User", billetSchema);
