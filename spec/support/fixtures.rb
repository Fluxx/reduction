module FixtureSpecHelpers

  def get_page(url)
    open(url).read
  end

end

RSpec.configure do |c|
  c.include FixtureSpecHelpers
end
