const db = require("../models");
const Project = db.projects;

exports.create = (req, res) => {
    // Validate request
    console.log("Got a create project request");
    if (!req.body.title) {
      res.status(400).send({ message: "Content can not be empty!" });
      return;
    }
  
    // Create a Project
    const project = new Project({
      title: req.body.title,
      description: req.body.description,
    });
  
    // Save Project in the database
    project
      .save(project)
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Tutorial."
        });
      });
  };
  
exports.findOne = (req, res) => {
  console.log("Got a find by id project request");
  const id = req.params.id;

  Project.findById(id)
    .then(data => {
      if (!data)
        res.status(404).send({ message: "Not found Project with id " + id });
      else res.send(data);
    })
    .catch(err => {
      res
        .status(500)
        .send({ message: "Error retrieving Project with id=" + id });
    });
};