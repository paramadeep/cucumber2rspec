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

# ...
module Cucumber2RSpec

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

  def self.replace_in_sexp sexp, to_replace, replace_with
    while sexp.include?(to_replace)
      index = sexp.index(to_replace)
      sexp.delete_at index
      sexp.insert    index, replace_with
    end
    
    sexp.each do|obj|
      replace_in_sexp(obj, to_replace, replace_with) if obj.is_a?(Sexp)
    end

    sexp
  end

end

require 'cucumber2rspec/feature'
require 'cucumber2rspec/scenario'
require 'cucumber2rspec/step'
