require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'basic' do

  before do
    code = File.read File.dirname(__FILE__) + '/features/table.feature'
    @feature = Cucumber2RSpec::Feature.new code
  end

  it 'should work' do
    scenario = @feature.scenarios.first
    table_step = scenario.steps[2]

    desired_step_code = <<code
require 'cucumber'
table = Cucumber::Ast::Table.new([["name", "breed"], ["Rover", "Golden Retriever"], ["Rex", "Boxer"]])
@dogs ||= []
table.hashes.each { |hash| (@dogs << "\#{hash["name"]}: \#{hash["breed"]}")
}
code

    table_step.has_table?.should == true
    table_step.table.raw.should == [["name", "breed"], ["Rover", "Golden Retriever"], ["Rex", "Boxer"]]
    table_step.text.should == 'I create the following dogs'
    table_step.code.strip.should == desired_step_code.strip
  end

end
