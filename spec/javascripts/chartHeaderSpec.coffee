describe 'ChartHeader', ->
  unit = undefined
  beforeEach ->
    unit = new ChartHeader($('<header><h2>Activity Volume</h2><h5 class="subheader"></h5></header>'))

  describe '#updateText', ->
    it 'should set subheader to last DEFAULT_SEARCH_IN_DAYS days when time bounds are reset', ->
      unit.updateText(null, {reset: true})
      expect(unit.$el.find('.subheader').text()).toBe "#{moment().subtract('days', GNIP.constants.DEFAULT_SEARCH_IN_DAYS).format(unit.dateFormat)} - #{moment().format(unit.dateFormat)}"

    it 'should adapt subheader to time bounds', ->
      opts = {min: 10000000, max: 20000000}
      unit.updateText(null, opts)
      expect(unit.$el.find('.subheader').text()).toBe "#{moment(opts.min).format(unit.dateFormat)} - #{moment(opts.max).format(unit.dateFormat)}"

  describe '#showHeader', ->
    it 'should only call show() if there is a non-zero count', ->
      spy = sinon.spy(unit, 'show')
      unit.showHeader(null, {data: [0, 0]})
      expect(spy.called).toBeFalsy()
      unit.showHeader(null, {data: [233, 342]})
      expect(spy.called).toBeTruthy()
