$LOAD_PATH.unshift File.dirname(__FILE__)

# Last tested with cucumber (0.3.11, 0.3.3

require 'rubygems'
require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby2ruby'
require 'cucumber'

Cucumber.load_language('en')

class Cucumber2RSpec

  def self.translate feature_text
    ""
  end

  class Feature
    attr_reader :raw, :name, :_feature

    def self.parser
      @parser ||= Cucumber::Parser::FeatureParser.new
    end

    def initialize raw_feature_text
      @raw      = raw_feature_text
      @_feature = Feature.parser.parse_or_fail(raw) # Cucumber::Ast::Feature
    end

    def name
      # @_feature.name returns "Feature: Foo\n  In order to ..."
      match = @_feature.name.match(/Feature: ([\w ]+)/)
      match[1] if match
    end

    def scenarios
      @_feature.instance_variable_get('@feature_elements').map {|scenario| Scenario.new(self, scenario) }
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
  end

end

# st.instance_eval { @feature_elements }.first.instance_eval { @steps }.first.to_sexp.last
# step_match('there are no dogs').instance_variable_get('@step_definition').instance_variable_get('@proc').to_ruby
