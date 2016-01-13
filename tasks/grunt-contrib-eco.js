/*
 * grunt-contrib-eco
 */

module.exports = function (grunt) {
    'use strict';

    grunt.registerMultiTask('eco', 'Compile Eco templates into JavaScript files', function () {

        var options = this.options({
            umd: false, // RSDEV: Add UMD option
            separator: grunt.util.linefeed
        });

        grunt.verbose.writeflags(options, 'Options');

        this.files.forEach(function(f) {
            var output = f.src.filter(function(filepath) {
                // Warn on and remove invalid source files (if nonull was set).
                if (!grunt.file.exists(filepath)) {
                    grunt.log.warn('Source file "' + filepath.red + '" not found.');
                    return false;
                } else {
                    return true;
                }
            }).map(function(filepath) {
                var compiled = compileEco(filepath, options);
                // RSDEV: Add optional UMD support to compiled JavaScript
                if (options.umd) return wrapModule('module.exports = ' + compiled);
                else return compiled;
            }).join(grunt.util.normalizelf(options.separator));

            if (output.length < 1) {
                grunt.log.warn('Destination not written because compiled files were empty.');
            } else {
                grunt.file.write(f.dest, output);
            }
        });
    });

    // RSDEV: Helper to wrap Javascript code in a UMD block with define factory.
    function wrapModule(code) {
        return [
        "if (typeof exports === 'object' && typeof define !== 'function') {",
        "  define = function(factory) {",
        "    var ret = factory(require, exports, module);",
        "    if (ret != null) { module.exports = ret; }",
        "  };",
        "}",
        "define(function(require, exports, module) {", code, "});"
        ].join('\n');
    }

    function compileEco(filepath, options) {
        try {
            var source = grunt.file.read(filepath);
            return require('eco').precompile(source);
        } catch (e) {
            grunt.log.error(e);
            grunt.fail.warn('Eco template failed to compile.');
        }

    }
};
