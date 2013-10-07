this.ActivitiesHeader = class ActivitiesHeader extends ViewBase
  dateFormat: 'MMM DD HH:mm'

  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:activitiesloaded', @show
    evtRouter.on 'gnip:activitiesloaded', @updateCount
    evtRouter.on 'gnip:searchsubmitted', @hide
    evtRouter.on 'gnip:timeboundsupdated', @hide
    evtRouter.on 'gnip:timeboundsupdated', @updateDateRange

  hide: =>
    super()
    $(document).trigger 'gnip:toggleactivitymap', false

  show: (evt, opts) =>
    @$el.addClass('flip-in') if opts['data'].length

  updateCount: (evt, opts) =>
    @$el.find('.js-activities-count').text("Last #{opts['data'].length}, ") if opts['data']

  updateDateRange: (evt, opts) =>
    subheaderEl = @$el.find('.js-activities-date-range')
    if opts.reset
      subheaderEl.text("#{window.moment().subtract('days', window.GNIP.constants.DEFAULT_SEARCH_IN_DAYS).format(@dateFormat)} - #{window.moment().format(@dateFormat)}")
    else
      subheaderEl.text("#{window.moment(opts.min).format(@dateFormat)} - #{window.moment(opts.max).format(@dateFormat)}")
