Gem::Specification.new do |s|
  s.name        = 'twilio-cli'
  s.version     = '0.0.3'
  s.date        = '2013-04-14'
  s.summary     = "Command Line Interface to the Twilio REST API"
  s.description = "A simple command line interface for sending text messages, and initiating outbound phone calls. Create a twilio account at Twilio.com and then set your system environemnt variables. Then you can include Twilio calls in your shell script or anywhere else you feel useful."
  s.authors     = ["Michael Wawra"]
  s.email       = 'wawra@twilio.com'
  s.files       = %w[
    lib/twilio-cli.rb
    lib/colourise.rb
    ]
  
  #Executables...
  s.executables = ["twilio"]
  s.default_executable = 'twilio'
  
  #Online shit...
  s.homepage    =
    'http://rubygems.org/gems/twilio-cli'
end
