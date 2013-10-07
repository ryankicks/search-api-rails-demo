describe 'ActivitiesHeader', ->
  unit = undefined
  beforeEach ->
    unit = new ActivitiesHeader($('<header><h2>Activities</h2><h5 class="subheader"><span class="js-activities-count"></span><span class="js-activities-date-range"></span></h5></header>'))

  describe '#updateCount', ->
    it 'should have count match number of items in data', ->
      unit.updateCount(null, {data: [1, 2, 3, 4]})
      expect(unit.$el.find('.js-activities-count').text()).toBe 'Last 4, '

  describe '#updateDateRange', ->
    it 'should set subheader to last DEFAULT_SEARCH_IN_DAYS days when time bounds are reset', ->
      unit.updateDateRange(null, {reset: true})
      expect(unit.$el.find('.js-activities-date-range').text()).toBe "#{moment().subtract('days', GNIP.constants.DEFAULT_SEARCH_IN_DAYS).format(unit.dateFormat)} - #{moment().format(unit.dateFormat)}"

    it 'should adapt subheader to time bounds', ->
      opts = {min: 10000000, max: 20000000}
      unit.updateDateRange(null, opts)
      expect(unit.$el.find('.js-activities-date-range').text()).toBe "#{moment(opts.min).format(unit.dateFormat)} - #{moment(opts.max).format(unit.dateFormat)}"

  describe '#show', ->
    it 'should flip-in header if there is data', ->
      expect(unit.$el.hasClass('flip-in')).toBeFalsy()
      unit.show(null, {data: []})
      expect(unit.$el.hasClass('flip-in')).toBeFalsy()
      unit.show(null, {data: ['foo', 'bar']})
      expect(unit.$el.hasClass('flip-in')).toBeTruthy()
