const Tram = require("../models/tram.model");

exports.getAllTrams = async (req, res) => {
  try {
    const trams = await Tram.find();
    res.json(trams);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getTramById = async (req, res) => {
  try {
    const tram = await Tram.findById(req.params.id);
    if (!tram) return res.status(404).json({ message: "Tram not found" });
    res.json(tram);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.createTram = async (req, res) => {
  try {
    const newTram = new Tram(req.body);
    const savedTram = await newTram.save();
    res.status(201).json(savedTram);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.updateTram = async (req, res) => {
  try {
    const updated = await Tram.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: "Tram not found" });
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.deleteTram = async (req, res) => {
  try {
    const deleted = await Tram.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: "Tram not found" });
    res.json({ message: "Tram supprimé" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
