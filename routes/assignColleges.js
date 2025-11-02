// const express = require("express");
// const assignCollegesRouter = express.Router();
// const connection = require("../config/db");

// // /api/assign-colleges

// // get users their assigned subjects
// assignCollegesRouter.get("/:userId", (req, res) => {
//   const { userId } = req.params;

//   const query = `
//     SELECT c.college_id, c.college_name
//     FROM user_programs up
//     INNER JOIN colleges c
//     ON c.college_id = up.program_id
//     WHERE user_id = ?
//   `;

//   connection.query(query, [userId], (err, rows) => {
//     try {
//       if (err) throw err;

//       if (rows.length === 0) {
//         return res.status(200).json([]);
//       }

//       res.status(200).json(rows);
//     } catch (err) {
//       res.status(500).json({ message: `Error: ${err.sqlMessage}` });
//     }
//   });
// });

// // assign multiple colleges to a user
// assignCollegesRouter.post("/:user_id", (req, res) => {
//   const { program_ids } = req.body; // expects [1, 2, 3]
//   const { user_id } = req.params;

//   if (!Array.isArray(program_ids) || program_ids.length === 0) {
//     return res
//       .status(400)
//       .json({ message: "program_ids must be a non-empty array" });
//   }

//   // Create array of values for bulk insert
//   const values = program_ids.map((id) => [user_id, id]);

//   connection.query(
//     `INSERT IGNORE INTO user_programs (user_id, program_id) VALUES ?`,
//     [values],
//     (err, result) => {
//       if (err) {
//         return res
//           .status(500)
//           .json({ message: `Database error: ${err.sqlMessage}` });
//       }
//       res
//         .status(201)
//         .json({ message: "User assigned to multiple programs successfully" });
//     }
//   );
// });

// assignCollegesRouter.delete("/:user_id", (req, res) => {
//   const { user_id } = req.params;
//   connection.query(
//     `DELETE FROM user_programs WHERE user_id = ?`,
//     [user_id],
//     (err, result) => {
//       if (err)
//         return res
//           .status(500)
//           .json({ message: `An error has occurred: ${err.sqlMessage}` });
//       if (result.affectedRows === 0)
//         return res
//           .status(404)
//           .json({ message: `No assigned programs found for this user` });
//       res.status(200).json({
//         message: `All assigned programs for User Id: ${user_id} have been deleted`,
//       });
//     }
//   );
// });

// module.exports = assignCollegesRouter;

const express = require("express");
const assignCollegesRouter = express.Router();
const pool = require("../config/db"); // mysql2/promise pool

// /api/assign-colleges

// ✅ Get user assigned colleges
assignCollegesRouter.get("/:userId", async (req, res) => {
  const { userId } = req.params;

  const query = `
    SELECT c.college_id, c.college_name
    FROM user_programs up
    INNER JOIN colleges c
    ON c.college_id = up.program_id 
    WHERE user_id = ?
  `;

  try {
    const [rows] = await pool.query(query, [userId]);

    if (rows.length === 0) {
      return res.status(200).json([]);
    }

    return res.status(200).json(rows);
  } catch (err) {
    return res.status(500).json({ message: `Error: ${err.message}` });
  }
});

// ✅ Assign multiple colleges to a user
assignCollegesRouter.post("/:user_id", async (req, res) => {
  const { program_ids } = req.body; // expects [1, 2, 3]
  const { user_id } = req.params;

  if (!Array.isArray(program_ids) || program_ids.length === 0) {
    return res
      .status(400)
      .json({ message: "program_ids must be a non-empty array" });
  }

  const values = program_ids.map((id) => [user_id, id]);

  try {
    await pool.query(
      `INSERT IGNORE INTO user_programs (user_id, program_id) VALUES ?`,
      [values]
    );

    return res.status(201).json({
      message: "User assigned to multiple programs successfully",
    });
  } catch (err) {
    return res.status(500).json({
      message: `Database error: ${err.message}`,
    });
  }
});

// ✅ Remove all assigned colleges for a user
assignCollegesRouter.delete("/:user_id", async (req, res) => {
  const { user_id } = req.params;

  try {
    const [result] = await pool.query(
      `DELETE FROM user_programs WHERE user_id = ?`,
      [user_id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: `No assigned programs found for this user`,
      });
    }

    return res.status(200).json({
      message: `All assigned programs for User Id: ${user_id} have been deleted`,
    });
  } catch (err) {
    return res.status(500).json({
      message: `An error has occurred: ${err.message}`,
    });
  }
});

module.exports = assignCollegesRouter;
