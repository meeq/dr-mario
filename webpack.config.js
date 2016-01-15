var path = require('path');

module.exports = {
    context: __dirname + "/src",
    entry: "./main",
    output: {
        path: __dirname + '/static',
        publicPath: "/static/",
        filename: "dr-puzzle.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee" },
            { test: /\.hamlc$/, loader: "hamlc" },
            { test: /\.sass$/, loaders: ["style", "css", "sass"] }
        ]
    },
    resolve: {
        root: path.resolve("./src"),
        extensions: ["", ".js", ".coffee", ".hamlc", ".sass"]
    },
    sassLoader: {
        indentedSyntax: true,
        includePaths: [path.resolve("./node_modules/compass-mixins/lib")]
    }
};
