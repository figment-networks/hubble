require 'rails_helper'

class BasicResourceTest < Common::Resource
  attr_accessor :id, :name
end

class CollectionTest < Common::Resource
  field :id
end

class ResourceTest < Common::Resource
  field :id
  field :name
  field :count, type: :integer
  field :count_with_default, type: :integer, default: 100
  field :time, type: :timestamp
  field :modified_name, source: 'modifiedName'

  collection :items, type: CollectionTest
end

class InheritedResourceTest < ResourceTest
  field :data
  field :count, type: :string
end

describe Common::Resource do
  let(:resource_class) { ResourceTest }
  let(:resource)       { resource_class.new(attrs) }

  describe '#initialize' do
    context 'without field definitions' do
      let(:resource_class) { BasicResourceTest }

      let(:attrs) do
        {
          id: 1,
          'name' => 'test'
        }
      end

      it 'assigns attributes' do
        expect(resource.id).to eq 1
        expect(resource.name).to eq 'test'
      end
    end

    context 'with defined fields' do
      let(:attrs) do
        {
          'id' => 1,
          'name' => 'test',
          'count' => '12345',
          'time' => '2020-07-17T15:02:10-05:00',
          'items' => [
            { 'id' => 2 }
          ],
          'extra_param' => true,
          'modifiedName' => 'value'
        }
      end

      it 'assigns attributes' do
        expect(resource.id).to eq 1
        expect(resource.name).to eq 'test'
        expect(resource.count).to eq 12345
        expect(resource.count_with_default).to eq 100
        expect(resource.time).to be_a Time
        expect(resource.modified_name).to eq 'value'

        expect(resource.items).to be_a Array
        expect(resource.items[0].id).to eq 2
      end

      it 'does not handle undefined fields' do
        expect { resource.extra_param }.to raise_error NoMethodError
      end
    end

    context 'with inheritance' do
      let(:resource_class) { InheritedResourceTest }

      let(:attrs) do
        {
          'id' => 1,
          'name' => 'test',
          'count' => '12345',
          'time' => '2020-07-17T15:02:10-05:00',
          'items' => [
            { 'id' => 2 }
          ],
          'extra_param' => true,
          'data' => 12345
        }
      end

      it 'assigns attributes' do
        expect(resource.id).to eq 1
        expect(resource.name).to eq 'test'
        expect(resource.count).to eq '12345'
        expect(resource.count_with_default).to eq 100
        expect(resource.time).to be_a Time
        expect(resource.data).to eq 12345

        expect(resource.items).to be_a Array
        expect(resource.items[0].id).to eq 2
      end

      it 'does not handle undefined fields' do
        expect { resource.extra_param }.to raise_error NoMethodError
      end
    end
  end

  describe '.field_names' do
    it 'returns the field names' do
      expect(resource_class.field_names).to eq %i[
        id
        name
        count
        count_with_default
        time
        modified_name
        items
      ]
    end
  end

  describe '.mapping' do
    it 'returns field mapping' do
      expect(BasicResourceTest.mapping).to eq nil
      expect(ResourceTest.mapping.keys).to eq %i[id name count count_with_default time modified_name items]
      expect(InheritedResourceTest.mapping.keys).to eq %i[id name count count_with_default time modified_name items data]
    end
  end
end
