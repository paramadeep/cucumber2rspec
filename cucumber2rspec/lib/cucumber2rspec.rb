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

  def self.translate_file filepath
    translate File.read(filepath)
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

  def self.block_variable_names a_proc
    sexp               = a_proc.to_sexp
    local_assignments  = []

    # this is where the variables hang out ...
    if sexp[2] and sexp[2].is_a?(Sexp)
      
      # there's only 1 local assigned variable
      if sexp[2][0] == :lasgn
        local_assignments << sexp[2][1]
        
      # there's an array of locally assigned variables
      elsif sexp[2][0] == :masgn and sexp[2][1][0] == :array # mass assignment using an array
        array_of_variables = a_proc.to_sexp[2][1]
        the_type           = array_of_variables.shift
        array_of_variables.each do |sub_sexp|
          local_assignments << sub_sexp[1] if sub_sexp[0] == :lasgn
        end
      end
    end

    local_assignments
  end

end

require 'cucumber2rspec/feature'
require 'cucumber2rspec/background'
require 'cucumber2rspec/scenario'
require 'cucumber2rspec/step'
