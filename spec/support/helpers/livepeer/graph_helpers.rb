module Livepeer::GraphHelpers
  def stub_graph_query(query_class)
    allow_any_instance_of(query_class).to receive(:call) do
      fixture_name = query_class.name.demodulize.delete_suffix('Query').underscore
      resource_name = fixture_name.to_s.camelize(:lower)

      json_fixture("livepeer/#{fixture_name}.json")[:data][resource_name]
    end
  end
end
