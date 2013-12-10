this.ActivityMap = class ActivityMap extends ViewBase
  constructor: ($el) ->
    super($el)

    @map = L.mapbox.map('map', window.GNIP.constants.MAPBOX_API_KEY, {
      maxZoom: 10,
      minZoom: 1
    })
    @markers = new L.MarkerClusterGroup()
    @markerLookup = {}
    @points = []

    @map.addLayer(@markers)

  showMap: =>
    @$el.find('#activities-map').removeClass('is-closed').addClass('is-open')

  hideMap: =>
    @$el.find('#activities-map').removeClass('is-open').addClass('is-closed')

  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:activitiesloaded', @show
    evtRouter.on 'gnip:activitiesloaded', @loadMarkers
    evtRouter.on 'gnip:searchsubmitted', @hide
    evtRouter.on 'gnip:timeboundsupdated', @hide
    evtRouter.on 'gnip:toggleactivitymap', (evt, show) =>
      $lnk = @$el.find('.toggle-activity-map')
      if show
        $lnk.text('Hide Map')
        @showMap()
      else
        $lnk.text('Show Map')
        @hideMap()

    evtRouter.on 'gnip:selectactivity', (evt, activityId) =>
      m = @markerLookup[activityId]
      if m
        @markers.zoomToShowLayer m, =>
          m.openPopup()

    @$el.on 'click', '.toggle-activity-map', (evt) =>
      evt.preventDefault()
      evtRouter.trigger 'gnip:toggleactivitymap', @$el.find('#activities-map').hasClass('is-closed')

  bindLocationToMarkerPopup: (activity, location) =>
    point = L.latLng(location.geo.coordinates[1], location.geo.coordinates[0])
    @points.push(point)
    marker = new L.Marker(point)
    marker.bindPopup(Handlebars.templates.tweet(activity), {
      maxWidth: 500,
      minWidth: 400
    })
    @markerLookup[activity.id] = marker
    @markers.addLayer(marker)

  resetMap: =>
    @markers.clearLayers()
    @markerLookup = {}
    @points = []

  loadMarkers: (evt, opts) =>
    @resetMap()

    # Don't show if there are no points
    if !Array.isArray(opts.data) or !opts.data.length
      @hide()
      return

    activities = (a for a in opts.data when a.gnip and a.gnip.profileLocations)
    activities.map (a) => (@bindLocationToMarkerPopup(a, l) for l in a.gnip.profileLocations when l.geo)

    @map.fitBounds(@points)
