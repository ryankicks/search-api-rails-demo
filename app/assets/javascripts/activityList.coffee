this.ActivityList = class ActivityList extends ViewBase
  bindEvents: (evtRouter) =>
    evtRouter.on 'gnip:activitiesloaded', @showActivities
    evtRouter.on 'gnip:activitieserror', @showError
    evtRouter.on 'gnip:searchsubmitted', @hide
    evtRouter.on 'gnip:timeboundsupdated', @hide
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
      fragment = $('<div/>')
      fragment.append(Handlebars.templates.tweet(activity)) for activity in opts.data
      # TODO: defer render/load of tweets out-of-view
      @$el.append fragment
    else
      @$el.append '<li class="no-activities">No activities</li>'
    @show()

  showError: (evt, jqXHR) =>
    if jqXHR.status == 500
      @$el.empty().append '<li class="no-activities">Server Error :(</li>'
      @show()
