describe "Manage dogs with background" do

  before do
    @dogs.should(be_nil)
  end

  it "Create a dog" do
    @your_mom = "Mommy"

    @dogs ||= []
    (@dogs << "A dog")
    @view = @dogs.inspect

    @your_mom.should_not(be_nil)
    @view.should_not(be_nil)
    @view.should(include("A dog"))
  end

end
