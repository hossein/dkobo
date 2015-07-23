###
defaultSurveyDetails
--------------------
These values will be populated in the form builder and the user
will have the option to turn them on or off.

When exported, if the checkbox was selected, the "asJson" value
gets passed to the CSV builder and appended to the end of the
survey.

Details pulled from ODK documents / google docs. Notably this one:
  https://docs.google.com/spreadsheet/ccc?key=0AgpC5gsTSm_4dDRVOEprRkVuSFZUWTlvclJ6UFRvdFE#gid=0
###
define 'cs!xlform/model.configs', ["underscore", 'cs!xlform/model.utils', "backbone"], (_, $utils, Backbone)->
  configs = {}
  configs.defaultSurveyDetails =
    start_time:
      name: "start"
      label: gettext("Start Time")
      description: gettext("Records when the survey was begun")
      default: true
      asJson:
        type: "start"
        name: "start"
    end_time:
      name: "end"
      label: gettext("End Time")
      description: gettext("Records when the survey was marked as completed")
      default: true
      asJson:
        type: "end"
        name: "end"
    today:
      name: "today"
      label: gettext("Today")
      description: gettext("Includes today's date")
      default: false
      asJson:
        type: "today"
        name: "today"
    username:
      name: "username"
      label: gettext("Username")
      description: gettext("Includes interviewer's username")
      default: false
      asJson:
        type: "username"
        name: "username"
    simserial:
      name: "simserial"
      label: gettext("SIM Serial")
      description: gettext("Records the serial number of the network SIM card")
      default: false
      asJson:
        type: "simserial"
        name: "simserial"
    subscriberid:
      name: "subscriberid"
      label: gettext("Subscriber ID")
      description: gettext("Records the subscriber ID of the SIM card")
      default: false
      asJson:
        type: "subscriberid"
        name: "subscriberid"
    deviceid:
      name: "deviceid"
      label: gettext("Device ID")
      aliases: ["imei"]
      description: gettext("Records the internal device ID number, a.k.a IMEI (works on Android phones)")
      default: false
      asJson:
        type: "deviceid"
        name: "deviceid"
    phoneNumber:
      name: "phonenumber"
      label: gettext("Phone Number")
      description: gettext("Records the device's phone number, when available")
      default: false
      asJson:
        type: "phonenumber"
        name: "phonenumber"

  do ->
    class SurveyDetailSchemaItem extends Backbone.Model
      _forSurvey: ()->
        name: @get("name")
        label: @get("label")
        description: @get("description")

    class configs.SurveyDetailSchema extends Backbone.Collection
      model: SurveyDetailSchemaItem
      typeList: ()->
        unless @_typeList
          @_typeList = (item.get("name")  for item in @models)
        @_typeList

  configs.surveyDetailSchema = new configs.SurveyDetailSchema(_.values(configs.defaultSurveyDetails))

  ###
  Default values for rows of each question type
  ###
  configs.defaultsForType =
    geopoint:
      label:
        value: gettext("Record your current location")
      required:
        value: false
        _hideUnlessChanged: true
    image:
      label:
        value: gettext("Point and shoot! Use the camera to take a photo")
    video:
      label:
        value: gettext("Use the camera to record a video")
    audio:
      label:
        value: gettext("Use the camera's microphone to record a sound")
    note:
      label:
        value: gettext("This note can be read out loud")
      required:
        value: false
        _hideUnlessChanged: true
    integer:
      label:
        value: gettext("Enter a number")
    barcode:
      label:
        value: gettext("Use the camera to scan a barcode")
    decimal:
      label:
        value: gettext("Enter a number")
    date:
      label:
        value: gettext("Enter a date")
    calculate:
      calculation:
        value: ""
      label:
        value: pgettext("Row default value", "Calculation")
      required:
        value: false
        _hideUnlessChanged: true
    datetime:
      label:
        value: gettext("Enter a date and time")
    time:
      label:
        value: gettext("Enter a time")
    acknowledge:
      label:
        value: pgettext("Imperative sentence for row default value", "Acknowledge")

  configs.columns = ["type", "name", "label", "hint", "required", "relevant", "default", "constraint"]

  configs.lookupRowType = do->
    typeLabels = [
      ["note",            pgettext("Type Label", "Note")            , preventRequired: true],
      ["acknowledge",     pgettext("Type Label", "Acknowledge")],
      ["text",            pgettext("Type Label", "Text")           ], # expects text
      ["integer",         pgettext("Type Label", "Integer")        ], #e.g. 42
      ["decimal",         pgettext("Type Label", "Decimal")        ], #e.g. 3.14
      ["geopoint",        pgettext("Type Label", "Geopoint (GPS)") ], # Can use satelite GPS coordinates
      ["image",           pgettext("Type Label", "Image")           , isMedia: true], # Can use phone camera, for example
      ["barcode",         pgettext("Type Label", "Barcode")        ], # Can scan a barcode using the phone camera
      ["date",            pgettext("Type Label", "Date")           ], #e.g. (4 July, 1776)
      ["time",            pgettext("Type Label", "Time")           ], #e.g. (4 July, 1776)
      ["datetime",        pgettext("Type Label", "Date and Time")  ], #e.g. (2012-Jan-4 3:04PM)
      ["audio",           pgettext("Type Label", "Audio")           , isMedia: true], # Can use phone microphone to record audio
      ["video",           pgettext("Type Label", "Video")           , isMedia: true], # Can use phone camera to record video
      ["calculate",       pgettext("Type Label", "Calculate")      ],
      ["select_one",      pgettext("Type Label", "Select")          , orOtherOption: true, specifyChoice: true],
      ["score",           pgettext("Type Label", "Score")          ],
      ["score__row",      pgettext("Type Label", "Score Row")      ],
      ["rank",            pgettext("Type Label", "Rank")           ],
      ["rank__level",     pgettext("Type Label", "Rank Level")     ],
      ["select_multiple", pgettext("Type Label", "Multiple choice") , orOtherOption: true, specifyChoice: true]
    ]

    class Type
      constructor: ([@name, @label, opts])->
        opts = {}  unless opts
        _.extend(@, opts)

    types = (new Type(arr) for arr in typeLabels)

    exp = (typeId)->
      for tp in types when tp.name is typeId
        output = tp
      output

    exp.typeSelectList = do ->
      () -> types

    exp

  configs.columnOrder = do ->
    (key)->
      if -1 is configs.columns.indexOf key
        configs.columns.push(key)
      configs.columns.indexOf key

  configs.newRowDetails =
    name:
      value: ""
    label:
      value: pgettext("New Question Label", "New Question")
    type:
      value: "text"
    hint:
      value: ""
      _hideUnlessChanged: true
    required:
      value: true
      _hideUnlessChanged: true
    relevant:
      value: ""
      _hideUnlessChanged: true
    default:
      value: ""
      _hideUnlessChanged: true
    constraint:
      value: ""
      _hideUnlessChanged: true
    constraint_message:
      value: ""
      _hideUnlessChanged: true
    appearance:
      value: ''
      _hideUnlessChanged: true

  configs.newGroupDetails =
    name:
      value: ->
        "group_#{$utils.txtid()}"
    label:
      value: pgettext("New Group Label", "Group")

    type:
      value: "group"
    _isRepeat:
      value: false
    relevant:
      value: ""
      _hideUnlessChanged: true
    appearance:
      value: ''
      _hideUnlessChanged: true


  configs.question_types = {}

  ###
  String representations of boolean values which are accepted as true from the XLSForm.
  ###

  configs.truthyValues = [
    "yes",
    "true",
    "true()",
    "TRUE",
  ]
  configs.falsyValues = [
    "no",
    "false",
    "false()",
    "FALSE",
  ]

  # Alternative: XLF.configs.boolOutputs = {"true": "yes", "false": "no"}
  configs.boolOutputs = {"true": "true", "false": "false"}

  configs
