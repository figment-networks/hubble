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

  collection :items, type: CollectionTest
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
          ]
        }
      end

      it 'assigns attributes' do
        expect(resource.id).to eq 1
        expect(resource.name).to eq 'test'
        expect(resource.count).to eq 12345
        expect(resource.count_with_default).to eq 100
        expect(resource.time).to be_a Time

        expect(resource.items).to be_a Array
        expect(resource.items[0].id).to eq 2
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
        items
      ]
    end
  end
end
