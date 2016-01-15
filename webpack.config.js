var path = require('path');

var webpack = require("webpack");
var HtmlWebpackPlugin = require('html-webpack-plugin');

var srcDir = path.resolve(__dirname, 'src');
var buildDir = path.resolve(__dirname, 'build');
var compassLibDir = path.resolve(__dirname, 'node_modules/compass-mixins/lib');

var htmlPlugin = new HtmlWebpackPlugin({
    title: 'Dr. Puzzle'
});

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
            { test: /\.sass$/, loaders: ["style", "css", "sass"] },
            { test: /\.(png|ttf|mp3)$/, loader: "url" }
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
        htmlPlugin
    ]
};
