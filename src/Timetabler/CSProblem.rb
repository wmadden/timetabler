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
  # This implementation is modeled on a recursive depth-first search. Openings
  # have been left for heuristics to be added, which should speed up the search.
  # Worst case scenario (no solution) will still require searching all available
  # combinations.
  # 
  class CSProblem
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    # 
    # Takes as parameters a hash of variable identifiers to arrays of values
    # they may take and an array of constraints that must be satisfied, as
    # Procs.
    # 
    def initialize( variables, constraints, assignments = nil, fringe = nil )
      @variables = variables || @variables || {}
      @constraints = constraints || @constraints || []
      @assignments = assignments || @assignments || {}
      
      @fringe = fringe || @fringe || []
    end
    
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_reader :assignments
    
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  solve!
    #------------------------------
    
    # 
    # Wrapper for search implementations.
    # 
    def solve!
      #rec_backtracking_search
      iterative_search( @variables, @assignments )
    end
    
  private
    
    #------------------------------
    #  iterative_search
    #------------------------------
    
    def iterative_search( variables, assignments )
      
      state = [ nil, variables, assignments ]
      # Value state
      state[0] = value_state( state )
      
      # TODO: check this (we're ignoring @fringe...?)
      fringe = [ state ]
      
      # Note: keep fringe ordered
      puts fringe.inspect
      unless fringe.empty? || goal_state?( state )
        # Generate successor states
        successors = get_successors( state )
        puts "Successors = "
        puts successors.inspect
        
        # Add to fringe; order fringe
        fringe.push( successors )
        fringe.sort! { |a, b| a[0] <=> b[0] }
        puts
        puts fringe.inspect
        
        # Take last (highest-value) state in fringe
        state = fringe.pop
      end
      
      # state
    end
    
    #------------------------------
    #  rec_backtracking_search
    #------------------------------
    
    # 
    # Searches for a solution.
    # 
    def rec_backtracking_search
      
      return @assignments if assignment_complete?( @assignments, @variables )
      
      variable = select_unassigned_variable( @variables, @assignments )
      values = order_domain_values( variable )
      
      for value in values do
        assign( variable, value )
        
        if not constraints_satisfied?( @variables, @assignments, @constraints )
          unassign( variable )
          next
        end
        
        result = rec_backtracking_search
        
        return result unless result.nil? # Success, return immediately
        
        unassign( variable )
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
    def select_unassigned_variable( variables, assignments )
      # TODO: heuristic
      
      # Choose first unassigned var
      for variable in variables.keys
        break unless assignments.has_key?( variable )
        variable = nil
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
    def constraints_satisfied?( variables, assignments, constraints )
      result = true
      
      for constraint in constraints
        result = result && constraint.call( variables, assignments )
      end
      
      result
    end
    
    #------------------------------
    #  assignment_complete?
    #------------------------------
    
    # 
    # Returns true if all variables have been assigned values, otherwise false.
    # 
    def assignment_complete?( assignments, variables )
      assignments.length == variables.length
    end
    
    #------------------------------
    #  goal_state?
    #------------------------------
    
    # 
    # Returns true if the given state is a goal state (i.e. complete timetable).
    # 
    def goal_state?( state )
      assignments = state[1]; variables = state[2]
      assignment_complete?( assignments, variables )
    end
    
    #------------------------------
    #  assign
    #------------------------------
    
    # 
    # Assigns value to variable.
    # 
    def assign( variable, value )
      @assignments[ variable ] = value
    end
    
    #------------------------------
    #  unassign
    #------------------------------
    
    # 
    # Unassigns variable.
    # 
    def unassign( variable )
      @assignments.delete( variable )
    end
    
    #------------------------------
    #  get_successors
    #------------------------------
    
    # 
    # Returns a list of successors to `state'.
    # 
    def get_successors( state )
      value = state[0]; assignments = state[1]; variables = state[2]
      successors = []
      
      variable = select_unassigned_variable( variables, assignments )
      unless variable.nil?
        domain = variables[ variable ]
        variables = variables.delete( variable )
        
        # Generate successors by assigning to variable
        for d_value in domain
          # Assign value
          s_assignments = {}
          s_assignments[variable] = d_value
          
          # Test constraints on successor
          next unless constraints_satisfied?( variables, assignments,
            constraints )
          
          # Calculate value of successor
          successor = [ s_value, variables, s_assignments ]
          s_value = value_state( successor )
          
          successors.push( successor )
        end
        
        # Remove variable; choose the next one
        variable = select_unassigned_variable( variables, assignments )
      end
    end
    
    #------------------------------
    #  value_state
    #------------------------------
    
    # 
    # Returns the numerical value of a state.
    # 
    def value_state( state )
      assignments = state[2]
      value = assignments.length
    end
    
  end # END CLASS
end # END MODULE

