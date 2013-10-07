this.SearchData = class SearchData
  constructor: ->
    @bindEvents($(document))

  bindEvents: (evtRouter) =>
    chartCallback = (data) -> evtRouter.trigger('gnip:chartdataloaded', data)
    chartErrback = (jqXHR) -> evtRouter.trigger('gnip:chartdataerror', jqXHR)
    activitiesCallback = (data) -> evtRouter.trigger('gnip:activitiesloaded', {data: data})
    activitiesErrback = (jqXHR) -> evtRouter.trigger('gnip:activitieserror', jqXHR)
    evtRouter.on 'gnip:searchsubmitted', (evt, query) =>
      @loadChartDataFor "#{query}", chartCallback, chartErrback
      @loadActivitiesFor "#{query}", activitiesCallback, activitiesErrback
      evtRouter.trigger 'gnip:timeboundsupdated', {reset: true}

    evtRouter.on 'gnip:chartselection', (evt, opts) =>
      if opts.xAxis
        # Adapt query from local to UTC time
        timezoneOffset = new Date().getTimezoneOffset() * 60 * 1000
        minTS = Math.floor(opts.xAxis[0].min) + timezoneOffset
        # Prevent selection from going into the future
        maxTS = Math.min(Math.floor(opts.xAxis[0].max) + timezoneOffset, new Date().getTime())
        from = window.moment(minTS).format()
        to = window.moment(maxTS).format()
        evtRouter.trigger 'gnip:timeboundsupdated', {min: minTS, max: maxTS}
        @loadActivitiesFor "q=#{encodeURIComponent($('#q').val())}&from=#{encodeURIComponent(from)}&to=#{encodeURIComponent(to)}", activitiesCallback, activitiesErrback
      else
        evtRouter.trigger 'gnip:timeboundsupdated', {reset: true}
        @loadActivitiesFor "q=#{encodeURIComponent($('#q').val())}", activitiesCallback, activitiesErrback

  search: (url, callback, errback) =>
    $.ajax({type: 'post', url: url, dataType: 'json', timeout: 60000})
      .success((data) -> callback(data))
      .fail((jqXHR) -> errback(jqXHR) if errback)

  loadChartDataFor: (query, callback, errback) =>
    @search("/counts?#{query}", callback, errback)

  loadActivitiesFor: (query, callback, errback) =>
    @search("/activities?#{query}", callback, errback)