var path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    context: __dirname + "/src",
    entry: "./main",
    output: {
        path: __dirname + '/build',
        filename: "dr-puzzle.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee" },
            { test: /\.hamlc$/, loader: "hamlc" },
            { test: /\.sass$/, loaders: ["style", "css", "sass"] },
            { test: /\.png$/, loader: "url" },
            { test: /\.ttf$/, loader: "url" }
        ]
    },
    resolve: {
        root: path.resolve("./src"),
        extensions: ["", ".js", ".coffee", ".hamlc", ".sass"]
    },
    sassLoader: {
        indentedSyntax: true,
        includePaths: [path.resolve("./node_modules/compass-mixins/lib")]
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: 'Dr. Puzzle'
        })
    ]
};
