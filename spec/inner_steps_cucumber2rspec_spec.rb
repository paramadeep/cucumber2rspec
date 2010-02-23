require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'basic' do

  before do
    code = File.read File.dirname(__FILE__) + '/features/inner_steps.feature'
    @feature = Cucumber2RSpec::Feature.new code
  end

  it 'should work' do
    pending
    scenario        = @feature.scenarios.first
    step_with_given = scenario.steps.last

    step_with_given.text.should == 'something with a given "foo"'

    desired_step_code = <<code
puts("our var: #{"foo"}")
puts("before")
puts("The dog says: #{"hello"}")
puts("after")
code

    step_with_given.code.strip.should == desired_step_code.strip
  end

end
