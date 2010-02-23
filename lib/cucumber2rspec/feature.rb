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
      match = _feature.name.match(/Feature: ([\w ]+)/)
      match[1] if match
    end

    def background
      _background = _feature.instance_variable_get('@background')
      Background.new self, _background if _background
    end

    def scenarios
      _feature.instance_variable_get('@feature_elements').map {|scenario| Scenario.new(self, scenario) }
    end

    def code
      Cucumber2RSpec.log { name }
      the_code = 'describe ' + name.inspect + ' do' + "\n\n"
      the_code << background.code + "\n\n" if background
      scenarios.each {|scenario| the_code << scenario.code + "\n\n" }
      the_code << "end"
    end
  end
end
