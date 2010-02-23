require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'all translations' do

  Dir[File.dirname(__FILE__) + '/desired_specs/*_spec.rb'].each do |spec_file|
    name = File.basename(spec_file).sub(/_spec\.rb$/, '')
    feature_text = File.read File.join(File.dirname(__FILE__), 'features', "#{name}.feature")
    desired_code = File.read(spec_file).strip

    unless name == 'inner_steps'
      it "#{name} feature should convert to the desired #{name} rspec code" do
        spec_text = Cucumber2RSpec.translate(feature_text)
        if spec_text != desired_code
          puts "Desired:\n#{ desired_code }"
          puts "Got:\n#{ spec_text }"

          # check the lines so we fail on the first non-matching line
          desired_code.length.times do |i|
            desired_code.split("\n")[i].should == spec_text.split("\n")[i]
          end
        end
        spec_text.should == desired_code
      end
    end

  end

end

# translate
# translate_file
# translate_directory (?)
