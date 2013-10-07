$ ->
  moment.lang 'en',
    defaultFormat: 'YYYY-MM-DDTHH:mm:ssZ'
    relativeTime:
      future: 'in %s'
      past: '%s'
      s: '%ds'
      m: '1m'
      mm: '%dm'
      h: '1h'
      hh: '%dh'
      d: '1 day'
      dd: '%d days'
      M: '1 month'
      MM: '%d months'
      y: '1 year'
      yy: '%d years'

  window.GNIP =
    constants:
      ACTIVITY_LIST_ENABLED: true
      ACTIVITY_MAP_ENABLED: false
      CHART_ENABLED: true
      DEFAULT_SEARCH_IN_DAYS: 30
      MAPBOX_API_KEY: 'YOUR_MAPBOX_API_KEY'

  window.GNIP.activitiesHeader = new ActivitiesHeader($('#activities-header')) if window.GNIP.constants.ACTIVITY_LIST_ENABLED
  window.GNIP.activityList = new ActivityList($('#activities-list')) if window.GNIP.constants.ACTIVITY_LIST_ENABLED
  window.GNIP.activityMap = new ActivityMap($('#map-container')) if window.GNIP.constants.ACTIVITY_MAP_ENABLED && window.GNIP.constants.ACTIVITY_LIST_ENABLED
  window.GNIP.chart = new Chart($('#activities-chart')) if window.GNIP.constants.CHART_ENABLED
  window.GNIP.chartHeader = new ChartHeader($('#chart-header')) if window.GNIP.constants.CHART_ENABLED
  window.GNIP.searchForm = new SearchForm($('#search-form'))
  window.GNIP.data = new SearchData()
