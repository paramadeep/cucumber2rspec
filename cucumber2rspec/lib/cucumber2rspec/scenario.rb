module Cucumber2RSpec #:nodoc:

  # ...
  class Scenario
    attr_reader :feature, :_scenario

    def initialize feature, cucumber_ast_scenario
      @feature   = feature
      @_scenario = cucumber_ast_scenario # Cucumber::Ast::Scenario
    end

    def name
      @_scenario.name
    end

    def steps
      @_scenario.instance_variable_get('@steps').map {|step| Step.new(self, step) }
    end

    def code
      puts "Generating for for #{ name.inspect }"
      groups = {
        'Given' => [],
        'When'  => [],
        'Then'  => []
      }

      steps.each do |step|
        groups[step.keyword] << step.code
      end

      the_code = '  it ' + name.inspect + " do\n"
      groups['Given'].each {|code| the_code << (code.indent(4) + "\n") }
      the_code << "\n" if groups['Given'].length > 0
      
      groups['When' ].each {|code| the_code << (code.indent(4) + "\n") }
      the_code << "\n" if groups['When'].length > 0

      groups['Then' ].each {|code| the_code << (code.indent(4) + "\n") }
      the_code << '  end'
    end
  end
end
