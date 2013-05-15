wintersmith-jsbundler
=====================

[Wintersmith](https://github.com/jnordberg/wintersmith) plugin that follows
require calls in javascript and coffeescript files and bundles them.

Uses [commonjs-everywhere](https://github.com/michaelficarra/commonjs-everywhere)
and [escodegen](https://github.com/Constellation/escodegen).

## Installing

Install globally or locally using npm

```
npm install [-g] wintersmith-jsbundler
```

and add `wintersmith-jsbundler` to your config.json

```json
{
  "plugins": [
    "wintersmith-jsbundler"
  ]
}
```

## Config

Configured by a `jsbundler` key in your wintersmith config.

Available options are

 * `sourceMap` - inline source map for bundled files, defaults to true in preview mode; otherwise false.
 * `minify` - minify output (sourcemaps still work), defaults to true in build mode; otherwise false.

Example config:


```json
{
  "plugins": [
    "wintersmith-jsbundler"
  ]
  "jsbundler": {
    "sourceMap": true,
    "minify": true
  }
}
```

## Running tests

```
npm install
npm test
```
