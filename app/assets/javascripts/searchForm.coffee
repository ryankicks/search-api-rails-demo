this.SearchForm = class SearchForm extends ViewBase
  constructor: ($el) ->
    super $el
    @searchInput = @$el.find('#q')

  bindEvents: (evtRouter) =>
    evtRouter.on 'keyup', 'body', (evt) =>
      # Focus and select search box when '/' is typed *outside* of the search box
      @searchInput.select() if evt.target.tagName.toLowerCase() != 'input' and evt.keyCode == 191
      true

    @$el.on 'submit', (evt) =>
      evt.preventDefault()
      if @searchInput.val()
        @$el.addClass 'collapsed'
        evtRouter.trigger('gnip:searchsubmitted', "q=#{encodeURIComponent(@searchInput.val())}")

    @$el.find('.icon-search').on 'click', =>
      @$el.trigger 'submit'

    evtRouter.on 'gnip:activitieserror', @showError

  showError: (evt, jqXHR) =>
    if jqXHR.status == 400
      @searchInput.addClass('error')
      @$el.append "<p class=\"error-message\">#{jqXHR.responseText}</p>"
      @searchInput.one 'change keydown', =>
        @searchInput.removeClass('error')
        @$el.find('.error-message').remove()
