describe 'ActivityMap', ->
  unit = undefined
  beforeEach ->
    unit = new ActivityMap($('<div class="activities-map" id="activities-map"></div>'))

  describe '#show', ->
    it 'should flip-in header if there is data', ->
      expect(unit.$el.hasClass('flip-in')).toBeFalsy()
      unit.show(null, {data: []})
      expect(unit.$el.hasClass('flip-in')).toBeFalsy()
      unit.show(null, {data: ['foo', 'bar']})
      expect(unit.$el.hasClass('flip-in')).toBeTruthy()
