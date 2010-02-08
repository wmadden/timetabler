#!/usr/bin/ruby


require 'rubygems'
#require 'mechanize'
#require 'codes'

#def get_subjects(query)
#  agent = WWW::Mechanize.new
#  page = agent.get "https://sis.unimelb.edu.au/cgi-bin/subjects.pl"
#  search_form = page.forms.last

#  search_form.field_with(:name => "scodes").value = query
#  search_results = agent.submit(search_form)
#  return search_results.body
#end



#((@subject_codes.length / 100)+1).times do |x|
#  y = x * 100
#  puts y
#  File.open("damnyou_#{x}.html","w") do |f|
#    f.write get_subjects( @subject_codes[y..(y+100)].join("\n"))
#  end
#end


crazy_regex = /<td><\/td><td>(\d\d\d\d\d\d)<\/td><td>([A-Z]*)(\d\d)\/(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><\/tr>/


subjects = Hash.new # { |hash, key| hash[key] = Hash.new() }


for file in Dir["scraped_info/*"]
  data = IO.read(file)
  data = data.scan(crazy_regex)
  
  for entry in data
    subject = entry[0]
    event = entry[1]
    event_number = entry[2]
    stream = entry[3]
    time = "#{entry[4]} #{entry[5]}"
    #puts "subject = '#{subject}', event = '#{event}', stream = '#{stream}', time = '#{time}'"
    subjects[ subject ] ||= {}
    subjects[ subject ][ event ] ||= {}
    subjects[ subject ][ event ][ stream ] ||= []
    subjects[ subject ][ event ][ stream ] << time
  end
end
