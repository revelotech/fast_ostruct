# frozen_string_literal: true

RSpec.describe FastOpenStruct do
  let(:attributes) do
    {
      'name' => 'John',
      'age' => 30,
      'address' => {
        'street' => 'Main Street',
        'city' => 'New York',
        'state' => 'NY',
        'zip' => '10001'
      }
    }
  end

  describe '#initialize' do
    it 'creates an object with attributes' do
      object = described_class.new(name: 'John', age: 30)
      expect(object.name).to eq('John')
      expect(object.age).to eq(30)
    end

    it 'makes a deep conversion of Hashes into FastOpenStruct' do
      object = described_class.new(attributes)
      expect(object.address).to be_a(described_class)
    end

    context 'when deep_initialize is false' do
      it 'does not make a deep conversion of Hashes into FastOpenStruct' do
        object = described_class.new(attributes, deep_initialize: false)
        expect(object.address).to be_a(Hash)
      end
    end
  end

  describe '#as_json' do
    it 'returns a Hash representation of the object' do
      object = described_class.new(attributes)
      expect(object.as_json).to eq(attributes)
    end
  end

  describe '#to_h' do
    it 'returns a Hash representation of the object' do
      object = described_class.new(attributes)
      expect(object.to_h).to eq(attributes)
    end
  end

  describe '#attributes' do
    it 'returns a Hash representation of the object' do
      object = described_class.new(attributes)
      expect(object.attributes).to eq(attributes)
    end

    it 'returns a Hash representation of the object with symbolized keys' do
      object = described_class.new(attributes)
      expect(object.attributes(symbolize_keys: true)).to eq(
        {
          name: 'John',
          age: 30,
          address: {
            street: 'Main Street',
            city: 'New York',
            state: 'NY',
            zip: '10001'
          }
        }
      )
    end
  end

  describe '#serializable_hash' do
    it 'returns a Hash representation of the object' do
      object = described_class.new(attributes)
      expect(object.serializable_hash).to eq(attributes)
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the object' do
      object = described_class.new(attributes)
      expect(object.to_json).to eq(attributes.to_json)
    end
  end

  describe '#dig' do
    it 'returns the value of the object at the given path' do
      object = described_class.new(attributes)
      expect(object.dig(:address, :city)).to eq('New York')
    end
  end

  describe '#[]' do
    it 'returns the value of the object at the given key' do
      object = described_class.new(attributes)
      expect(object[:name]).to eq('John')
    end
  end

  describe '#[]=' do
    it 'sets the value of the object at the given key' do
      object = described_class.new
      object[:name] = 'John'
      expect(object[:name]).to eq('John')
    end
  end

  describe '#method_missing' do
    it 'returns the value of the object at the given key' do
      object = described_class.new(attributes)
      expect(object.name).to eq('John')
    end

    it 'sets the value of the object at the given key' do
      object = described_class.new
      object.name = 'John'
      expect(object.name).to eq('John')
    end
  end

  describe '#persisted?' do
    it 'returns false' do
      object = described_class.new
      expect(object.persisted?).to eq(false)
    end
  end

  describe '#save' do
    it 'returns self' do
      object = described_class.new
      expect(object.save).to eq(object)
    end
  end

  describe '#save!' do
    it 'returns self' do
      object = described_class.new
      expect(object.save!).to eq(object)
    end
  end

  describe '#create' do
    it 'returns self' do
      object = described_class.new
      expect(object.create).to eq(object)
    end
  end

  describe '#create!' do
    it 'returns self' do
      object = described_class.new
      expect(object.create!).to eq(object)
    end
  end

  describe '#update' do
    it 'returns self' do
      object = described_class.new
      expect(object.update).to eq(object)
    end
  end

  describe '#update!' do
    it 'returns self' do
      object = described_class.new
      expect(object.update!).to eq(object)
    end
  end

  describe '#destroy' do
    it 'returns self' do
      object = described_class.new
      expect(object.destroy).to eq(object)
    end
  end

  describe '#destroy!' do
    it 'returns self' do
      object = described_class.new
      expect(object.destroy!).to eq(object)
    end
  end

  describe '#reload' do
    it 'returns self' do
      object = described_class.new
      expect(object.reload).to eq(object)
    end
  end

  describe '#new_record?' do
    it 'returns true' do
      object = described_class.new
      expect(object.new_record?).to eq(true)
    end
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(FastOpenStruct::Config)
    end

    it 'sets the configuration' do
      described_class.configure do |config|
        config.initialize_options = { deep_initialize: false }
        config.attributes_options = { symbolize_keys: true }
      end

      expect(described_class.config.initialize_options).to eq({ deep_initialize: false })
      expect(described_class.config.attributes_options).to eq({ symbolize_keys: true })
    end
  end
end
