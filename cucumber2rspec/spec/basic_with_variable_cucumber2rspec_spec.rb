require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'basic with variable' do

  before do
    code = File.read File.dirname(__FILE__) + '/features/basic_with_variable.feature'
    @feature = Cucumber2RSpec::Feature.new code
  end

  it 'should be able to load up a feature and get its name' do
    @feature.name.should == 'Manage dogs'
  end

  it 'should be able to get the scenarios for a feature' do
    @feature.scenarios.length.should == 1
    @feature.scenarios.first.name.should == 'Create a dog'
  end

=begin
  it "Create a dog" do
    @dogs.should(be_nil)
    @your_mom = "Mommy"

    puts "name is the name of the block argument above"
    @dogs ||= []
    @dogs << "Rover"
    @view = @dogs.inspect

    @your_mom.should_not(be_nil)
    @view.should_not(be_nil)
    @view.should(include("A dog"))
  end
=end
  it 'should be able to get the code for a step' do
    scenario = @feature.scenarios.first

    scenario.steps[0].keyword.should == 'Given'
    scenario.steps[0].code.should    == '@dogs.should(be_nil)'
    scenario.steps[1].keyword.should == 'Given'
    scenario.steps[1].code.should    == '@your_mom = "Mommy"'

    step = scenario.steps[2]
    step.keyword.should        == 'When'
    step.regexp.should         == /^I create a dog named "([^\"]*)"$/
    step.text.should           == 'I create a dog named "Rover"'
    step.variable_names.should == [:name]
    step.matches.should        == { :name => "Rover" }
    step.code.should           == 'puts("name is the name of the block argument above")' + 
      "\n@dogs ||= []\n(@dogs << \"Rover\")" # <--- we strip spaces

    #scenario.steps[3].keyword.should == 'Then'
    #scenario.steps[3].code.should    == '@your_mom.should_not(be_nil)'
  end
end
