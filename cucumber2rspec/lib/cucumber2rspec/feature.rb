module Cucumber2RSpec #:nodoc:

  # ...
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
end
