# Node Express Project Generator - NPEG

This script is a utility to quickly generate a Node.js project structure with Express and EJS. It includes options to customize the output using flags for including or excluding Docker and README files.

---

## Requirements

Ensure the script has the necessary permissions to execute. You can grant execution rights using the following command:

```bash
chmod +x generate_project.sh
```

## Usage

Run the script with the following syntax:

```
./generate_project.sh <project_name> [--no-docker] [--no-readme]
```

### Arguments

<project_name>: Name of the project directory to be created.
--no-docker: Excludes the generation of Docker-related files (Dockerfile and .dockerignore).
--no-readme: Excludes the generation of a README.md file inside the project directory.

## Example Commands
Generate a full project with Docker and README:

```
./generate_project.sh my_project
```

Generate a project without Docker files:

```
./generate_project.sh my_project --no-docker
```

Generate a project without README:

```
./generate_project.sh my_project --no-readme
```

Generate a minimal project without Docker and README:

```
./generate_project.sh my_project --no-docker --no-readme
```

Generated Project Structure

The script creates the following structure:

```
my_project/
├── app.js
├── package.json
├── public/
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── script.js
|   └── images/
├── routes/
│   └── routes.js
├── views/
│   ├── layout.ejs
│   ├── index.ejs
│   └── partials/
│       ├── header.ejs
│       ├── footer.ejs
├── Dockerfile (optional)
├── .dockerignore (optional)
└── README.md (optional)
```

## Notes

Pre-installed Dependencies: The package.json file includes:

- express: For handling HTTP requests and routing.
- ejs: For rendering views.
- express-ejs-layouts: For layout support in EJS.


### Auto-reloading Server: Use nodemon for a better development experience:
```
npm install -g nodemon
```
Docker Support: To build and run the project using Docker, ensure Docker is installed and running on your system.