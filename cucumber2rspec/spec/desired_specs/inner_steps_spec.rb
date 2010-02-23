describe "Manage dogs" do

  it "Create a dog" do
    @dogs.should(be_nil)
    @your_mom = "Mommy"

    @dogs ||= []
    (@dogs << "A dog")
    @view = @dogs.inspect

    puts "our var: #{"foo"}"
    puts "before"
    puts "The dog says: #{"hello"}"
    puts "after"
  end

end
