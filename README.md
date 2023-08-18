# Fast OpenStruct

[![FastOpenStruct CI](https://github.com/revelotech/fast_ostruct/actions/workflows/fast-ostruct_ci.yml/badge.svg)](https://github.com/revelotech/fast_ostruct/actions/workflows/fast-ostruct_ci.yml)
[![Gem Version](https://badge.fury.io/rb/fast_ostruct.svg)](https://badge.fury.io/rb/fast_ostruct)

It was inspired by [DynamicClass](https://github.com/amcaplan/dynamic_class) gem.

The main purpose of this gem is to behave like [OpenStruct](https://ruby-doc.org/stdlib-2.5.1/libdoc/ostruct/rdoc/OpenStruct.html), but with some extra powers.

## Motivation
It's well known that OpenStruct suffers with performance issues and it's its use is not advised by Rubocop by default. The main issue happens because for each attribute of the instance, it has to create each accessor dynamically.

With this in mind, FastOpenStruct was designed to solve this issue by caching the accessor methods created for each attribute for the first time. This way FastOpenStruct can be up to 40x faster.

## Diferences from OpenStruct

- It 40x is faster
- It has a cache of the methods that are created
- It does not uses @table instance variable
- It has a dig method that works like Hash#dig to access nested attributes
- It implements some methods of **ActiveModel::API** and **ActiveModel::Serialization**, making it useful for some cases (i.e. using it as :class for FactoryBot factories)
- It makes a deep initialization of the attributes, converting Hash into FastOpenStruct

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_ostruct'
```

And then execute:

    $ bundle

Or install it yourself as:
    
    $ gem install fast_ostruct


## Usage

```ruby
require 'fast_ostruct'

attributes = { name: 'John' }

my_struct = FastOpenStruct.new(attributes)

# Set attributes 
my_struct.nickname = 'Big John'
my_struct['lastname'] = 'Connor'
my_struct[:age] = 30

# Access attributes
my_struct.name # => 'John'
my_struct[:nickname] # => 'Big John'
my_struct['lastname'] # => 'Connor'
my_struct.dig(:age) # => 30
```

## Configuration

Create an initializer file and add the following code:
```ruby
FastOpenStruct.configure do |config|
  # default: true | it will make a deep initialization of the attributes, converting Hash into FastOpenStruct 
  config.initialize_options = { deep_initialize: true }
  
  # default: false | if true, it will symbolize the keys of the attributes
  config.attributes_options = { symbolize_keys: false }
end
```

## Benchmarks
```
Initialization benchmark

Warming up --------------------------------------
          OpenStruct     6.967k i/100ms
      FastOpenStruct    45.819k i/100ms
Calculating -------------------------------------
          OpenStruct     70.614k (± 4.4%) i/s -    355.317k in   5.042038s
      FastOpenStruct    454.480k (± 1.6%) i/s -      2.291M in   5.042112s

Comparison:
      FastOpenStruct:   454479.6 i/s
          OpenStruct:    70614.1 i/s - 6.44x  slower



Assignment Benchmark

Warming up --------------------------------------
          OpenStruct   317.626k i/100ms
      FastOpenStruct     1.413M i/100ms
Calculating -------------------------------------
          OpenStruct      3.222M (± 0.3%) i/s -     16.199M in   5.027118s
      FastOpenStruct     14.663M (± 1.0%) i/s -     73.465M in   5.010767s

Comparison:
      FastOpenStruct: 14662985.4 i/s
          OpenStruct:  3222330.4 i/s - 4.55x  slower



Access Benchmark

Warming up --------------------------------------
          OpenStruct   455.965k i/100ms
      FastOpenStruct     1.511M i/100ms
Calculating -------------------------------------
          OpenStruct      4.533M (± 3.2%) i/s -     22.798M in   5.034950s
      FastOpenStruct     15.154M (± 0.5%) i/s -     77.063M in   5.085386s

Comparison:
      FastOpenStruct: 15154237.8 i/s
          OpenStruct:  4533257.4 i/s - 3.34x  slower



All-Together Benchmark

Warming up --------------------------------------
          OpenStruct     5.084k i/100ms
      FastOpenStruct   218.702k i/100ms
Calculating -------------------------------------
          OpenStruct     52.705k (± 4.7%) i/s -    264.368k in   5.027437s
      FastOpenStruct      2.135M (± 4.1%) i/s -     10.716M in   5.028416s

Comparison:
      FastOpenStruct:  2135322.0 i/s
          OpenStruct:    52704.7 i/s - 40.51x  slower

```

## Caveats
Due to caching the methods, it's expected that the application will consume more memory, which will be garbage-collected as soon as this object is not used.

## Contributing

Bug reports and pull requests are welcome on GitHub

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
