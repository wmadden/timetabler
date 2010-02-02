#!/usr/bin/ruby


require 'rubygems'
require 'mechanize'
require 'codes'

def get_subjects(query)
  agent = WWW::Mechanize.new
  page = agent.get "https://sis.unimelb.edu.au/cgi-bin/subjects.pl"
  search_form = page.forms.last

  search_form.field_with(:name => "scodes").value = query
  search_results = agent.submit(search_form)
  return search_results.body
end



((@subject_codes.length / 100)+1).times do |x|
  y = x * 100
  puts y
  File.open("damnyou_#{x}.html","w") do |f|
    f.write get_subjects( @subject_codes[y..(y+100)].join("\n"))
  end
end
