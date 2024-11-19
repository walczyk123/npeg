#!/bin/bash

# Check if the project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name> [--no-docker] [--no-readme]"
    exit 1
fi

PROJECT_NAME=$1
NO_DOCKER=false
NO_README=false

# Parse flags
for arg in "$@"; do
    case $arg in
        --no-docker)
        NO_DOCKER=true
        shift
        ;;
        --no-readme)
        NO_README=true
        shift
        ;;
    esac
done

echo "Generating project structure for: $PROJECT_NAME"
mkdir -p $PROJECT_NAME/{public/{css,js,images},routes,views/partials}

echo "Generating styles..."
cat <<EOF > $PROJECT_NAME/public/css/style.css
/* Default styles for the project */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f9f9f9;
}
EOF

echo "Generating scripts..."
cat <<EOF > $PROJECT_NAME/public/js/script.js
document.addEventListener('DOMContentLoaded', () => {
  console.log("Welcome to $PROJECT_NAME!");
});
EOF

echo "Generating routes..."
cat <<EOF > $PROJECT_NAME/routes/routes.js
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.render('index', {
        title: 'Home Page',
        description: 'Welcome to the main page of the project!'
    });
});

router.get("/about", (req, res) => {
    res.render("about", { 
        title: "About Us",
        description: "About Us page." 
    });
});

module.exports = router;
EOF

echo "Generating views..."
cat <<EOF > $PROJECT_NAME/views/layout.ejs
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%- include('partials/header') %>
    <main>
        <%- body %>
    </main>
    <script src="js/script.js"></script>
</body>
</html>
EOF

cat <<EOF > $PROJECT_NAME/views/index.ejs
<h1><%= title %></h1>
<p><%= description %></p>
EOF

echo "Generating partials..."
cat <<EOF > $PROJECT_NAME/views/partials/header.ejs
<header>
    <nav>
        <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/about">About</a></li>
        </ul>
    </nav>
</header>
EOF

echo "Generating app.js..."
cat <<EOF > $PROJECT_NAME/app.js
const express = require("express");
const path = require("path");
const app = express();
const routes = require("./routes/routes");

// Configure views engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Configure routes
app.use("/", routes);

// Error handling
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(\`Server is running at http://localhost:\${PORT}\`);
});
EOF

echo "Generating package.json..."
cat <<EOF > $PROJECT_NAME/package.json
{
    "name": "$PROJECT_NAME",
    "version": "1.0.0",
    "description": "Node.js project with Express and EJS",
    "main": "app.js",
    "scripts": {
        "start": "node app.js"
    },
    "dependencies": {
        "express": "^4.18.2",
        "ejs": "^3.1.9"
    }
}
EOF

if [ "$NO_DOCKER" = false ]; then
    echo "Generating Docker files..."
    cat <<EOF > $PROJECT_NAME/Dockerfile
FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
EOF

    cat <<EOF > $PROJECT_NAME/.dockerignore
node_modules
npm-debug.log
EOF
fi

if [ "$NO_README" = false ]; then
    echo "Generating README file..."
    cat <<EOF > $PROJECT_NAME/README.md
## Requirements

\`\`\`
npm
npm install express ejs express-ejs-layouts
\`\`\`
Auto-reloading server
\`\`\`
npm install -g nodemon
\`\`\`

---

## Run

\`\`\`
nodemon app.js
\`\`\`
or
\`\`\`
node app.js
\`\`\`

---

## Docker build
\`\`\`
sudo docker build -t mwmedia .
\`\`\`

---

## Docker run locally
\`\`\`
sudo docker run -p 3000:3000 mwmedia
\`\`\`

## Docker run on VPS
\`\`\`
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
\`\`\`

Run container
\`\`\`
docker run -d -p 80:3000 mwmedia
\`\`\`
EOF
fi

echo "Project structure created successfully!"
