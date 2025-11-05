// const express = require("express");
// const roomRouter = express.Router();
// const connection = require("../config/db");

// // Common HTTP status codes:
// // 200 - OK
// // 201 - Created
// // 404 - Not Found
// // 500 - Internal Server Error

// // ROUTE BASE: /api/rooms

// // GET all rooms
// roomRouter.get("/", (req, res) => {
//   connection.query("SELECT * FROM rooms", (err, rows) => {
//     if (err)
//       return res
//         .status(500)
//         .json({ message: `An error has occurred: ${err.sqlMessage}` });

//     res.status(200).json(rows);
//   });
// });

// // GET the teacher's assigned rooms
// roomRouter.get("/teacher/:teacherId", (req, res) => {
//   const { teacherId } = req.params;

//   console.log(teacherId);

//   const sql =
//     teacherId != 0
//       ? `
//     SELECT tr.room_id, r.room_name
//     FROM teacher_assigned_room tr
//     INNER JOIN rooms r
//     ON tr.room_id = r.room_id
//     WHERE tr.teacher_id = ?
//   `
//       : `
//     SELECT room_id, room_name
//     FROM rooms
//     `;

//   connection.query(sql, [teacherId], (err, rows) => {
//     if (err)
//       return res
//         .status(500)
//         .json({ message: `An error has occurred: ${err.sqlMessage}` });

//     if (rows.length === 0)
//       return res.status(404).json({ message: "No rooms for this teacher" });

//     res.status(200).json(rows);
//   });
// });

// // GET room by ID
// roomRouter.get("/:id", (req, res) => {
//   const { id } = req.params;
//   connection.query(
//     "SELECT * FROM rooms WHERE room_id = ?",
//     [id],
//     (err, rows) => {
//       if (err)
//         return res
//           .status(500)
//           .json({ message: `An error has occurred: ${err.sqlMessage}` });

//       if (rows.length === 0)
//         return res.status(404).json({ message: "Room not found" });

//       res.status(200).json(rows[0]);
//     }
//   );
// });

// // CREATE new room
// roomRouter.post("/", (req, res) => {
//   const { room_name, capacity, room_type } = req.body;

//   if (!room_name || !capacity || !room_type)
//     return res.status(400).json({ message: "All fields are required" });

//   connection.query(
//     "INSERT INTO rooms (room_name, capacity, room_type) VALUES (?, ?, ?)",
//     [room_name, capacity, room_type],
//     (err, result) => {
//       if (err)
//         return res
//           .status(500)
//           .json({ message: `An error has occurred: ${err.sqlMessage}` });

//       res.status(201).json({
//         message: "Room created successfully",
//         room_id: result.insertId,
//       });
//     }
//   );
// });

// // UPDATE room by ID
// roomRouter.put("/:id", (req, res) => {
//   const { id } = req.params;
//   const { room_name, capacity, room_type } = req.body;

//   connection.query(
//     "UPDATE rooms SET room_name = ?, capacity = ?, room_type = ? WHERE room_id = ?",
//     [room_name, capacity, room_type, id],
//     (err, result) => {
//       if (err)
//         return res
//           .status(500)
//           .json({ message: `An error has occurred: ${err.sqlMessage}` });

//       if (result.affectedRows === 0)
//         return res.status(404).json({ message: "Room not found" });

//       res.status(200).json({ message: "Room updated successfully" });
//     }
//   );
// });

// // DELETE room by ID
// roomRouter.delete("/:id", (req, res) => {
//   const { id } = req.params;
//   connection.query(
//     "DELETE FROM rooms WHERE room_id = ?",
//     [id],
//     (err, result) => {
//       if (err)
//         return res
//           .status(500)
//           .json({ message: `An error has occurred: ${err.sqlMessage}` });

//       if (result.affectedRows === 0)
//         return res.status(404).json({ message: "Room not found" });

//       res.status(200).json({ message: "Room deleted successfully" });
//     }
//   );
// });

// module.exports = roomRouter;

const express = require("express");
const roomRouter = express.Router();
const pool = require("../config/db"); // mysql2/promise pool

// ROUTE BASE: /api/rooms

// GET all rooms
roomRouter.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM rooms");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

// GET the teacher's assigned rooms
roomRouter.get("/teacher/:teacherId", async (req, res) => {
  try {
    const { teacherId } = req.params;

    const sql =
      teacherId != 0
        ? `
          SELECT tr.room_id, r.room_name
          FROM teacher_assigned_room tr
          INNER JOIN rooms r ON tr.room_id = r.room_id
          WHERE tr.teacher_id = ?
        `
        : `SELECT room_id, room_name FROM rooms`;

    const params = teacherId != 0 ? [teacherId] : [];

    const [rows] = await pool.query(sql, params);

    if (rows.length === 0)
      return res.status(404).json({ message: "No rooms for this teacher" });

    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

// GET room by ID
roomRouter.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query("SELECT * FROM rooms WHERE room_id = ?", [
      id,
    ]);

    if (rows.length === 0)
      return res.status(404).json({ message: "Room not found" });

    res.status(200).json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

// CREATE new room
roomRouter.post("/", async (req, res) => {
  try {
    const { room_name } = req.body;

    if (!room_name) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const [result] = await pool.query(
      "INSERT INTO rooms (room_name) VALUES (?)",
      [room_name]
    );

    res.status(201).json({
      message: "Room created successfully",
      room_id: result.insertId,
    });
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

// UPDATE room by ID
roomRouter.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { room_name } = req.body;

    const [result] = await pool.query(
      "UPDATE rooms SET room_name = ? WHERE room_id = ?",
      [room_name, id]
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Room not found" });

    res.status(200).json({ message: "Room updated successfully" });
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

// DELETE room by ID
roomRouter.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await pool.query("DELETE FROM rooms WHERE room_id = ?", [
      id,
    ]);

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Room not found" });

    res.status(200).json({ message: "Room deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: `An error has occurred: ${err.message}` });
  }
});

module.exports = roomRouter;
