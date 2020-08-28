module Livepeer::GraphHelpers
  def stub_graph_query(query_class, fixture_name)
    allow_any_instance_of(query_class).to receive(:call) do
      resource = fixture_name.to_s.camelize(:lower)
      load_json_fixture(fixture_name)[:data][resource]
    end
  end

  def load_json_fixture(name)
    data = file_fixture("livepeer/#{name}.json").read
    JSON.parse(data).with_indifferent_access
  end
end
