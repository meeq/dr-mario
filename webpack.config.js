var path = require('path');

var webpack = require("webpack");
var CleanPlugin = require('clean-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var srcDir = path.resolve(__dirname, 'src');
var buildDir = path.resolve(__dirname, 'build');
var compassLibDir = path.resolve(__dirname, 'node_modules/compass-mixins/lib');

var cleanPlugin = new CleanPlugin([buildDir]);

var htmlPlugin = new HtmlWebpackPlugin({
    template: path.resolve(srcDir, 'templates/index.html'),
    inject: true
});

var styleLoader = ExtractTextPlugin.extract('style', 'css!sass');
var stylePlugin = new ExtractTextPlugin('style.css');

var soundLoader = "url?limit=10000&name=sounds/[name].[ext]";

module.exports = {
    context: srcDir,
    entry: {
        app: "./main"
    },
    output: {
        path: buildDir,
        filename: "[name].js",
        chunkFilename: "[name].js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee" },
            { test: /\.hamlc$/, loader: "hamlc" },
            { test: /\.sass$/, loader: styleLoader },
            { test: /\.png$/, loader: "url" },
            { test: /\.ttf$/, loader: "url" },
            { test: /\.mp3$/, loader: soundLoader }
        ]
    },
    resolve: {
        root: srcDir,
        extensions: ["", ".js", ".coffee", ".hamlc", ".sass"]
    },
    sassLoader: {
        indentedSyntax: true,
        includePaths: [compassLibDir]
    },
    plugins: [
        cleanPlugin,
        htmlPlugin,
        stylePlugin
    ]
};
