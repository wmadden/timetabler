# CSProblem.rb
# 
# Provides the CSProblem class.
# 
# William Madden, 29/01/10

module Timetabler

  # 
  # Defines a constraint-satisfaction problem and implements a recursive
  # backtracking search function to solve it.
  # 
  # Adapted from the algorithm in "Artificial Intelligence, A Modern
  # Approach" (Russel, Norvig).
  # 
  class CSProblem
    
    
    #-----------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #-----------------------------------------------------------------------------
    
    # 
    # Takes as parameters a hash of variable identifiers to arrays of values
    # they may take and an array of constraints that must be satisfied, as
    # Procs.
    # 
    def init( variables, constraints )
      @variables = variables || {}
      @constraints = constraints || []
      @assignments = {}
    end
    
    
    #-----------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #-----------------------------------------------------------------------------
    
  public
    
    attr_reader :assignments
    
    
    #-----------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #-----------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  solve
    #------------------------------
    
    # 
    # Wrapper function for rec_backtracking_search.
    # 
    def solve
      rec_backtracking_search
    end
    
  private
    
    #------------------------------
    #  rec_backtracking_search
    #------------------------------
    
    # 
    # Searches for a solution.
    # 
    def rec_backtracking_search
      return @assignment if assignment_complete?
      
      variable = select_unassigned_variable()
      values = order_domain_values( variable )
      
      for value in values do
        @assignments[ variable ] = value
        
        if not constraints_satisfied?
          @assignments.delete( variable )
          next
        end
        
        result = recursive_backtracking_search
        
        return result unless result.nil? # Success, return immediately
        
        @assignments.delete( variable )
      end
      
      # Failure, return nil
      nil
    end
    
    #------------------------------
    #  select_unassigned_variable
    #------------------------------
    
    # 
    # Chooses a variable to assign next.
    # 
    def select_unassigned_variable
      # TODO: heuristic
      
      # Choose first unassigned var
      variables = @variables.keys
      for variable in variables do
        break unless assignment.has_key( variable )
      end
      
      variable
    end
    
    #------------------------------
    #  order_domain_values
    #------------------------------
    
    # 
    # Orders the domain values of a variable such that the most valuable is
    # first and the least valuable last.
    # 
    def order_domain_values( variable )
      # TODO: heuristic
      @variables[ variable ]
    end
    
    #------------------------------
    #  constraints_satisfied?
    #------------------------------
    
    # 
    # Returns true if all constraints are satisfied, otherwise false.
    # 
    def constraints_satisfied?
      result = true
      
      for constraint in @constraints
        result = result and constraint.call( @variables )
      end
      
      result
    end
    
    #------------------------------
    #  assignment_complete?
    #------------------------------
    
    # 
    # Returns true if all variables have been assigned values, otherwise false.
    # 
    def assignment_complete?
      @assignment.length == @variables.length
    end
    
  end # END CLASS
end # END MODULE
