const express = require("express");
const router = express.Router();
const {
  reportPanne,
  getAllPannes,
  deletePanne
} = require("../controllers/panne.controller");

router.post("/", reportPanne);
router.get("/", getAllPannes);
router.delete("/:id", deletePanne);

module.exports = router;
