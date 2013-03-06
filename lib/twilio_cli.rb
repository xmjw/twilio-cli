require 'twilio-ruby'

class TwilioCli
  include Colourise
  
  def initialize sid, token
    @client = Twilio::REST::Client.new sid, token
  end

  def parse params
    @params = params
    if has_keyword params, %w(list print show output tell get)
      list
    elsif has_keyword params, %w(buy purchase)
      buy param_of(%w(number buy purchase))
    elsif has_keyword params, %w(sms text message)
      sms param_of(%w(to)), param_of(%w(from)), param_of(%w(body))
    elsif has_keyword params, %w(dial call ring phone)
      call param_of(%w(to)), param_of(%w(from)), param_of(%w(url action))
    end
  end  
    
  def list
    if has_keyword params, %w(sms text messages texts messages)
      list_sms param_of(%w(to)), param_of(%w(from)), param_of(%w(limit max maximum first))
    elsif has_keyword params, %w(calls call dial dials)
      list_calls param_of(%w(to)), param_of(%w(from)), param_of(%w(limit max maximum first))
    elsif has_keyword params, %w(my)
      list_available param_of(%w(to country iso)), param_of(%w(limit max maximum first))
    elsif has_keyword params, %w(did number numbers)
      list_incoming param_of(%w(limit max maximum first))
    end
  end
    
  def has_keyword from, keywords
    result = false
    keywords.each do |key|
      result = result || from.include?(key)
    end
    result
  end

  def param_of keywords
    get_any @params,keywords
  end

  def get_any from, keywords
    result = nil
    keywords.each do |key|
      if from.include?(key)
        result = from[from.index(key)+1]
      end
    end
    result
  end

  def get from, field
    if from.include?(field)
      from[from.index(field)+1]
    end 
  end

  def get_or_ask from, field, question
    value = get from, field
    if value == nil
      print bold(question)
      value = $stdin.gets.chomp
    end
    value
  end

  def list_available country, limit
    country = get_or_ask "in", "Country:\t"
    filter = get "like"
    filter = "" if filter == nil
    numbers = @client.account.available_phone_numbers.get(country).local.list(
      :contains => filter
    )
    numbers.each {|num| puts num.phone_number}
  end

  def list_incoming limit
    @client.account.incoming_phone_numbers.list.each {|n| puts n.phone_number}
  end

  def list_sms to, from, limit
    puts "Listing messages"
    messages = @client.account.sms.messages.list({to: to, from: from}) 
    max = messages.length if max == nil
    messages.first(max).each do |m|
      puts "#{m.from} => #{m.body}"
    end
  end

  def list_calls to, from, limit
    puts fg_bold("Listing Calls")
    calls = @client.account.calls.list({to: to, from: from})
    calls.first(limit).each do |c|
      puts "Call #{c.from} => #{c.to}"
      puts "\t #{c.start_time} for #{c.duration}s" if c.status != "no-answer"
      print "\t #{c.status}" 
      print " ($#{c.price})" if c.status != "no-answer"
      print "\n\n"
    end
  end
 
  def buy number
    number = get_or_ask "number", "Number to Buy:\t"
    begin
      purchase = @client.account.incoming_phone_numbers.create(:phone_number => number)
      puts "Purchased "+number
    rescue
      puts "Sorry, could not buy "+number
    end
  end
 
  def sms to, from, body
    puts "Sending an SMS..."

    message = @client.account.sms.messages.create({from: from, to: to, body: body})

    print "Refreshing Message Status"
    
    3.times { sleep(0.3); print fg_green(".") }
    message.refresh
    
    status = "unknown"
    
    if message.status == "sent"
      status = fg_green(message.status)
    elsif message.status == "queued"
      status = fg_yellow(message.status)
    else
      status = fg_red(message.status)
    end
    
    puts "Message Status: #{status}"
  end

  def call to, from, url
    puts "Making a Call"
    call = @client.account.calls.create({to: to, from: from, url: action})
    print "Dialing"
    3.times { sleep(0.3); print "."}
    call.refresh
    puts "Call is #{call.status}"
  end
end
