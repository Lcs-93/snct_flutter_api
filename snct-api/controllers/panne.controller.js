const Panne = require("../models/panne.model");
const Tram = require("../models/tram.model");
exports.reportPanne = async (req, res) => {
  try {
    const panne = new Panne(req.body);
    panne.reportedAt = new Date();
    const saved = await panne.save();

    // ✅ Mise à jour du status du tram
    const tram = await Tram.findById(req.body.tramId);
    if (tram) {
      if (req.body.description.toLowerCase().includes('annulation')) {
        tram.status = 'Down';
      } else {
        tram.status = 'Delayed';
      }
      await tram.save();
    }

    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.getAllPannes = async (req, res) => {
  try {
    const pannes = await Panne.find().populate("tramId");
    res.json(pannes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.deletePanne = async (req, res) => {
  try {
    const deleted = await Panne.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: "Panne non trouvée" });
    res.json({ message: "Panne supprimée" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
