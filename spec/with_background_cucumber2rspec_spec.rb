require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'with background' do

  before do
    code = File.read File.dirname(__FILE__) + '/features/with_background.feature'
    @feature = Cucumber2RSpec::Feature.new code
  end

  it 'should be able to get the background code' do
    @feature.background.steps.length.should == 1
    @feature.background.steps.first.text.should == 'there are no dogs'
    @feature.background.steps.first.code.should == '@dogs.should(be_nil)'

    @feature.background.code.should == "  before do\n    @dogs.should(be_nil)\n  end"
  end

  it 'should print out the before block in the feature code' do
    @feature.code.should include("before do")
    @feature.code.should include(@feature.background.code)
    @feature.code.should include(@feature.scenarios[0].code) # and the first scenario's code
  end

end
