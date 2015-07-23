define 'cs!xlform/view.choices.templates', [], ()->

  addOptionButton = () ->
      """<div class="card__addoptions">
          <div class="card__addoptions__layer"></div>
            <ul><li class="multioptions__option  xlf-option-view xlf-option-view--depr">
              <div><div class="editable-wrapper"><span class="editable editable-click">+ %1</span></div><code><label>%2</label> <span>%3</span></code></div>
            </li></ul>
        </div>"""
      .replace("%1", gettext("Click to add another response..."))
      .replace("%2", gettext("Value:"))
      .replace("%3", gettext("AUTOMATIC"))

  addOptionButton: addOptionButton
