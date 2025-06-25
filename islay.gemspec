$:.push File.expand_path("../lib", __FILE__)

require "islay/version"

Gem::Specification.new do |s|
  s.name        = "islay"
  s.version     = Islay::VERSION
  s.authors     = ["Luke Sutton", "Ben Hull"]
  s.email       = ["lukeandben@spookandpuff.com"]
  s.homepage    = "http://spookandpuff.com"
  s.summary     = "A Rails engine for website back-ends."
  s.description = %{
    This is a specialised engine used by Spook and Puff for bootstrapping
    websites that need an administration back-end. It is intended to take the
    place of a generic CMS. Instead it provides authentication, asset management,
    admin styles etc., but no 'content management'.

    Instead, any apps using this engine are expected to implement their own
    management logic.
  }

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails",                         "~> 6.1.7"
  s.add_dependency 'rails-observers',               "~> 0.1.5"
  s.add_dependency 'cells-rails',                   '~> 0.1.5'
  s.add_dependency "nokogiri",                      '~> 1.15'
  s.add_dependency "devise",                        '~> 4.9'
  s.add_dependency "devise_invitable",              "~> 2.0.9"
  s.add_dependency 'cancancan',                     '~> 3.4'
  s.add_dependency "responders",                    "~> 3.1"
  s.add_dependency "simple_form",                   "~> 5.3"
  s.add_dependency 'hamlit-rails',                  '~> 0.2.3'
  s.add_dependency 'cells-hamlit',                  '~> 0.2.0'
  s.add_dependency 'dartsass-sprockets',            '~> 3.2', '>= 3.2.1'
  # s.add_dependency "compass-rails",                 "~> 4.0"
  s.add_dependency "pg",                            "~> 1.5"
  s.add_dependency "pg_search",                     "~> 2.3"
  s.add_dependency 'friendly_id',                   "~> 5.5"
  s.add_dependency "inherited_resources",           "~> 1.13"
  s.add_dependency "rmagick",                       "~> 5.3"
  s.add_dependency "mime-types",                    '~> 3.5'
  s.add_dependency "fog-aws",                       "~> 3.19"
  s.add_dependency "streamio-ffmpeg",               "~> 1.0"
  # s.add_dependency "zipruby",                       "~> 0.3.6"
  s.add_dependency "jquery-rails",                  "~> 4.6"
  s.add_dependency "jsonify-rails",                 "~> 0.3.2"
  s.add_dependency "kaminari",                      "~> 1.2"
  s.add_dependency 'rdiscount',                     '~> 2.2.7'
  s.add_dependency "acts_as_list",                  "~> 1.1"
  s.add_dependency "premailer",                     "~> 1.21"
  s.add_dependency 'draper',                        '~> 4.0'
  s.add_dependency 'bootsnap',                      '~> 1.16'
  s.add_dependency 'sprockets-rails',               '~> 3.4'
  s.add_dependency 'loofah',                        '~> 2.21'

  s.add_development_dependency 'listen'
end
