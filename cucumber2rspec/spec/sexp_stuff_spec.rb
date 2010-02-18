require File.dirname(__FILE__) + '/spec_helper'

describe 'Sexp stuff' do

  def do_stuff(sexp)
    Cucumber2RSpec.replace_in_sexp sexp, Sexp.new(:lvar, :name), Sexp.new(:str, "Rover")
  end

  it 'should be able to replace a local variable in a simple Sexp' do
    real    = ParseTree.new.process(proc { |name| puts name    }.to_ruby)
    desired = ParseTree.new.process(proc { |name| puts "Rover" }.to_ruby)

    real.should_not       == desired
    do_stuff(real).should == desired
  end

  it 'should be able to replace a local variable in a bigger Sexp' do
    real    = ParseTree.new.process(proc { |name| if 1 == 2 then name    end }.to_ruby)
    desired = ParseTree.new.process(proc { |name| if 1 == 2 then "Rover" end }.to_ruby)

    real.should_not       == desired
    do_stuff(real).should == desired
  end

  it 'should be able to replace a local variable in a even bigger Sexp' do
    real = ParseTree.new.process(proc { |name|
      if name.include?('hi')
        puts 'w00t ' + name + "includes 'hi'"
      else
        puts name + " does not include 'hi'"
      end
    }.to_ruby)

    desired = ParseTree.new.process(proc { |name|
      if "Rover".include?('hi')
        puts 'w00t ' + "Rover" + "includes 'hi'"
      else
        puts "Rover" + " does not include 'hi'"
      end
    }.to_ruby)

    real.should_not       == desired
    do_stuff(real).should == desired
  end

  # creating the desired result fails for this one because ParseTree takes "hi #{"String"}" 
  # and squishes them down into "hi String" which is kind of ideal but it's not super 
  # easy to reproduce so I'd like to hold off on trying to implement that!
  it 'should be able to replace a local variable in a interpolated string' do
    real    = ParseTree.new.process(proc { |name| puts "the name is: #{ name }"    }.to_ruby)

    do_stuff(real)
    
    Ruby2Ruby.new.process(real).should == 'proc { |name| puts("the name is: #{"Rover"}") }'

    #real.should_not       == desired
    #do_stuff(real).should == desired
  end

  it "should be able to get the names of a block's block variables" do
    Cucumber2RSpec.block_variable_names(proc {               puts "hi" }).should == []
    Cucumber2RSpec.block_variable_names(proc {|hi|           puts "hi" }).should == [:hi]
    Cucumber2RSpec.block_variable_names(proc {|hi, there|    puts "hi" }).should == [:hi, :there]
    Cucumber2RSpec.block_variable_names(proc {|hi, there, x| puts "hi" }).should == [:hi, :there, :x]
  end

end
