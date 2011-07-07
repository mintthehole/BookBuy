require 'spec_helper'

describe "imprints/show.html.erb" do
  before(:each) do
    @publisher = assign(:imprint, stub_model(Imprint,
      :code => "Code",
      :imprintname => "Imprintname",
      :group_id => 1,
      :publishername => "Publishername"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Imprintname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Publishername/)
  end
end