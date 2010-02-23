describe "Manage dogs" do

  it "Create a dog" do
    @dogs.should(be_nil)
    @your_mom = "Mommy"

    require 'cucumber'
    table = Cucumber::Ast::Table.new([["name", "breed"], ["Rover", "Golden Retriever"], ["Rex", "Boxer"]])
    @dogs ||= []
    table.hashes.each { |hash| (@dogs << "#{hash["name"]}: #{hash["breed"]}")
    }
    @view = @dogs.inspect

    @your_mom.should_not(be_nil)
    @view.should_not(be_nil)
    @view.should(include("Rover: Golden Retriever"))
  end

end
