const User = require("../models/user.model");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const billets2users = require("../models/billets2users");
const Tram = require("../models/tram.model");

exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const hash = await bcrypt.hash(password, 10);
    const user = new User({ name, email, password: hash });
    const saved = await user.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user) return res.status(404).json({ message: "Utilisateur introuvable" });

  const match = await bcrypt.compare(password, user.password);
  if (!match) return res.status(401).json({ message: "Mot de passe incorrect" });

  const token = jwt.sign(
    { id: user._id, email: user.email, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "1d" }
  );

  res.json({ message: "Connexion réussie", token, user });
};

exports.updateName = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: "Nom requis" });

    await User.findByIdAndUpdate(userId, { name });
    const updatedUser = await User.findById(userId).select("-password");

    res.json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: "Erreur serveur" });
  }
};

exports.deleteAccount = async (req, res) => {
  try {
    const userId = req.user.id;
    await User.findByIdAndDelete(userId);
    res.json({ message: "Compte supprimé avec succès" });
  } catch (err) {
    res.status(500).json({ error: "Erreur lors de la suppression" });
  }
};

exports.saveQrcode = async (req, res) => {
  const { idUser, idTrams, schedule } = req.body;

  try {
    const tram = await Tram.findById(idTrams);

    if (!tram) return res.status(404).json({ erreur: "Tram introuvable" });

    const billet = await billets2users.create({
      idUser,
      idTrams,
      tramName: tram.name,
      from: tram.from,
      to: tram.to,
      schedule: schedule,
    });

    res.status(201).json({ message: 'Billet enregistré', billet });
  } catch (err) {
    console.error(err);
    res.status(500).json({ erreur: err.message });
  }
};

exports.getBilletsByUser = async (req, res) => {
  try {
    const { id } = req.params;
    const billets = await billets2users.find({ idUser: id });

    const enrichedBillets = await Promise.all(
      billets.map(async (billet) => {
        const tram = await Tram.findById(billet.idTrams);
        return {
          idUser: billet.idUser,
          idTrams: billet.idTrams,
          schedule: billet.schedule,
          tram: tram
            ? {
                name: tram.name,
                from: tram.from,
                to: tram.to,
                schedule: tram.schedule
              }
            : null
        };
      })
    );

    res.json(enrichedBillets);
  } catch (err) {
    console.error(err);
    res.status(500).json({ erreur: err.message });
  }
};

exports.deleteBillet = async (req, res) => {
  try {
    const { idUser, idTrams } = req.body;

    const result = await billets2users.findOneAndDelete({ idUser, idTrams });

    if (!result) {
      return res.status(404).json({ message: "Billet non trouvé" });
    }

    res.status(200).json({ message: "Billet annulé avec succès" });
  } catch (err) {
    console.error("Erreur lors de l'annulation :", err);
    res.status(500).json({ error: "Erreur serveur" });
  }
};
