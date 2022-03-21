if [ ! -d $1 ]; then
	mkdir $1
else
	echo "$1 already exists."
	exit 1;
fi

cd $1

echo "Initialize project..."
if command -v git &> /dev/null
then
  git init
else
  echo "git not found."
fi

if command -v npm &> /dev/null
then
  npm init -y >&- 2>&-
else
  echo "npm not found."
  exit 1;
fi
echo "Done."


echo "Install development dependencies..."
npm i esbuild esbuild-plugin-less prettier nodemon -D
echo "Done."


echo "Install production dependencies..."
npm i react react-dom -S
echo "Done."


echo "Create directories..."
mkdir public
mkdir src
echo "Done."


echo "Initialize project configurations..."
cat > tsconfig.json <<- _EOF_ 
{
  "compilerOptions": {
    "jsx": "react",
    "module": "ES6",
    "declaration": true,
    "noImplicitAny": false,
    "removeComments": true,
    "target": "es6",
    "sourceMap": true,
    "allowJs": true,
    "outDir": "public/js",
    "lib": ["es7", "DOM"],
    "moduleResolution": "node",
    "typeRoots": ["./node_modules/@types/", "./src/@types"],
    "allowSyntheticDefaultImports": true
  },
  "include": [
    "src/**/*"
  ]
}
_EOF_

cat > nodemon.json <<- _EOF_
{
  "ignore": ["public/*"],
  "watch": ["src/*"],
  "ext": "ts,tsx,css,less,jsx,js"
}
_EOF_

cat > .prettierrc <<- _EOF_
{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true
}
_EOF_

cat > .gitignore <<- _EOF_
node_modules
public/dist
_EOF_

cat > build.js <<- _EOF_
const { build } = require('esbuild');
const { lessLoader } = require('esbuild-plugin-less');
const path = require('path')

build({
  entryPoints: [path.resolve(__dirname, 'src/index.tsx')],
  bundle: true,
  outdir: path.resolve(__dirname, 'public/dist'),
  plugins: [lessLoader()]
});
_EOF_
echo "Done."


echo "Set npm scripts..."
npm set-script build "node build.js"
npm set-script dev "nodemon --exec npm run build"
npm set-script beautify "prettier --write src/**/*"
npm set-script serve "npx serve public"
echo "Done."


echo "Create example code..."
cat > public/index.html <<- _EOF_
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="/dist/index.css">
  <title>Document</title>
</head>
<body>
  <div id="root"></div>
  <script src="/dist/index.js"></script>
</body>
</html>
_EOF_

cat > src/index.tsx <<- _EOF_
import React from 'react'
import ReactDOM from 'react-dom'

import './index.less'

const App = () => {
  return (
    <div className="main">
      Hello, world !
    </div>
  )
}

ReactDOM.render(<App />, document.getElementById('root'))
_EOF_

cat > src/index.less <<- _EOF_
.main {
  margin: auto;
  color: #666;
  margin-top: 30px;
  width: 80%;
  font-size: 32px;
  font-family: 'Times New Roman', Times, serif;
}
_EOF_

cat > readme.md <<- _EOF_
# Project
Use React, Less, and Typescript to build your project, with the help of esbuild.

## NPM Scripts
### Build in time
\`\`\`sh
npm run dev
\`\`\`

### Start development server
\`\`\`sh
npm run serve
\`\`\`

### Beautify code
\`\`\`sh
npm run beautify
\`\`\`
_EOF_
echo "Done."


echo "Next step: cd $1; npm run dev; npm run serve"
echo "Enjoy hacking!"
