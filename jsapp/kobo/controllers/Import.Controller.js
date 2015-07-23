/*exported ImportController*/
'use strict';

kobo.controller('ImportController', ['$scope', '$rootScope', '$cookies', 'gettextCatalog', ImportController]);
function ImportController($scope, $rootScope, $cookies, gettextCatalog) {
    $rootScope.canAddNew = false;
    $rootScope.activeTab = gettextCatalog.getString('Import CSV');
    $scope.csrfToken = $cookies.csrftoken;
}
