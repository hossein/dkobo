/* exported AssetsController */
/* global dkobo_xlform */
/* global _ */
'use strict';
//noinspection JSUnusedGlobalSymbols
kobo.controller('AssetsController', ['$scope', '$rootScope', '$miscUtils', '$api', '$filter', 'gettextCatalog', AssetsController]);
function AssetsController($scope, $rootScope, $miscUtils, $api, $filter, gettextCatalog) {
    $scope.tagFilters = {};
    $rootScope.showImportButton = false;
    $rootScope.showCreateButton = false;
    $scope.questionFilters = {};
    $rootScope.icon_link = 'library/questions';
    $scope.newTagName = '';
    var filter = $filter('itemFilter');
    $scope.tagSorter = {
        criteria: [
            {value: "-date_modified" , label: gettextCatalog.getString('Newest'            , null, "Tag sorter")},
            {value: "label"          , label: gettextCatalog.getString('A - Z'             , null, "Tag sorter")},
            {value: "[count, label]" , label: gettextCatalog.getString('A - Z, Empty First', null, "Tag sorter")},
            {value: "[-count, label]", label: gettextCatalog.getString('A - Z, Empty Last' , null, "Tag sorter")},
            {value: '-label'         , label: gettextCatalog.getString('Z - A'             , null, "Tag sorter")}
        ]
    };

    $scope.tagSorter.selected = $scope.tagSorter.criteria[1];

    $scope.questionSorter = {
        criteria: [
            {value: '-date_modified', label: gettextCatalog.getString('Newest First', null, "Question sorter")},
            {value: 'date_modified' , label: gettextCatalog.getString('Oldest First', null, "Question sorter")},
            {value: 'label'         , label: gettextCatalog.getString('A - Z'       , null, "Question sorter")},
            {value: '-label'        , label: gettextCatalog.getString('Z - A'       , null, "Question sorter")}
        ]
    };

    $scope.questionSorter.selected = $scope.questionSorter.criteria[0];

    $scope.api = $api;

    $api.questions.list();
    $scope.tags = $api.tags.list();

    $miscUtils.bootstrapQuestionUploader(function () {
        $rootScope.$broadcast('reload:library_assets');
    });


    $rootScope.canAddNew = true;
    $rootScope.activeTab = gettextCatalog.getString('Question Library');

    $rootScope.$on('list:library_assets', function () {
        $scope.toggleTagInFilters($api.tags.items);
    });

    $scope.$on('questions:reload', function () {
        $scope.toggleTagInFilters($api.tags.items)
    });

    $scope.toggleTagInFilters = function (items) {
        var tags = _.filter(items, function (item) {
            return item.meta.isSelected;
        });

        $scope.questionFilters.tags = _.pluck(tags, 'label');
        if ($scope.questionFilters.tags.length === 0) {
            delete $scope.questionFilters.tags;
        }
    };

    $scope.getQuestionCount = function () {
        var items = $api.questions.items;
        if (items) {
            return filter(items, $scope.questionFilters).length === items.length ? $api.questions.count : filter(items, $scope.questionFilters).length;
        } else {
            return 0;
        }
    };

    $scope.getCount = function (item) {
        var count = item.count;
        return count + ' question' + (count == 1 ? '' : 's');
    };
}
