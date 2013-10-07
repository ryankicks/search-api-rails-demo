this.ChartHeader = class ChartHeader extends ViewBase
  dateFormat: 'MMM DD HH:mm'

  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:chartdataloaded', @showHeader
    evtRouter.on 'gnip:searchsubmitted', @hide
    evtRouter.on 'gnip:timeboundsupdated', @updateText

  updateText: (evt, opts) =>
    subheaderEl = @$el.find('.subheader')
    if opts.reset
      subheaderEl.text("#{window.moment().subtract('days', window.GNIP.constants.DEFAULT_SEARCH_IN_DAYS).format(@dateFormat)} - #{window.moment().format(@dateFormat)}")
    else
      subheaderEl.text("#{window.moment(opts.min).format(@dateFormat)} - #{window.moment(opts.max).format(@dateFormat)}")

  showHeader: (evt, opts) =>
    @show() unless opts['data'].every((e) -> e == 0)
