# FastOpenStruct

It was inspirated on [DynamicClass](https://github.com/amcaplan/dynamic_class) gem.

The main purpose of this gem is behave like an OpenStruct, but with some extra powers.

The main difference for OpenStruct is that this implementation has a cache of the methods that are created, so it is faster.

## Diferences from OpenStruct

- It is faster
- It has a cache of the methods that are created
- It does not uses @table instance variable
- It has a dig method that works like Hash#dig to access nested attributes
- It implements some methods of **ActiveModel::API** and **ActiveModel::Serialization**, making it useful for some cases (i.e. using it as :class for FactoryBot factories)
- It makes a deep initialization of the attributes, converting Hash to FastOpenStruct

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_open_struct'
```

And then execute:

    $ bundle

Or install it yourself as:
    
    $ gem install fast_open_struct


## Usage

```ruby
require 'fast_open_struct'

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

## Benchmarks
```
Initialization benchmark

Warming up --------------------------------------
          OpenStruct    15.041k i/100ms
      FastOpenStruct   116.264k i/100ms
Calculating -------------------------------------
          OpenStruct    152.606k (± 2.4%) i/s -    767.091k in   5.029398s
      FastOpenStruct      1.148M (± 1.4%) i/s -      5.813M in   5.063585s

Comparison:
      FastOpenStruct:  1148278.4 i/s
          OpenStruct:   152606.3 i/s - 7.52x  slower



Assignment Benchmark

Warming up --------------------------------------
          OpenStruct   682.010k i/100ms
      FastOpenStruct     1.972M i/100ms
Calculating -------------------------------------
          OpenStruct      6.980M (± 3.3%) i/s -     35.465M in   5.086554s
      FastOpenStruct     19.964M (± 0.8%) i/s -    100.582M in   5.038516s

Comparison:
      FastOpenStruct: 19964034.5 i/s
          OpenStruct:  6980499.3 i/s - 2.86x  slower



Access Benchmark

Warming up --------------------------------------
          OpenStruct     1.005M i/100ms
      FastOpenStruct     2.185M i/100ms
Calculating -------------------------------------
          OpenStruct     10.085M (± 0.5%) i/s -     51.245M in   5.081712s
      FastOpenStruct     21.798M (± 1.1%) i/s -    109.268M in   5.013290s

Comparison:
      FastOpenStruct: 21798290.7 i/s
          OpenStruct: 10084528.1 i/s - 2.16x  slower



All-Together Benchmark

Warming up --------------------------------------
          OpenStruct    12.918k i/100ms
      FastOpenStruct   111.460k i/100ms
Calculating -------------------------------------
          OpenStruct    127.875k (± 2.7%) i/s -    645.900k in   5.054749s
      FastOpenStruct      1.122M (± 1.1%) i/s -      5.684M in   5.066350s

Comparison:
      FastOpenStruct:  1122147.0 i/s
          OpenStruct:   127874.6 i/s - 8.78x  slower
```

## Contributing

Bug reports and pull requests are welcome on GitHub

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
