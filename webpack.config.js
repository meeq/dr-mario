const path = require("path");

const webpack = require("webpack");
const CleanPlugin = require("clean-webpack-plugin");
const HtmlPlugin = require("html-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const srcDir = path.resolve(__dirname, 'src');
const buildDir = path.resolve(__dirname, 'build');
const imagesDir = path.resolve(__dirname, 'images');
const compassLibDir = path.resolve(__dirname, 'node_modules/compass-mixins/lib');

var cleanPlugin = new CleanPlugin([buildDir]);

var htmlPlugin = new HtmlPlugin({
    title: 'Dr. Mario',
    favicon: path.join(imagesDir, 'favicon.ico'),
    viewport: 'width=device-width, initial-scale=1.0, user-scalable=no',
    template: path.join(srcDir, "templates/index.hamlc"),
    inject: true,
    minify: {
        removeComments: true,
        collapseWhitespace: true,
        useShortDoctype: true
    }
});

var stylePlugin = new ExtractTextPlugin({
  filename: "[name].[contenthash].css",
  disable: process.env.NODE_ENV === "development"
});

var styleLoader = stylePlugin.extract({
  use: [
    { loader: "css-loader" },
    { loader: "sass-loader",
      options: {
        indentedSyntax: true,
        includePaths: [compassLibDir]
      }
    }
  ],
  fallback: "style-loader"
});

var soundLoader = "url-loader?limit=10240&name=sounds/[name].[ext]";

module.exports = {
    context: srcDir,
    entry: {
        main: "./main"
    },
    output: {
        path: buildDir,
        filename: "[name].[hash].js",
        chunkFilename: "[name].[hash].js"
    },
    module: {
        rules: [
            { test: /\.coffee$/, use: "coffee-loader" },
            { test: /\.hamlc$/, use: "hamlc-loader" },
            { test: /\.sass$/, use: styleLoader },
            { test: /\.png$/, use: "url-loader" },
            { test: /\.ttf$/, use: "url-loader" },
            { test: /\.mp3$/, use: soundLoader }
        ]
    },
    resolve: {
        extensions: [".js", ".coffee", ".hamlc", ".sass"]
    },
    plugins: [
        cleanPlugin,
        stylePlugin,
        htmlPlugin
    ]
};
