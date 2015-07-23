module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            /** changes to the source files trigger a karma retest
             */
            sourceChanged: {
                files: ['jsapp/kobo/**/*.js', 'jsapp/kobo/**/*.coffee', 'jsapp/kobo/**/*.html',
                        'jsapp/xlform_model_view/*.coffee', 'jsapp/xlform_model_view/*.js'],
                options: { livereload: 35730 },
            },

            htmlChanged: {
                options: { livereload: 35730 },
                files: ['dkobo/koboform/templates/jasmine_spec.html'],
            },

            /** changes to the tests trigger a karma retest
             */
            // testsChanged: {
            //     files: [
            //         // do we want to jump to all coffee tests?
            //         'jsapp/test/**/*.js',
            //         'jsapp/test/**/*.coffee'
            //     ],
            //     tasks: ['karma:unit'],
            // },

            /** dkobo_xlform.js is build with and AMD packaging module
             *    and is referenced by python and browser.
             *
             *  Changes in the source directory should rebuild the file, which ends up
             *    eventually triggering 'sourceChanged' as well.
             */
            retestXlform: {
                files: ['jsapp/test/xlform/*.coffee'],
                options: { livereload: 35730 },
            },

            rebuildDkoboXlform: {
                files: ['jsapp/xlform_model_view/**/*.js', 'jsapp/xlform_model_view/**/*.coffee'],
                tasks: ['requirejs:compile_xlform'],
            },

            /** One of the scss files changed, which triggers a rebuild
             *  of the generated css files.
             */
            scssChanged: {
                files: ['jsapp/kobo/stylesheets/**/*.scss'],
                tasks: ['build_css'],
                options: { livereload: false },
            },

            // cssChanged: {
                // files: ['jsapp/kobo.compiled/*.css', '!jsapp/**/*.verbose.css'],
                // tasks: [],
                // options: { livereload: 35730 },
            // },
            livereload: {
              options: { livereload: 35730 },
              files: ['jsapp/kobo.compiled/*.css', '!jsapp/**/*.verbose.css'],
            },

            /** Changes to HTML template files updates po files, and 
             *  changes to po files must compile the mo files.
             *  This uses django-admin makemessages command.
             */
            htmlTemplatesChanged: {
                //options: { livereload: 35730 },
                files: ['dkobo/koboform/templates/**/*.html'],
                tasks: ['exec:makemessages_templates'],
            },
            htmlTemplatesPoChanged: {
                //options: { livereload: 35730 },
                files: ['dkobo/koboform/locale/**/*.po'],
                tasks: ['exec:compilemessages_templates'],
            },
            /** Same as above for jsapp's compiled coffeescripts' language files,
             *  This also uses `django-admin makemessages` command.
             */
            compiledXLFormChanged: {
                //options: { livereload: 35730 },
                files: ['jsapp/kobo.compiled/dkobo_xlform.js'],
                tasks: ['exec:makemessages_xlformjs'],
            },
            compiledXLFormPoChanged: {
                //options: { livereload: 35730 },
                files: ['jsapp/locale/**/LC_MESSAGES/*.po', '!jsapp/locale/angular-gettext/*'],
                tasks: ['exec:compilemessages_xlformjs'],
            },
            /** Extract strings from kobo/templates html templates.
             *  This uses the grunt task associated with angular-gettext to extract .pot files,
             *  then the user has to update .po files from the generated .pot file (we could mimick
             *  `django-admin makemessages` to make this step automatic but we didn't),
             *  then an angular-gettext grunt task again to compile them into `translations.js`.
             */
            JsAppAngularAppChanged: {
                //options: { livereload: 35730 },
                files: [
                    'jsapp/kobo/templates/**/*.html', 
                    'jsapp/kobo/controllers/**/*.js',
                    'jsapp/kobo/directives/**/*.js',
                    'jsapp/kobo/services/**/*.js'
                ],
                tasks: ['nggettext_extract:jsapp_angular_gettext_pot'],
            },
            JSAppAngularGetTextPoChanged: {
                //options: { livereload: 35730 },
                files: ['jsapp/locale/angular-gettext/*.po'], //Non-recursive
                tasks: ['nggettext_compile:all'],
            }
        },
        karma: {
            unit: {
                configFile: 'jsapp/test/configs/karma.conf.js',
                singleRun: true,
                browsers: ['PhantomJS'],
            },
            amd: {
                /** It would be better to prevent the second karma server from
                 *  starting altogether, instead of just changing the port,
                 *  but that seems unattainable with multiple configuration files.
                 */
                port: 9877,
                configFile: 'jsapp/test/configs/karma-amd.conf.js',
                singleRun: true,
                browsers: ['PhantomJS'],
            },
        },

        requirejs: {
            compile_xlform: {
                options: {
                    baseUrl: 'jsapp',
                    // uglify-minimization/optimization--
                    optimize: 'none',
                    stubModules: ['cs'],
                    wrap: true,
                    exclude: ['coffee-script'],
                    name: 'almond',
                    include: 'build_configs/dkobo_xlform',
                    out: 'jsapp/kobo.compiled/dkobo_xlform.js',
                    paths: {
                        'almond': 'components/almond/almond',
                        'jquery': 'components/jquery/dist/jquery.min',
                        'cs' :'components/require-cs/cs',
                        // stubbed paths for almond build
                        'backbone': 'build_stubs/backbone',
                        'underscore': 'build_stubs/underscore',
                        'jquery': 'build_stubs/jquery',
                        'backbone-validation': 'components/backbone-validation/dist/backbone-validation-amd',
                        // 'backbone': 'components/backbone/backbone',
                        // 'underscore': 'components/underscore/underscore',
                        'coffee-script': 'components/require-cs/coffee-script',
                        // project paths
                        'xlform': 'xlform_model_view',
                    },
                },
            },
        },

        sass: {
            dist: {
                options: {
                    style: 'compact',
                },
                files: {
                    // scss does not get rid of duplicate rules and the style_modules has lots
                    // of duplicates so we must use cssmin afterwards.
                    'jsapp/kobo.compiled/kobo.verbose.css' : 'jsapp/kobo/kobo.scss',
                },
            },
        },
        cssmin: {
            strip_duplicates: {
                options: {
                    banner: "/* compiled from 'kobo/kobo.scss' and 'kobo/stylesheets' */",
                    keepBreaks: true,
                },
                files: {
                    'jsapp/kobo.compiled/kobo.css': ['jsapp/kobo.compiled/kobo.verbose.css'],
                },
            },
            dist: {
                options: {
                    banner: "/* kobo.css minified. scss source available on github: https://github.com/kobotoolbox/dkobo/ */",
                    report: ['min', 'gzip'],
                },
                files: {
                    'jsapp/kobo.compiled/kobo.min.css': ['jsapp/kobo.compiled/kobo.css'],
                },
            },
        },
        modernizr: {

            dist: {
                // [REQUIRED] Path to the build you're using for development.
                "devFile" : "jsapp/components/modernizr/modernizr.js",
                // [REQUIRED] Path to save out the built file.
                "outputFile" : "jsapp/kobo.compiled/modernizr.js",
                // Based on default settings on http://modernizr.com/download/
                "extra" : {
                    "shiv" : true,
                    "printshiv" : false,
                    "load" : true,
                    "mq" : false,
                    "cssclasses" : true
                },
                "extensibility" : {
                    "addtest" : false,
                    "prefixed" : false,
                    "teststyles" : false,
                    "testprops" : false,
                    "testallprops" : false,
                    "hasevents" : false,
                    "prefixes" : false,
                    "domprefixes" : false
                },
                "uglify" : true,
                // Define any tests you want to implicitly include.
                "tests" : [
                   "touch"
               ],
                "files" : {
                    "src": ["jsapp", "!jsapp/components"]
                },
            }

        },
        exec: {
            makemessages_templates: {
                cwd: "./dkobo/koboform",
                command: "django-admin.py makemessages -a",
                stdout: true,
                stderr: true
            },
            compilemessages_templates: {
                cwd: "./dkobo/koboform",
                command: "django-admin.py compilemessages",
                stdout: true,
                stderr: true
            },
            makemessages_xlformjs: {
                cwd: "./jsapp",
                command: "django-admin.py makemessages -a -d djangojs",
                stdout: true,
                stderr: true
            },
            compilemessages_xlformjs: {
                cwd: "./jsapp",
                command: "django-admin.py compilemessages",
                stdout: true,
                stderr: true
            }
        },
        nggettext_extract: {
            jsapp_angular_gettext_pot: {
                files: {
                    'jsapp/locale/angular-gettext/angular-gettext.pot': [
                        'jsapp/kobo/templates/**/*.html',
                        'jsapp/kobo/controllers/**/*.js',
                        'jsapp/kobo/directives/**/*.js',
                        'jsapp/kobo/services/**/*.js'
                    ]
                }
            },
        },
        nggettext_compile: {
            all: {
                files: {
                    'jsapp/kobo/translations.js': ['jsapp/locale/angular-gettext/*.po']
                }
            },
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-karma');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-sass');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks("grunt-modernizr");
    grunt.loadNpmTasks("grunt-exec");
    grunt.loadNpmTasks('grunt-angular-gettext');

    grunt.registerTask('build', [
        'requirejs:compile_xlform',
        'build_css',
        'make_i18n',
    ]);
    grunt.registerTask('build_all', [
        'build',
        'modernizr',
    ]);
    grunt.registerTask('build_css', [
        'sass:dist',
        'cssmin:strip_duplicates',
        'cssmin:dist',
    ]);
    grunt.registerTask('make_i18n', [
        'exec:makemessages_templates',
        'exec:compilemessages_templates',
        'exec:makemessages_xlformjs',
        'exec:compilemessages_xlformjs',
        'nggettext_extract:jsapp_angular_gettext_pot',
        'nggettext_compile:all',
    ]);

    grunt.registerTask('test', [
        'build',
        'karma:unit',
        'karma:amd',
    ]);

    grunt.registerTask('develop', [
        'requirejs:compile_xlform',
        'build_css',
        'make_i18n',
        'watch',
    ]);

    grunt.registerTask('default', [
        'develop',
    ]);
};
