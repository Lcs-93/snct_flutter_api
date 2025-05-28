const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const {
  getAllTrams, getTramById, createTram, updateTram, deleteTram
} = require("../controllers/tram.controller");

router.get("/", getAllTrams); // public
router.get("/:id", getTramById);
router.post("/", auth, createTram);
router.patch("/:id", auth, updateTram);
router.delete("/:id", auth, deleteTram);

module.exports = router;
