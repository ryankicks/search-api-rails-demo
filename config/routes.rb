GnipSearchDemo::Application.routes.draw do
  root "search#show"
  match "activities", to: "search#activities", via: [:get, :post]
  match "counts", to: "search#counts", via: [:get, :post]
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
