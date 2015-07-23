define 'cs!xlform/view.rowDetail.ValidationLogic', [
  'cs!xlform/view.rowDetail.SkipLogic',
  'cs!xlform/view.widgets',
  'cs!xlform/mv.skipLogicHelpers'
], ($skipLogicView, $viewWidgets, $skipLogicHelpers) ->

  viewRowDetailValidationLogic = {}
  class viewRowDetailValidationLogic.ValidationLogicViewFactory extends $skipLogicView.SkipLogicViewFactory
    create_criterion_builder_view: () ->
      return new viewRowDetailValidationLogic.ValidationLogicCriterionBuilder()
    create_question_picker: () ->
      return new viewRowDetailValidationLogic.ValidationLogicQuestionPicker
    create_operator_picker: (question_type) ->
      operators = _.filter($skipLogicHelpers.operator_types, (op_type) -> op_type.id != 1 && op_type.id in question_type.operators)
      return new $skipLogicView.OperatorPicker operators

  class viewRowDetailValidationLogic.ValidationLogicCriterionBuilder extends $skipLogicView.SkipLogicCriterionBuilderView
    render: () ->
      super
      @$el.html(@$el.html().replace(
        #IMPORTANT: The FIRST "This question will..." also appears at view.rowDetail.SkipLogic.coffee.
        #           The two English texts in both files must remain IDENTICAL, as this file will
        #           replace it with something else.
        gettext("This question will only be displayed if the following conditions apply")
        gettext("This question will be valid only if the following conditions apply")
      ))

      @

  class viewRowDetailValidationLogic.ValidationLogicQuestionPicker extends $viewWidgets.Label
    constructor: () ->
      super(gettext("This question's response has to be"))
    attach_to: (target) ->
      target.find('.skiplogic__rowselect').remove()
      super(target)

  viewRowDetailValidationLogic
