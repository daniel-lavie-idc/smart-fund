import http from "./http-common";

async function postNewProject(projectTitle, projectDesc) {
    const data = {
        title: projectTitle,
        description: projectDesc,
    };
    const response = await http.post("/projects", data);
    console.log(response.data);
    return response.data._id;
};

export default postNewProject;