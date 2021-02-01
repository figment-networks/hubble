module FixtureHelpers
  def visit_chain_dashboard_page
    prefix = chain.class.name.split('::').first.downcase
    slug   = chain.slug

    visit "/#{prefix}/chains/#{slug}/dashboard"
  end

  def json_fixture(path)
    JSON.load(file_fixture(path).read).with_indifferent_access
  end
end
