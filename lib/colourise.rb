module Colourise
  
  #We do not want to use method_missing because this is a module, not a class, and it will cause hell for everyone else.
  
  #Foreground colours...  
  { black: 30, red: 31, green: 32, yellow: 33, purple: 34, fuscia: 35, blue: 36, bold: 1, grey: 2, underline: 4, blink: 5}.each do |c,v|
     define_method("fg_"+c.to_s) { |text| colourize_text v, text }
  end
 
  {grey: 7, red: 41, green: 42, yellow: 43, purple: 44, fuscia: 45, blue: 46, white: 47}.each do |c,v|
    define_method("bg_"+c.to_s) { |text| colourize_text v, text }
  end
  
  #Single background block of colour for a symbolic letter. Useful in Lego based projects...
  def char_to_block c
    c = bg_white " " if c == "W"    
    c = bg_red " " if c == "R"    
    c = bg_green " " if c == "G"    
    c = bg_yellow " " if c == "Y"    
    c = bg_purple " " if c == "P"    
    c = bg_fuscia " " if c == "F"    
    c = bg_blue " " if c == "B"    
    c = bg_grey " " if c == "E"    
    c = " " if c == "x"
    c
  end
  
  def colourize_text colour, text
    "\e[#{colour}m#{text}\e[0m"
  end
end