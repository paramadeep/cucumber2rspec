$LOAD_PATH.unshift File.dirname(__FILE__)

# Last tested with cucumber (0.3.11, 0.3.3
#
# Note: String#indent comes from cucumber

require 'rubygems'
require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby2ruby'
require 'cucumber'

$step_match = method(:step_match)

class Cucumber2RSpec

  def self.parser
    Cucumber.load_language('en')
    @parser ||= Cucumber::Parser::FeatureParser.new
  end

  def self.step_match text
    $step_match.call(text)
  end

  def self.translate feature_text
    Cucumber2RSpec::Feature.new(feature_text).code
  end

  class Feature
    attr_reader :raw, :name, :_feature

    def initialize raw_feature_text
      @raw      = raw_feature_text
      @_feature = Cucumber2RSpec.parser.parse_or_fail(raw) # Cucumber::Ast::Feature
    end

    def name
      # @_feature.name returns "Feature: Foo\n  In order to ..."
      match = @_feature.name.match(/Feature: ([\w ]+)/)
      match[1] if match
    end

    def scenarios
      @_feature.instance_variable_get('@feature_elements').map {|scenario| Scenario.new(self, scenario) }
    end

    def code
      the_code = 'describe ' + name.inspect + ' do' + "\n\n"
      scenarios.each {|scenario| the_code << scenario.code + "\n" }
      the_code << "\nend"
    end
  end

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

# st.instance_eval { @feature_elements }.first.instance_eval { @steps }.first.to_sexp.last
# step_match('there are no dogs').instance_variable_get('@step_definition').instance_variable_get('@proc').to_ruby
