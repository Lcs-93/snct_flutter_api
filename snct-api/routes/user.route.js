const express = require("express");
const router = express.Router();

const {register, login, updateName, deleteAccount, saveQrcode, getBilletsByUser } = require("../controllers/user.controller");

const auth = require("../middlewares/auth.middleware");

router.post("/register", register);
router.post("/login", login);
router.post("/save-qrcode", saveQrcode);
router.get("/billets/:idUser", getBilletsByUser);

router.patch("/update-name", auth, updateName);
router.delete("/delete", auth, deleteAccount);

module.exports = router;
