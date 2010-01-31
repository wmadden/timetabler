# State.rb
# 
# Provides the State class.
# 
# William Madden, 29/01/10

module Timetabler

  # 
  # Defines a state in a CSProblem. That is, unassigned variables (and their
  # domains), assignments and the value of the state.
  # 
  class State
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    # 
    # Takes as parameters the variables and assignments of the state, and its
    # parent problem (to test constraint-satisfaction, goals etc.).
    # 
    # Upon construction, the state will estimate its value, automatically assign
    # variables whose domain contains only one value and check its consistency
    # against the problem constraints.
    # 
    def initialize( variables, assignments, problem )
      @variables = {}; @variables.replace( variables )
      @assignments = {}; @assignments.replace( assignments )
      @problem = problem
      
      # Check for single-value variables
      @variables.each_pair do |pair|
        variable = pair[0]
        domain = pair[1]
        
        if domain.length == 1 then assign( variable, domain[0] )
      end
    end
    
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
    attr_accessor :variables, :assignments
    
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  successors
    #------------------------------
    
    # 
    # Returns a list of successors to `state'.
    # 
    def successors
      result = []
      
      @variables.each_pair do |pair|
        variable = pair[0]
        domain = pair[1]
        
        # Generate successors by assigning to variable
        for value in domain
          # Create the successor state
          state = State.new( @variables, @assignments, @problem )
          # Assign the variable
          state.assign( variable, value )
          
          # Test constraints on successor
          next if not state.constraints_satisfied?
          
          result.push( successor )
        end
      end
      
      result
    end
    
    #------------------------------
    #  assign
    #------------------------------
    
    def assign( variable, value )
      @assignments[ variable ] = value
      @variables.delete( variable )
    end
    
    #------------------------------
    #  constraints_satisfied?
    #------------------------------
    
    # 
    # Returns true if all constraints are satisfied, otherwise false.
    # 
    def constraints_satisfied?
      # Check all unassigned variables have non-empty domains
      @variables.each_value do |domain|
        return false if domain.length == 0
      end
      
      # Test problem constraints
      result = true
      
      for constraint in @problem.constraints
        result = result && constraint.call( variables, assignments )
      end
      
      result
    end
    
    #------------------------------
    #  value
    #------------------------------
    
    def value
      # TODO
      return @assignments.length
    end
    
  end
  
end
