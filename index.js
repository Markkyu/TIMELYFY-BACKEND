const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

// Import custom middlewares
const loggerFunction = require("./middleware/logger");
const { verifyRole } = require("./middleware/authMiddleware");
const { loginLimiter, apiLimiter } = require("./middleware/apiLimiter");

// Import routes
const meRouter = require("./routes/meRoute");
const loginRouter = require("./routes/login");
const registerRouter = require("./routes/register");
const collegesRouter = require("./routes/colleges");
const assignCollegeRouters = require("./routes/assignColleges");
const courseRouter = require("./routes/courses");
const teacherRouter = require("./routes/teachers");
const teacherDepartmentRouter = require("./routes/teachersDepartment");
const scheduleRouter = require("./routes/schedules");
const phaseRouter = require("./routes/phase");
const userRouter = require("./routes/users");
const roomRouter = require("./routes/rooms");
const changePasswordRouter = require("./routes/changePassword");

// Default route
app.get("/", (req, res) => {
  res.json({ message: "Hello from Timelyfy" });
});

// Login and user routes
app.use("/api/me", apiLimiter, loggerFunction, meRouter);
app.use("/api/login", loginLimiter, loggerFunction, loginRouter);
app.use("/api/change-password", changePasswordRouter);
app.use("/api/register", loggerFunction, registerRouter); // Admin only

// All routes
app.use("/api/colleges", loggerFunction, collegesRouter);
app.use("/api/assign-colleges", loggerFunction, assignCollegeRouters); // Master Scheduler or Admin only
app.use("/api/courses", loggerFunction, courseRouter); // everyone
app.use("/api/teachers", loggerFunction, teacherRouter); // everyone
app.use("/api/teachers/department", loggerFunction, teacherDepartmentRouter);
app.use("/api/schedules", loggerFunction, scheduleRouter); // everyone
app.use("/api/phase", loggerFunction, phaseRouter); // Master Scheduler and Admin only
app.use("/api/users", loggerFunction, userRouter); // Admin only
app.use("/api/rooms", loggerFunction, roomRouter); // everyone

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
