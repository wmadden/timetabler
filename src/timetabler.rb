#!/usr/bin/env ruby


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
def search( subjects, timetable )
  
  # Succeed when all subjects are accommodated
  return timetable if subjects.length == 0
  
  # Take the first subject, search for streams that fit the current timetable
  subject = subjects.first
  
  # 
  for event in events
    for stream in streams
    end
  end
  
end

# Test
search ({  "Computer Design" => {
    "Lecture" => [
      # Stream 1
      [ [:Monday, 9], [:Wednesday, 9], [:Friday, 9] ],
      # Stream 2
      [ [:Monday, 11], [:Wednesday, 11], [:Friday, 11] ],
      # Stream 2
      [ [:Monday, 13], [:Wednesday, 13], [:Friday, 13] ]
    ]
  }
})
