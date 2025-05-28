const express = require("express");
const router = express.Router();

const {
  register,
  login,
  updateName
} = require("../controllers/user.controller");

const auth = require("../middlewares/auth.middleware"); // 🔧 Import manquant

// 🔐 Authentification
router.post("/register", register);
router.post("/login", login);

// 👤 Modification de l'utilisateur connecté
router.patch("/update-name", auth, updateName);

module.exports = router;
