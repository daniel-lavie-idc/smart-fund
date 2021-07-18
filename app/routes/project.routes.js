module.exports = app => {
  const projects = require("../controllers/project.controller.js");

  var router = require("express").Router();

  // Create a new Project
  router.post("/", projects.create);

  // Retrieve a single project with id
  router.get("/:id", projects.findOne);

  app.use('/api/projects', router);
};
