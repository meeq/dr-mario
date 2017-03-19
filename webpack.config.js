var path = require('path');

var webpack = require("webpack");
var CleanPlugin = require('clean-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var srcDir = path.resolve(__dirname, 'src');
var buildDir = path.resolve(__dirname, 'build');
var imagesDir = path.resolve(__dirname, 'images');
var compassLibDir = path.resolve(__dirname, 'node_modules/compass-mixins/lib');

var cleanPlugin = new CleanPlugin([buildDir]);

var htmlPlugin = new HtmlWebpackPlugin({
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

var styleLoader = [
  { loader: "style-loader" },
  { loader: "css-loader" },
  { loader: "sass-loader",
    options: {
      indentedSyntax: true,
      includePaths: [compassLibDir]
    }
  }
];

var soundLoader = "url-loader?limit=10240&name=sounds/[name].[ext]";

module.exports = {
    context: srcDir,
    entry: {
        main: "./main"
    },
    output: {
        path: buildDir,
        filename: "[name].js",
        chunkFilename: "[name].js"
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
        // cleanPlugin,
        htmlPlugin
    ]
};
