# Installation

To install this gem, you currently need to build it locally. I have not yet got all the desired features working, but once I do, I'll post it to ruby gems.

Clone the repositoy locally:

```
$ git clone https://github.com/xmjw/twilio-cli.git
```

Build the gem:

```
$ cd twilio-cli
$ gem build twilio-cli.gemspec
  Successfully built RubyGem
  Name: twilio-cli
  Version: 0.0.3
  File: twilio-cli-0.0.3.gem
```

Now install the gem locally.

```
$ gem install ./twilio-cli-0.0.3.gem 
Successfully installed twilio-cli-0.0.3
1 gem installed
Installing ri documentation for twilio-cli-0.0.3...
Installing RDoc documentation for twilio-cli-0.0.3...
```

Configure your Account SID and Auth Token in your environment, probably ~/.bash_profile:

```
export TWILIO_ACCOUNT_SID="oooooooooooooooooooooooooooooooooo"
export TWILIO_AUTH_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

Boom. Celebrate! SMS.

## Usage

Twilio-CLI attempts to be as natural to language as possible.

### Instructions


```
$ twilio list sms 
```
Lists all messages or texts send with your account. You can also use 'text' or 'messages' in place of sms.

```  
$ twilio list my numbers
```

Lists numbers that currently belong to your account.

```
$ twilio list calls
```

Lists all calls made with your account.
  
```
$ twilio call
```

Makes an outbound call. Requires a To, From and URL. Will ask for them if they are not provided.

```
$ twilio sms
```

Sends an outbound SMS. Requires a To, From, and URL.
  
```
$ twilio buy <number>
```

Attempts to buy a specified number.  
    
### Modifiers:
  
```  
to +15555555555
```    

The number a call or message is or was to. Can be used for filtering 'list'

```
from +15555555555
```

The number a call or message is or was from. Can be used for filtering 'list'
  
```
body "Hello, world!"
```

The body text for an sms.

```
url "http://example.com"
```    

The URL for an outbound call.
