module Livepeer::GraphHelpers
  def stub_graph_query(query_class, fixture_name)
    allow_any_instance_of(query_class).to receive(:call) do
      load_json_fixture(fixture_name)[:data][fixture_name]
    end
  end

  def load_json_fixture(name)
    data = file_fixture("livepeer/#{name}.json").read
    JSON.parse(data).with_indifferent_access
  end
end
