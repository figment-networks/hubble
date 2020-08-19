module FixtureHelpers
  def json_fixture(path)
    JSON.load(file_fixture(path).read).with_indifferent_access
  end
end
