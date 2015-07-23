define 'cs!xlform/view.icons', [
        'backbone',
        ], (
            Backbone,
            )->

  iconDetails = [
    # row 1
      label: pgettext("Question Type Icon Label", "Select One")
      faClass: "dot-circle-o"
      grouping: "r1"
      id: "select_one"
    ,
      label: pgettext("Question Type Icon Label", "Select Many")
      faClass: "list-ul"
      grouping: "r1"
      id: "select_multiple"
    ,
      label: pgettext("Question Type Icon Label", "Text")
      faClass: "lato-text"
      grouping: "r1"
      id: "text"
    ,
      label: pgettext("Question Type Icon Label", "Number")
      faClass: "lato-integer"
      grouping: "r1"
      id: "integer"
    ,

    # row 2
      label: pgettext("Question Type Icon Label", "Decimal")
      faClass: "lato-decimal"
      grouping: "r2"
      id: "decimal"
    ,
      label: pgettext("Question Type Icon Label", "Date")
      faClass: "calendar"
      grouping: "r2"
      id: "date"
    ,
      label: pgettext("Question Type Icon Label", "Time")
      faClass: "clock-o"
      grouping: "r2"
      id: "time"
    ,
      label: pgettext("Question Type Icon Label", "Date & time")
      faClass: "calendar clock-over"
      grouping: "r2"
      id: "datetime"
    ,

    # r3
      label: pgettext("Question Type Icon Label", "GPS")
      faClass: "map-marker"
      grouping: "r3"
      id: "geopoint"
    ,
      label: pgettext("Question Type Icon Label", "Photo")
      faClass: "picture-o"
      grouping: "r3"
      id: "image"
    ,
      label: pgettext("Question Type Icon Label", "Audio")
      faClass: "volume-up"
      grouping: "r3"
      id: "audio"
    ,
      label: pgettext("Question Type Icon Label", "Video")
      faClass: "video-camera"
      grouping: "r3"
      id: "video"
    ,

    # r4
      label: pgettext("Question Type Icon Label", "Note")
      faClass: "bars"
      grouping: "r4"
      id: "note"
    ,
      label: pgettext("Question Type Icon Label", "Barcode")
      faClass: "barcode"
      grouping: "r4"
      id: "barcode"
    ,
      label: pgettext("Question Type Icon Label", "Acknowledge")
      faClass: "check-square-o"
      grouping: "r4"
      id: "acknowledge"
    ,
      label: pgettext("Question Type Icon Label", "Calculate")
      faClass: "lato-calculate"
      grouping: "r4"
      id: "calculate"
    ,

    # r5
      label: pgettext("Question Type Icon Label", "Matrix / Rating")
      # faClass: "server"
      # will look better but isn't available until FA 4.3
      faClass: "th"
      grouping: "r5"
      id: "score"
    ,
      label: pgettext("Question Type Icon Label", "Ranking")
      faClass: "sort-amount-desc"
      grouping: "r5"
      id: "rank"
    ,
    ]

  class QtypeIcon extends Backbone.Model
    defaults:
      faClass: "question-circle"

  class QtypeIconCollection extends Backbone.Collection
    model: QtypeIcon
    grouped: ()->
      unless @_groups
        @_groups = []
        grp_keys = []
        @each (model)=>
          grping = model.get("grouping")
          grp_keys.push(grping)  unless grping in grp_keys
          ii = grp_keys.indexOf(grping)
          @_groups[ii] or @_groups[ii] = []
          @_groups[ii].push model
      _.zip.apply(null, @_groups)

  new QtypeIconCollection(iconDetails)
