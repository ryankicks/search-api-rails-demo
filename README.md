![Gnip Search Demo](search-demo.gif)

## Purpose
Gnip has built this internal app on top of its Search API product for demo purposes,
in order to visually highlight the product's functionality and the type of interface
that Gnip customers could build into their products to leverage the Search API for
internal use or exposure to their clients.

## Setup
To run the application, you must set the following environment variables: `GNIP_ACCOUNT`, `GNIP_STREAM_NAME`, `GNIP_USERNAME`, and `GNIP_PASSWORD`

For the mapping feature, you must also set `MAPBOX_API_KEY` in [main.coffee](app/assets/javascripts/main.coffee) to your API key. You can get one at [mapbox.com](http://www.mapbox.com/).

## Development
This project depends on MRI 2.0.0 and Rails 4.0.0.

The demo works on browsers IE9+. Don't even try IE8, seriously, it's not pretty.

Running tests: `rake spec`
Running features: `rake cucumber`
Running Jasmine tests: `rake spec:javascript`

Guard will automatically run Cucumber, RSpec, and CoffeeScript transpiling; just run `guard`. Sorry, no auto-jasmine yet.

The app has source maps support so we can debug our CoffeeScript and Sass and minified jQuery.

To run, just execute `rails s`.

## Brought to you by:
* [https://github.com/eriwen](Eric Wendelin)
* [https://github.com/bkuhlmann](Brooke Kuhlmann)
* [https://github.com/calebdoxsey](Caleb Doxsey)

@ [http://gnip.com/](Gnip)
