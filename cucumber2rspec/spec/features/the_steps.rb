Given /^there are no dogs$/ do
  @dogs.should be_nil
end

Given /^your mom$/ do
  @your_mom = 'Mommy'
end

When /^I create a dog named "([^\"]*)"$/ do |name|
  puts "name is the name of the block argument above"
  @dogs ||= []
  @dogs << name
end

When /^I view all dogs$/ do
  @view = @dogs.inspect
end

Then /^your mom should see "([^\"]*)"$/ do |str|
  @your_mom.should_not be_nil
  @view.should_not     be_nil
  @view.should include(str)
end

Then /^your mom should not see "([^\"]*)"$/ do |str|
  @your_mom.should_not be_nil
  @view.should_not     be_nil
  @view.should_not include(str)
end

When /^I create a dog$/ do
  @dogs ||= []
  @dogs << 'A dog'
end

Then /^your mom should see a dog$/ do
  @your_mom.should_not be_nil
  @view.should_not be_nil
  @view.should include('A dog')
end
