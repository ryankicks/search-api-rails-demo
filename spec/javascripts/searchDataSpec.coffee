describe 'SearchData', ->
  unit = undefined
  requests = undefined
  xhr = undefined

  beforeEach ->
    unit = new SearchData()
    requests = []
    xhr = sinon.useFakeXMLHttpRequest()
    xhr.onCreate = (xhr) -> requests.push(xhr)

  afterEach ->
    xhr.restore()

  describe '#search', ->
    it 'should POST to given url', ->
      unit.search('/counts?q=foobar', sinon.spy())
      expect(requests[0].method).toBe 'POST'
      expect(requests[0].url).toBe '/counts?q=foobar'
      requests[0].respond(200, { "Content-Type": "application/json" }, '{data:[]}')

  describe '#loadChartDataFor', ->
    it 'should search the /counts endpoint', ->
      unit.loadChartDataFor('q=baz', sinon.spy())
      expect(requests[0].method).toBe 'POST'
      expect(requests[0].url).toBe '/counts?q=baz'
      requests[0].respond(200, { "Content-Type": "application/json" }, '{data:[]}')

  describe '#loadActivitiesFor', ->
    it 'should search the /activities endpoint', ->
      unit.loadActivitiesFor('q=baz', sinon.spy())
      expect(requests[0].method).toBe 'POST'
      expect(requests[0].url).toBe '/activities?q=baz'
      requests[0].respond(200, { "Content-Type": "application/json" }, '{data:[]}')
