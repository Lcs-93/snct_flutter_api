const express = require("express");
const router = express.Router();

const {
  register,
  login,
  updateName,
  deleteAccount, // ✅ Ajout de la fonction de suppression
} = require("../controllers/user.controller");

const auth = require("../middlewares/auth.middleware"); // 🔐 Authentification

// 🔐 Authentification
router.post("/register", register);
router.post("/login", login);

// 👤 Gestion de l'utilisateur connecté
router.patch("/update-name", auth, updateName);
router.delete("/delete", auth, deleteAccount); // ✅ Route pour supprimer son compte

module.exports = router;
