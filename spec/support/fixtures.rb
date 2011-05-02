module FixtureSpecHelpers

  def fixture(type)
    File.read(File.join(Reduction::ROOT, 'spec', 'fixtures', "#{type}.html"))
  end

end

RSpec.configure do |c|
  c.include FixtureSpecHelpers
end
