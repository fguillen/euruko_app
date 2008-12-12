describe "I18n" do
  
  it "should have a default locale" do
    I18n.default_locale.should_not be_empty
  end
  
end