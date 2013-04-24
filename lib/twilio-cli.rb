require 'twilio-ruby'
require 'colourise'

module TwilioCli
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
        buy get_or_ask_any(%w(number buy purchase))
      elsif has_keyword params, %w(sms text message)
        sms get_or_ask_any(%w(to)), get_or_ask_any(%w(from)), get_or_ask_any(%w(body))
      elsif has_keyword params, %w(dial call ring phone)
        call get_or_ask_any(%w(to)), get_or_ask_any(%w(from)), get_or_ask_any(%w(url action))
      else
        puts fg_red("You didn't specify any parameters you noob. Sort your life out.")
      end
    end  
    
    def list
      if has_keyword @params, %w(sms text messages texts messages)
        list_sms get_any(%w(to)), get_any(%w(from)), get_any(%w(limit max maximum first))
      elsif has_keyword @params, %w(calls call dial dials)
        list_calls get_any(%w(to)), get_any(%w(from)), get_any(%w(limit max maximum first))
      elsif has_keyword @params, %w(my)
        list_incoming get_any(%w(limit max maximum first))
      elsif has_keyword @params, %w(did number numbers)
        list_available get_or_ask_any(%w(country in iso)), get_any(%w(limit max maximum first)), get_any(%w(like query searh similar))
      end
    end
    
    def has_keyword from, keywords
      result = false
      keywords.each do |key|
        result = result || from.include?(key)
      end
      result
    end

    def get_any from
      result = nil
      @params.each do |key|
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
        value =   ask (question)
      end
      value
    end

    def ask question
      print fg_bold(question)
      $stdin.gets.chomp
    end
    
    def get_or_ask_any keywords
      result = get_any keywords
      result = get_or_ask(@params,keywords.first, "Please specifiy #{keywords.first}\t:") if result == nil
      result
    end

    def list_available country, limit, query
      numbers = @client.account.available_phone_numbers.get(country.upcase).local.list(
        :contains => query
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
end
