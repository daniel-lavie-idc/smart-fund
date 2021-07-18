module.exports = mongoose => {
  const Project = mongoose.model(
    "project",
    mongoose.Schema(
      {
        title: String,
        description: String
      },
      { timestamps: true }
    )
  );

  return Project;
};