define 'cs!xlform/view.surveyApp.templates', [], ()->

  surveyTemplateApp = () ->
      """
          <button class="btn js-start-survey">%1</button>
          <span class="or">%2</span>
          <hr>
          <form action="/import_survey_draft" class="btn btn--fileupload js-import-fileupload">
            <span class="fileinput-button">
              <span>%3</span>
              <input type="file" name="files">
            </span>
          </form>
      """
      .replace("%1", gettext("Start from Scratch"))
      .replace("%2", gettext("or"))
      .replace("%3", gettext("Import XLS"))

  surveyApp = (surveyApp) ->
      survey = surveyApp.survey
      multiple_questions = surveyApp.features.multipleQuestions
      if multiple_questions
        type_name = gettext("Form")
      else
        type_name = gettext("Question")
      
      save_and_exit_translation =
          pgettext('#{type_name} can be Form, Question', 'Save and Exit #{type_name}')
          .replace('#{type_name}', type_name)
                                  
      preview_translation = 
          pgettext('#{type_name} can be Form, Question', 'Preview #{type_name}')
          .replace('#{type_name}', type_name)
      
      warnings_html = ""
      if surveyApp.warnings and surveyApp.warnings.length > 0
        warnings_html = """<div class="survey-warnings">"""
        for warning in surveyApp.warnings
          warnings_html += """<p class="survey-warnings__warning">#{warning}</p>"""
        warnings_html += """<button class="survey-warnings__close-button js-close-warning">x</button></div>"""
      """
        <div class="sub-header-bar">
          <div class="container__wide">
            <button class="btn btn--utility survey-editor__action--multiquestion" id="settings"><i class="fa fa-cog"></i> %1</button>
            <button class="btn btn--utility" id="save"><i class="fa fa-check-circle green"></i> %2</button>
            <button class="btn btn--utility" id="xlf-preview"><i class="fa fa-eye"></i> %3</button>
            <button class="btn btn--utility survey-editor__action--multiquestion js-expand-multioptions--all" ><i class="fa fa-caret-right"></i> %4</button>
            <button class="btn btn--utility survey-editor__action--multiquestion btn--group-questions btn--disabled js-group-rows">%5</button>
          <button class="btn btn--utility pull-right survey-editor__action--multiquestion rowselector_toggle-library" id="question-library"><i class="fa fa-folder"></i> %6</button>
          </div>
        </div>
        <div class="container__fixed">
          <div class="container__wide">
            <div class="form__settings">

              <div class="form__settings__field form__settings__field--form_id">
                <label>%7</label>
                <span class="poshytip" title="%8">?</span>
                <input type="text">
              </div>

              <div class="form__settings__field form__settings__field--style form__settings__field--appearance">
                <label class="">%9</label>
                <span class="poshytip" title="%0A">?</span>
                <p>
                  <select>
                    <option value="">%0B</option>
                    <option value="theme-grid">%0C</option>
                  </select>
                </p>
              </div>

              <div class="form__settings__field form__settings__field--version">
                <label class="">%0D</label>
                <span class="poshytip" title="%0E">?</span>
                <input type="text">
              </div>

              <div class="form__settings-meta__questions">
                <h4 class="form__settings-meta__questions-title">%0F</h4>
                <div class="stats  row-details settings__first-meta" id="additional-options"></div>
                <h4 class="form__settings-meta__questions-title">%0G</h4>
                <div class="stats  row-details settings__second-meta" id="additional-options"></div>
              </div>

              <div class="form__settings-submission-url bleeding-edge">
                <label class="">%0H</label>
                <span class="poshytip" title="%0I">?</span>
                <div><span class="editable  editable-click">http://kobotoolbox.org/data/longish_username</span></div>
              </div>

              <div class="form__settings-public-key bleeding-edge">
                <label class="">%0J</label>
                <span class="poshytip" title="%0K">?</span>
                <span class="editable  editable-click">12345-232</span>
              </div>

            </div>
          </div>
        </div>
        <header class="survey-header">
          <p class="survey-header__description" hidden>
            <hgroup class="survey-header__inner container">
              <h1 class="survey-header__title">
                <span class="form-title">#{survey.settings.get("form_title")}</span>
              </h1>
            </hgroup>
          </p>
        </header>
        #{warnings_html}
        <div class="survey-editor form-editor-wrap container">
          <ul class="-form-editor survey-editor__list">
            <li class="survey-editor__null-top-row empty">
              <p class="survey-editor__message well">
                <b>%0L</b><br>
                %0M
              </p>
              <div class="survey__row__spacer  expanding-spacer-between-rows expanding-spacer-between-rows--depr">
                <div class="btn btn--block btn--addrow js-expand-row-selector   add-row-btn add-row-btn--depr">
                  <i class="fa fa-plus"></i>
                </div>
                <div class="line">&nbsp;</div>
              </div>
            </li>
          </ul>
        </div>
      """
      .replace("%1", gettext("Form Settings"))
      .replace("%2",         save_and_exit_translation)
      .replace("%3",         preview_translation)
      .replace("%4", gettext("Show All Responses"))
      .replace("%5", gettext("Group Questions"))
      .replace("%6", gettext("Question Library"))
      .replace("%7", gettext("Form ID"))
      .replace("%8", gettext("Unique form name"))
      .replace("%9", gettext("Web form style (Optional)"))
      .replace("%0A", gettext("This allows using different Enketo styles, e.g. 'theme-grid'"))
      .replace("%0B", gettext("(empty)"))
      .replace("%0C", gettext("theme-grid"))
      .replace("%0D", gettext("Version (Optional)"))
      .replace("%0E", gettext("A version ID of the form"))
      .replace("%0F", gettext("Hidden meta questions to include in your form to help with analysis"))
      .replace("%0G", gettext("Meta questions for collecting with cell phones"))
      .replace("%0H", gettext("Manual submission URL (advanced)"))
      .replace("%0I", gettext("The specific server instance where the data should go to - optional"))
      .replace("%0J", gettext("Public Key"))
      .replace("%0K", gettext("The encryption key used for secure forms - optional"))
      .replace("%0L", gettext("This form is currently empty."))
      .replace("%0M", gettext("You can add questions, notes, prompts, or other fields by clicking on the \"+\" sign below."))

  surveyTemplateApp: surveyTemplateApp
  surveyApp: surveyApp
