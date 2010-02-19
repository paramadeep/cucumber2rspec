module Cucumber2RSpec #:nodoc:

  # ...
  class Scenario
    attr_reader :feature, :_scenario

    def initialize feature, cucumber_ast_scenario
      @feature   = feature
      @_scenario = cucumber_ast_scenario # Cucumber::Ast::Scenario
    end

    def name
      _scenario.name
    end

    def steps
      _scenario.instance_variable_get('@steps').map {|step| Step.new(self, step) }
    end

    def code_without_block
      code = Step.code_for_steps(steps)

      if background = feature.background
        # remove the background code from the scenario
        code = code.sub background.code_without_block.sub(/\n$/, ''), ''
      else
        code
      end
    end

    def code
      the_code = '  it ' + name.inspect + " do\n"
      the_code << code_without_block
      the_code << '  end'
    end
  end
end
