module.exports = {
    context: __dirname + "/src/dr-puzzle",
    entry: "./main",
    output: {
        path: __dirname + '/static',
        publicPath: "/static/",
        filename: "dr-puzzle.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" },
            { test: /\.hamlc$/, loader: "hamlc-loader" }
        ]
    },
    resolve: {
        extensions: [".js", ".coffee", ".hamlc"]
    }
};
