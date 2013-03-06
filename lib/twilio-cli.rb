require 'twilio-ruby'

sid   = ENV["TWILIO_ACCOUNT_SID"]
token = ENV["TWILIO_AUTH_TOKEN"]
sid   = ENV["TW_SID"]   if sid == nil 
token = ENV["TW_TOKEN"] if token == nil

if sid == nil || token == nil
  puts "Missing TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN environment variables."
  exit
end

client = Twilio::REST::Client.new sid, token

def has_keyword from, keywords
  result = false
  keywords.each do |key|
    result == result || from.includes?(key)
  end
  result
end

def get field
  if ARGV.include?(field)
    ARGV[ARGV.index(field)+1]
  end 
end

def get_or_ask field, question
  value = get field
  if value == nil
    print question
    value = $stdin.gets.chomp
  end
  value
end

if has_keyword ARGV, %w(list print show output tell get)
  to = get "to"
  from = get "from"
  max = get("limit").to_i

  max = 1000000 if max == 0

  if ARGV.include?("sms") || ARGV.include?("messages") || ARGV.include?("texts")
    puts "Listing messages"
    messages = client.account.sms.messages.list({to: to, from: from}) 
    max = messages.length if max == nil
    messages.first(max).each do |m|
      puts "#{m.from} => #{m.body}"
    end
  elsif ARGV.include?("calls")
    puts "Listing Calls"
    calls = client.account.calls.list({to: to, from: from})
    max = calls.length if max == nil
    calls.first(max).each do |c|
      puts "Call #{c.from} => #{c.to}"
      puts "\t #{c.start_time} for #{c.duration}s" if c.status != "no-answer"
      print "\t #{c.status}" 
      print " ($#{c.price})" if c.status != "no-answer"
      print "\n\n"
    end
  end
elsif ARGV.include?("send") || ARGV.include?("sms") || ARGV.include?("message") || ARGV.include?("text")
  puts "Sending an SMS"

  to = get_or_ask "to", "Message To:\t"
  from = get_or_ask "from", "Message From:\t"
  body = get_or_ask "body", "Message Body:\t"  

  mh = client.account.sms.messages.create({from: from, to: to, body: body})
  
  print "Refreshing Message Status"
  3.times { sleep(1); print "." }
  mh.refresh
  puts "Message was #{mh.status}"

elsif ARGV.include?("call") || ARGV.include?("dial")
  puts "Making a Call"

  to = get_or_ask "to", "Number to Dial:\t"
  from = get_or_ask "from", "Dial From:\t"
  action = get_or_ask "url", "Dial Action:\t"
 
  call = client.account.calls.create({to: to, from: from, url: action})
  print "Dialing"
  3.times { sleep(1); print "."}
  call.refresh
  puts "Call is #{call.status}"
end
