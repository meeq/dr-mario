var path = require('path');

var webpack = require("webpack");
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var srcDir = path.resolve(__dirname, 'src');
var buildDir = path.resolve(__dirname, 'build');
var compassLibDir = path.resolve(__dirname, 'node_modules/compass-mixins/lib');

var htmlPlugin = new HtmlWebpackPlugin({
    template: path.resolve(srcDir, 'templates/index.html'),
    inject: true
});

var styleLoader = ExtractTextPlugin.extract('style', 'css!sass');
var stylePlugin = new ExtractTextPlugin('style.css');

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
            { test: /\.(png|ttf)$/, loader: "url" },
            { test: /\.mp3$/, loader: "file?name=sounds/[name].[ext]" }
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
        htmlPlugin,
        stylePlugin
    ]
};
