module Cucumber2RSpec #:nodoc:

  # ...
  class Background
    attr_reader :feature, :_background

    def initialize feature, cucumber_ast_background
      @feature   = feature
      @_background = cucumber_ast_background # Cucumber::Ast::Background
    end

    def steps
      _background.instance_variable_get('@steps').map {|step| Step.new(self, step) }
    end

    def code_without_block
      Step.code_for_steps(steps)
    end

    def code
      Cucumber2RSpec.log { '  Background' }
      the_code = "  before do\n"
      the_code << code_without_block.sub(/\n$/, '') # kill the last newline
      the_code << '  end'
    end

  end

end
