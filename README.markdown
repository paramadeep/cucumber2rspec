cucumber2rspec
==============

Convert Cucumber features to RSpec

Not yet complete!

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

We'll release more documentation when this is done and can convert a full feature suite  :)
