# Masterman

**Unstable version**

Masterman is static data loader for Ruby.
It loads data from direct or file, and defines accessor to read attributes.

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
    attr_reader :id, :name
    mount path: '../prefecture.yml'
    has_many :shipping_costs
  end
end

class ShippingCost
  include Masterman

  masterman do 
    attr_reader :id, :price, prefecture_id
    mount path: '../shipping_cost.yml'
    belongs_to :prefecture
  end
end

ShippingCost.first.prefecture.is_a?(Prefecture)
ShippingCost.first.attributes # => { 'id' => ..., 'price' => ..., 'prefecture_id' => ... }
```

### Directly mount single data to class

```
class Administrator
  include Masterman

  masterman do 
    # Can not have association
    cattr_reader :email, :name
    class_mount path: '../prefecture.yml'
  end
end

Prefecture.email.present? # => true
```

### Select filetype of static data 

```
class Item
  include Masterman

  masterman do
    # You can use either loader
    # mount direct: [{ id: 1 }]
    # mount path: 'item.yml', loader: :yml
    # mount path: 'item.csv', loader: :csv
    # mount path: 'item.json', loader: :json
  end
end
```

### ActiveRecord-like associations

```
class Item
  include Masterman

  masterman do
    mount direct: [{ id: 1 }]
    belongs_to :user
    has_one :main_attachment
    has_many :variations
    has_many :attachments, through: :variations

    # Filter records by scope which is evaluated by using `#instance_exec`.
    has_many :odd_variations, -> { id % 2 == 1 }, source: :variations
  end
end
```

### Enable cache

When masterman loader called `.find` or `.all`, loader is not cached.
If you want to cache static data, call `.mount` with `cache: true`

```
class Item
  include Masterman

  masterman do
    mount path: 'item.yml', cache: true
  end
end
```

## TODO

- Support `has_and_belongs_to` association
- Should I support lazy loading?
- Support cache records.
- Validate options for association
- Try to install masterman to [pixivFACTORY](factory.pixiv.net)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
