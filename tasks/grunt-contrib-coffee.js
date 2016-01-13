/*
 * grunt-contrib-coffee
 * http://gruntjs.com/
 *
 * Copyright (c) 2012 Eric Woroshow, contributors
 * Licensed under the MIT license.
 */

module.exports = function(grunt) {
    'use strict';

    grunt.registerMultiTask('coffee', 'Compile CoffeeScript files into JavaScript', function() {

        var options = this.options({
            sourceMap: false, // RSDEV: Add Source Map option
            umd: false, // RSDEV: Add UMD option
            bare: false
        });

        grunt.verbose.writeflags(options, 'Options');

        this.files.forEach(function(f) {
            f.src.filter(function(filepath) {
                // Warn on and remove invalid source files (if nonull was set).
                if (!grunt.file.exists(filepath)) {
                    grunt.log.warn('Source file "' + filepath.red + '" not found.');
                    return false;
                } else {
                    return true;
                }
            }).forEach(function(filepath) {
                var output = compileCoffee(filepath, options);
                var js = (options.sourceMap) ? output.js : output;
                // RSDEV: Add optional UMD support to compiled CoffeeScript
                if (options.umd) {
                    js = wrapModule(js);
                }
                // RSDEV: Add SourceMap support to CoffeeScript compiler
                if (options.sourceMap) {
                    var sourceMapDest = f.dest + ".map";
                    js = js + "\n//@ sourceMappingURL=/" + sourceMapDest;
                    var sourceMap = output.v3SourceMap;
                    // RSDEV: Add UMD support to CoffeeScript SourceMaps
                    if (options.umd) {
                        sourceMap = JSON.stringify({
                            version: 3,
                            file: path.basename(f.dest),
                            sections: [
                                {
                                    offset: { line: 7, column: 0 },
                                    map: JSON.parse(sourceMap)
                                }
                            ]
                        });
                    }
                    grunt.file.write(sourceMapDest, sourceMap);
                }
                grunt.file.write(f.dest, js);
            });
        });
    });

    // RSDEV: Helper to wrap Javascript code in a UMD block with define factory.
    var wrapModule = function(code) {
        return [
        "if (typeof exports === 'object' && typeof define !== 'function') {",
        "  define = function(factory) {",
        "    var ret = factory(require, exports, module);",
        "    if (ret != null) { module.exports = ret; }",
        "  };",
        "}",
        "define(function(require, exports, module) {", code, "});"
        ].join('\n');
    };

    var path = require('path');
    var coffee = require('coffee-script');

    var compileCoffee = function(srcFile, options) {
        options = grunt.util._.extend({
            filename: srcFile,
            sourceFiles: [path.basename(srcFile)],
            literate: coffee.helpers.isLiterate(srcFile)
        }, options);

        var srcCode = grunt.file.read(srcFile);

        try {
            return coffee.compile(srcCode, options);
        } catch (e) {
            grunt.log.error(e);
            grunt.fail.warn('CoffeeScript failed to compile.');
        }
    };
};
