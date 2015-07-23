/*exported HeaderController*/
'use strict';

kobo.controller('HeaderController', ['$scope', '$rootScope', '$location', 'gettextCatalog', HeaderController]);
function HeaderController($scope, $rootScope, $location, gettextCatalog) {

    $scope.pageIconColor = 'teal';
    $scope.pageTitle = gettextCatalog.getString('Forms', null, 'Page Title');
    $scope.pageIcon = 'fa-file-text-o';
    $rootScope.isLoading = false;

    $rootScope.topLevelMenuActive = '';
    $rootScope.activeTab = gettextCatalog.getString('Forms', null, 'Active Tab');

    $scope.toggleTopMenu = function ($event) {
        if (!!$event) {
            $event.stopPropagation();
        }
        $rootScope.topLevelMenuActive = !!$rootScope.topLevelMenuActive ? '' : 'is-active';
    };

    $rootScope.closeTopMenu = function () {
        $rootScope.topLevelMenuActive = '';
    };

    $scope.$on('$locationChangeSuccess', function() {
        $rootScope.showCreateButton = $rootScope.showImportButton = !(""+$location.path()).match(/\/builder\/?(\d+|new)?$/);
    });
    $scope.toggleBleedingEdge = function ($event) {
        if ($event.shiftKey) {
            $('body').toggleClass('bleeding-edge');
        }
    };
}
