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

  it "Create a named dog" do
    @dogs.should(be_nil)
    @your_mom = "Mommy"

    puts("name is the name of the block argument above")
    @dogs ||= []
    (@dogs << "Rover")
    @view = @dogs.inspect

    @your_mom.should_not(be_nil)
    @view.should_not(be_nil)
    @view.should(include("Rover"))
  end

end
