cucumber2rspec
==============

Convert Cucumber features to RSpec

Not yet complete!

We'll release more documentation when this is done and can convert a full feature suite  :)

So far, it supports:
 * multiple scenarios
 * steps with variables
 * cucumber tables
 * background steps

It does NOT yet support converting steps that are called from other steps.

Want to give this a try?

   $ bin/cucumber2rspec features/step_definitions/ features/a_feature.feature

If you checkout this repository, you can run:

   $ bin/cucumber2rspec spec/features/ spec/features/basic.feature

     D, [2010-02-23T13:41:41.846603 #21639] DEBUG -- : Loading steps ...
     D, [2010-02-23T13:41:41.861924 #21639] DEBUG -- : Feature to convert: basic.feature
     D, [2010-02-23T13:41:41.862022 #21639] DEBUG -- : translate_file("spec/features/basic.feature")
     D, [2010-02-23T13:41:41.930773 #21639] DEBUG -- : Manage dogs
     D, [2010-02-23T13:41:41.930925 #21639] DEBUG -- :   Create a dog
     D, [2010-02-23T13:41:41.931052 #21639] DEBUG -- :     there are no dogs
     D, [2010-02-23T13:41:41.937212 #21639] DEBUG -- :     your mom
     D, [2010-02-23T13:41:41.942294 #21639] DEBUG -- :     I create a dog
     D, [2010-02-23T13:41:41.948894 #21639] DEBUG -- :     I view all dogs
     D, [2010-02-23T13:41:41.954708 #21639] DEBUG -- :     your mom should see a dog
     describe "Manage dogs" do
     
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
     
     end
