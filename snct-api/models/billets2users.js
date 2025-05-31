const mongoose = require("mongoose");

const billets2userSchema = new mongoose.Schema({
  idUser: { type: String, required: true },
  idTrams: { type: String, required: true, unique: true },
});

module.exports = mongoose.model("Billets2Users", billets2userSchema);
