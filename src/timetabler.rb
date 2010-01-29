#!/usr/bin/env ruby

require "Timetabler/TimetableProblem"

include Timetabler

# 
# Search for a valid timetable given subject times.
# Subjects must be an hash in the form:
#   
#   {
#     subject_name => {
#       event_name => [
#         [ times ]
#       ]
#     }
#   }
# 
# E.g.,
# 
#   {
#     "Computer Design" => {
#       "Lecture" => [
#         # Stream 1
#         [ [:Monday, 9], [:Wednesday, 9], [:Friday, 9] ],
#         # Stream 2
#         [ [:Monday, 11], [:Wednesday, 11], [:Friday, 11] ],
#         # Stream 2
#         [ [:Monday, 13], [:Wednesday, 13], [:Friday, 13] ]
#       ]
#     }
#   }
#  
#  Upon success, the function will return a timetable as a hash, in the form
#  
#    {
#      time => [ subject_name, event_name ]
#    }
#   
def search( subjects )
  
  # Initialize a timetable problem and attempt to solve it.
  variables = Hash.new { |hash, key| hash[key] = [] }
  
  subjects.each_pair do | subject, events |
    events.each_pair do | event, streams |
    #  for stream in streams
    #    for time in stream
    #      variables[ time ] = [subject, event]
    #    end
    #  end
      
      variables[ [subject, event] ] = streams
    end
  end
  
  problem = TimetableProblem.new( variables )
  problem.solve!
end

# Test
puts search({
  "Computer Design" => {
    "L1" => [
      # Stream 1
      [ [:Monday, 9], [:Wednesday, 9], [:Friday, 9] ],
      # Stream 2
      [ [:Monday, 11], [:Wednesday, 11], [:Friday, 11] ],
      # Stream 2
      [ [:Monday, 13], [:Wednesday, 13], [:Friday, 13] ]
    ]
  },
  "Data on the Web" => {
    "L1" => [
      # Stream 1
      [ [:Monday, 9], [:Wednesday, 9], [:Friday, 9] ],
      # Stream 2
      [ [:Monday, 11], [:Wednesday, 11], [:Friday, 11] ],
      # Stream 2
      [ [:Monday, 13], [:Wednesday, 13], [:Friday, 13] ]
    ]
  }
}).inspect

