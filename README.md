# Masterman

Masterman is static data loader for Ruby.
It load data from direct or file, and defines accessor to read attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'masterman'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install masterman

## Usage

```
class Prefecture
  include Masterman

  masterman do 
    self.mount_options = { file: '../prefecture.yml', loader: :yml }
    has_many :shipping_costs
    attribute_accessor :id, :name
  end
end

class ShippingCost
  include Masterman

  masterman do 
    # Define master data with loader
    self.mount_options = { file: '../shipping_cost.yml', loader: :yml }

    # Define association like ActiveRecord
    belongs_to :prefecture

    # Define attribute keys
    attribute_accessor :id, :price, prefecture_id
  end
end

ShippingCost.first.prefecture.is_a?(Prefecture)
ShippingCost.first.attributes # => { 'id' => ..., 'price' => ..., 'prefecture_id' => ... }
```

### A few of loader

```
class Item
  include Masterman

  masterman do
    # You can use either loader
    # self.mount_options = { direct: [{ id: 1 }] }
    # self.mount_options = { file: 'item.yml', loader: :yml }
    # self.mount_options = { file: 'item.csv', loader: :csv }
    # self.mount_options = { file: 'item.json', loader: :json }
  end
end
```

### ActiveRecord-like associations

```
class Item
  include Masterman

  masterman do
    self.mount_options = { direct: [{ id: 1 }] }
    belongs_to :user
    has_one :main_attachment
    has_many :variations
    has_many :attachments, through: :variations

    # Scope is evaluate by using `#instance_exec` on each records
    has_many :odd_variations, -> { id % 2 == 1 }, source: :variations
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

