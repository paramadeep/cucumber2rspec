module Cucumber2RSpec #:nodoc:

  # ...
  class Step
    attr_reader :scenario, :_step

    def initialize scenario, cucumber_ast_step_invocation
      @scenario = scenario
      @_step    = cucumber_ast_step_invocation # Cucumber::Ast::StepInvocation
    end

    def keyword
      @_step.actual_keyword
    end

    def text
      @_step.to_sexp.last
    end

    def full_text
      "#{keyword} #{text}"
    end

    def _step_definition
      Cucumber2RSpec.step_match(text).instance_variable_get('@step_definition')
    end

    def code
      the_proc = _step_definition.instance_variable_get('@proc')
      the_proc.to_ruby.sub(/^proc \{\s+/, '').sub(/\s\}$/, '').gsub(/\n[ ]+/, "\n")
    end
  end
end
