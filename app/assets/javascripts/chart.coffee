this.Chart = class Chart extends ViewBase
  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:chartdataloaded', @showChart
    evtRouter.on 'gnip:searchsubmitted', @hide

  defaultChartConfig:
    chart:
      animation: false
      events:
        selection: (evt) -> $(document).trigger('gnip:chartselection', evt)
      height: 220
      spacingBottom: 5
      spacingLeft: 0
      spacingRight: 0
      spacingTop: 5
      zoomType: 'x'
    title:
      text: null
    xAxis:
      type: 'datetime'
      dateTimeLabelFormats:
        day: '%b %e'
      labels:
        align: 'left'
      minTickInterval: 86400000
      title:
        text: null
    yAxis:
      min: 0
      gridLineWidth: 0
      minorGridLineWidth: 0
      title:
        text: null
    tooltip:
      animation: false
      borderRadius: 0
      shared: true
    legend:
      enabled: false
    credits:
      enabled: false
    plotOptions:
      area:
        fillColor:
          linearGradient: {x1: 0, y1: 0, x2: 0, y2: 1}
          stops: [[0, Highcharts.getOptions().colors[0]], [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get("rgba")]]
        lineWidth: 1
        marker:
          enabled: false
        shadow: false
        states:
          hover:
            lineWidth: 2
        threshold: null

  showChart: (evt, opts) =>
    unless opts['data'].every((e) -> e == 0)
      # Adapt chart to local time
      adjustedStartTimestamp = opts['point_start'] - (new Date().getTimezoneOffset() * 60 * 1000)
      seriesConfig = series: [
        type: 'area'
        name: 'Activities'
        pointInterval: opts['point_interval']
        pointStart: adjustedStartTimestamp
        data: opts['data']
        animation: false
      ]
      @$el.highcharts $.extend({}, @defaultChartConfig, seriesConfig)
      @show()
