/* exported ConfigurationService */
'use strict';

kobo.service('$configuration', ['gettextCatalog', function (gettextCatalog) {
    this.sections = function () {
        return [
            {
                'title': gettextCatalog.getString('Forms'),
                'icon': 'fa-file-text-o',
                'name': 'forms'
            },
            {
                'title': gettextCatalog.getString('Question Library'),
                'icon': 'fa-folder',
                'name': 'library/questions'
            // },
            // {
            //     'title': gettextCatalog.getString('Admin'),
            //     'icon': 'fa-cog',
            //     'name': 'admin'
            // },
            // {
            //     'title': gettextCatalog.getString('Import CSV'),
            //     'icon': 'fa-cog',
            //     'name': 'import/csv'
            }
        ];
    };
}]);
