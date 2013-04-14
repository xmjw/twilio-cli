Gem::Specification.new do |s|
  s.name        = 'twilio-cli'
  s.version     = '0.0.2'
  s.date        = '2013-04-1`4'
  s.summary     = "Command Line Interface to the Twilio REST API"
  s.description = "A simple command line interface for sending text messages, and initiating outbound phone calls. Create a twilio account at Twilio.com and then set your system environemnt variables. Then you can include Twilio calls in your shell script or anywhere else you feel useful."
  s.authors     = ["Michael Wawra"]
  s.email       = 'wawra@twilio.com'
  s.files       = %w[
    lib/twilio_cli.rb
    lib/colourise.rb
    ]
  
  #Executables...
  s.executables = ["boom"]
  s.default_executable = 'boom'
  
  #Online shit...
  s.homepage    =
    'http://rubygems.org/gems/twilio-cli'
end
