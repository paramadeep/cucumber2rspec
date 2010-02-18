require File.dirname(__FILE__) + '/spec_helper'

describe Cucumber2RSpec, 'all translations' do

  Dir[File.dirname(__FILE__) + '/desired_specs/*_spec.rb'].each do |spec_file|
    name = File.basename(spec_file).sub(/_spec\.rb$/, '')
    feature_text = File.read File.join(File.dirname(__FILE__), 'features', "#{name}.feature")
    desired_code = File.read(spec_file).strip

    it "#{name} feature should convert to the desired #{name} rspec code" do
      spec_text = Cucumber2RSpec.translate(feature_text)
      if spec_text != desired_code
        puts "Desired:\n#{ desired_code }"
        puts "Got:\n#{ spec_text }"
      end
      spec_text.should == desired_code
    end

  end

end

# translate
# translate_file
# translate_directory (?)
