/* exported TopLevelMenuDirective */
/* global staticFilesUri */
'use strict';

kobo.directive ('topLevelMenu', ['$userDetails', '$configuration', 'gettextCatalog', function ($userDetails, $configuration, gettextCatalog) {
    return {
        restrict:'A',
        templateUrl: staticFilesUri + 'templates/TopLevelMenu.Template.html',
        scope: {
            activeTab: '='
        },
        link: function (scope) {
            var userDetails = $userDetails;
            if ($userDetails) {
                scope.user = {
                    name: userDetails.name ? userDetails.name : gettextCatalog.getString('KoBoForm User'),
                    avatar: userDetails.gravatar ? userDetails.gravatar: (staticFilesUri + '/img/avatars/example-photo.jpg'),
                    username: userDetails.username
                };
            } else {
                scope.user = {
                    name: gettextCatalog.getString('KoBoForm User'),
                    avatar: staticFilesUri + '/img/avatars/example-photo.jpg'
                };
            }

            var kobocatUrl = (window.koboConfigs && window.koboConfigs.kobocatServer) || 'http://kobocat.dev.kobotoolbox.org/';
            scope.kobocatLink = {
              url: kobocatUrl,
              name: gettextCatalog.getString('Projects')
            };

            scope.sections = $configuration.sections();

            scope.isActive = function (name) {
                return name === scope.activeTab ? 'is-active' : '';
            };
        }
    };
}]);
