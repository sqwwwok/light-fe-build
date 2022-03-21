const { build } = require('esbuild');
const { lessLoader } = require('esbuild-plugin-less');
const path = require('path')

build({
  entryPoints: [path.resolve(__dirname, 'src/index.tsx')],
  bundle: true,
  outdir: path.resolve(__dirname, 'public/dist'),
  plugins: [lessLoader()]
});
