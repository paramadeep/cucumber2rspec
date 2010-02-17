require File.dirname(__FILE__) + '/../lib/cucumber2rspec'
require File.dirname(__FILE__) + '/features/the_steps'

# TODO create a matcher that will show you the line(s) that don't match between 2 big strings (when it fails)
#      or just the 1st non-matching string

describe Cucumber2RSpec do

  describe 'basic' do

    before do
      code = File.read File.dirname(__FILE__) + '/features/basic.feature'
      @feature = Cucumber2RSpec::Feature.new code
      @desired_code = <<code
  it "Create a dog" do
    @dogs.should(be_nil)
    @your_mom = "Mommy"

    @dogs ||= []
    (@dogs << "A dog")
    @view = @dogs.inspect

    @your_mom.should_not(be_nil)
    @view.should_not(be_nil)
    @view.should(include("A dog"))
  end
code
    end

    it 'should be able to load up a feature and get its name' do
      @feature.name.should == 'Manage dogs'
    end

    it 'should be able to get the scenarios for a feature' do
      @feature.scenarios.length.should == 1
      @feature.scenarios.first.name.should == 'Create a dog'
    end

    it 'should be able to get the steps for a scenario' do
      scenario = @feature.scenarios.first
      scenario.name.should == 'Create a dog'

      scenario.steps.first.keyword.should   == 'Given'
      scenario.steps.first.text.should      == 'there are no dogs'
      scenario.steps.first.full_text.should == 'Given there are no dogs'
    end

    it 'should be able to get the code for a step' do
      scenario = @feature.scenarios.first

      scenario.steps[0].keyword.should == 'Given'
      scenario.steps[0].code.should    == '@dogs.should(be_nil)'

      scenario.steps[1].keyword.should == 'Given'
      scenario.steps[1].code.should    == '@your_mom = "Mommy"'

      scenario.steps[2].keyword.should == 'When'
      scenario.steps[2].code.should    == "@dogs ||= []\n(@dogs << \"A dog\")" # <--- we strip spaces
    end

    it 'should be able to get the code for a scenario' do
      scenario = @feature.scenarios.first

      desired_lines   = @desired_code.split("\n")
      generated_lines = scenario.code.split("\n")

      desired_lines.each_with_index do |desired_line, i|
        desired_line.should == generated_lines[i]
      end
    end

    it 'should be able to get the code for a feature' do
      @feature.code.should == %{describe "Manage dogs" do\n\n#{ @desired_code }\nend}
    end

    it 'should be able to override how the "it" block is written'

  end

  Dir[File.dirname(__FILE__) + '/desired_specs/*_spec.rb'].each do |spec_file|
    name = File.basename(spec_file).sub(/_spec\.rb$/, '')
    feature_text = File.read File.join(File.dirname(__FILE__), 'features', "#{name}.feature")
    desired_code = File.read(spec_file).strip

    it "#{name} feature should convert to the desired #{name} rspec code" do
      Cucumber2RSpec.translate(feature_text).should == desired_code
    end

  end

end

# translate
# translate_file
# translate_directory (?)
