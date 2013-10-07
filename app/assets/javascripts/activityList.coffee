this.ActivityList = class ActivityList extends ViewBase
  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:activitiesloaded', @showActivities
    evtRouter.on 'gnip:activitieserror', @showError
    evtRouter.on 'gnip:searchsubmitted', @hide
    evtRouter.on 'gnip:timeboundsupdated', @hide
    @$el.on 'click', '.js-content', @toggleTweetDetails
    @$el.on 'click', '.tweet', (evt) =>
      activity = $(evt.target).closest('.tweet').data('activity')
      if activity
        evtRouter.trigger 'gnip:selectactivity', activity.id
    @$el.on 'click', '.profile-location', (evt) =>
      evt.preventDefault()
      evtRouter.trigger 'gnip:toggleactivitymap', true

  clearActivities: =>
    @$el.empty()

  showActivities: (evt, opts) =>
    @clearActivities()
    if Array.isArray(opts.data) and opts.data.length
      activityTemplate = $('#tweet-template').find('.tweet')
      fragment = $('<div/>')
      fragment.append(@renderActivity(activity, activityTemplate)) for activity in opts.data
      @$el.append fragment
    else
      @$el.empty().append '<li class="no-activities">No activities</li>'
    @show()

  showError: (evt, jqXHR) =>
    if jqXHR.status == 500
      @$el.empty().append '<li class="no-activities">Server Error :(</li>'
      @show()

  appendText: (target, text, delimiter) =>
    if text is `undefined`
      target
    else
      target += text + delimiter

  renderCountryText: (text, address, delimiter) =>
    if address.locality is `undefined` and address.region is `undefined`
      @appendText(text, address.country, delimiter)
    else
      @appendText(text, address.countryCode, delimiter)

  renderGeoText: (text, coordinates, delimiter) =>
    @appendText(text, '(' + coordinates[0] + ", " + coordinates[1] + ')', delimiter)

  renderActivity: (activity, template) =>
    actor = activity.actor
    $fragment = template.clone()
    $fragment.data('activity', activity)
    $fragment.find('.account-group').attr 'href', "https://www.twitter.com/#{actor.preferredUsername}/"
    $fragment.find('.js-fullname').text actor.displayName
    $fragment.find('.js-username').text "@#{actor.preferredUsername}"
    $fragment.find('.js-username').attr 'href', "https://www.twitter.com/#{actor.preferredUsername}/"
    $fragment.find('.js-relative-timestamp').text window.moment(Date.parse(activity.postedTime)).fromNow()
    $fragment.find('.js-relative-timestamp').attr 'href', activity.link
    $fragment.find('.js-tweet-text').text activity.body
    # TODO: only render activity if in view
    $fragment.find('img.js-avatar').attr 'src', actor.image
    if activity.gnip.klout_score
      $fragment.find('.klout-score').text activity.gnip.klout_score
      $fragment.find('.klout-topics').text activity.gnip.klout_profile.topics.map((topic) -> topic.displayName).join(', ')
    if activity.gnip.profileLocations
      geoDetails = ''
      activity.gnip.profileLocations.map((location) =>
        geoDetails = @appendText(geoDetails, location.address.locality, ", ")
        geoDetails = @appendText(geoDetails, location.address.region, " ")
        geoDetails = @renderCountryText(geoDetails, location.address, " ")
        geoDetails = @renderGeoText(geoDetails, location.geo.coordinates, " ")
      )
      $fragment.find('.profile-location').text geoDetails
    $fragment

  toggleTweetDetails: (event) =>
    target = $(event.target)
    if target.hasClass("js-activity-details")
      event.preventDefault()
      target.parents(".js-content").find(".js-activity-details-content").fadeToggle()
