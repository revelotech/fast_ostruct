# Fast OpenStruct

[![FastOpenStruct CI](https://github.com/revelotech/fast_ostruct/actions/workflows/fast-ostruct_ci.yml/badge.svg)](https://github.com/revelotech/fast_ostruct/actions/workflows/fast-ostruct_ci.yml)
[![Gem Version](https://badge.fury.io/rb/fast_ostruct.svg)](https://badge.fury.io/rb/fast_ostruct)

It was inspired by [DynamicClass](https://github.com/amcaplan/dynamic_class) gem.

The main purpose of this gem is to behave like [OpenStruct](https://ruby-doc.org/stdlib-2.5.1/libdoc/ostruct/rdoc/OpenStruct.html), but with some extra powers.

## Motivation
It's well known that OpenStruct suffers with performance issues and its use [is not advised by Rubocop by default](https://docs.rubocop.org/rubocop-performance/cops_performance.html#performanceopenstruct). The main issue happens because for each attribute of the instance, it has to create each accessor dynamically.

With this in mind, FastOpenStruct was designed to solve it by caching the accessor methods created for each attribute on the first time. This way FastOpenStruct can be up to 40x faster.

## Diferences from OpenStruct

- It is 40x faster
- It has a cache of the methods that are created
- It does not uses @table instance variable
- It comes with `dig` method that works like Hash#dig to access nested attributes
- It comes with `slice` method to slice attributes from FastOpenStruct
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

# INITIALIZATION

my_struct = FastOpenStruct.new(name: 'John')


# ASSIGNMENT 

my_struct.nickname = 'JD'
my_struct['lastname'] = 'Doe'
my_struct[:age] = 30


# ACCESS 

my_struct.name 
# => 'John'
my_struct[:nickname] 
# => 'JD'
my_struct['lastname'] 
# => 'Doe'
my_struct.dig(:age) 
# => 30
my_struct.slice(:name, :age) 
# => { name: 'John', age: 30 }


# ATTRIBUTES HASH

my_struct.attributes 
# => { name: 'John', nickname: 'JD', lastname: 'Doe', age: 30 }

my_struct.attributes(symbolize_keys: true) 
# => { :name => 'John', :nickname => 'JD', :lastname => 'Doe', :age => 30 }

# alias for attributes method:
my_struct.to_h 
my_struct.as_json
my_struct.serializable_hash


# SERIALIZATION

my_struct.to_json 
# => "{\"name\":\"John\",\"nickname\":\"JD\",\"lastname\":\"Doe\",\"age\":30}"


# COMPARISON
 
struct_1 = FastOpenStruct.new(name: 'John')
struct_2 = FastOpenStruct.new(name: 'John')

struct_1 == struct_2 
# => true
struct_1.eql?(struct_2) 
# => true
```

## Configuration

It comes with some default configurations that can be replaced. In Rails applications, create an initializer `config/initializers/fast_ostruct.rb` and add the following code: 

```ruby
FastOpenStruct.configure do |config|
  config.initialize_options = {
    # It tells if it should make a deep initialization of the attributes, converting Hash to FastOpenStruct. Default: true 
    deep_initialize: true
  }
  
  config.attributes_options = { 
    # It tells if it should symbolize the keys of the attributes. Default: false
    symbolize_keys: false 
  }
end
```

## Benchmarks

### Initialization Benchmark
```
Warming up --------------------------------------
          OpenStruct     4.974k i/100ms
      FastOpenStruct    31.969k i/100ms
Calculating -------------------------------------
          OpenStruct     45.560k (± 8.3%) i/s -    223.830k in   5.058119s
      FastOpenStruct    322.596k (± 3.1%) i/s -      1.630M in   5.071891s
                  with 100.0% confidence

Comparison:
      FastOpenStruct:   322596.0 i/s
          OpenStruct:    45560.0 i/s - 7.09x  (± 0.68) slower
                  with 100.0% confidence
```
Shared at: https://ips.fastruby.io/62B


### Assignment Benchmark
```
Assignment Benchmark

Warming up --------------------------------------
          OpenStruct   286.228k i/100ms
      FastOpenStruct     1.380M i/100ms
Calculating -------------------------------------
          OpenStruct      2.758M (± 1.6%) i/s -     14.025M in   5.090527s
      FastOpenStruct     13.743M (± 2.5%) i/s -     69.012M in   5.031214s
                  with 100.0% confidence

Comparison:
      FastOpenStruct: 13742868.7 i/s
          OpenStruct:  2758336.0 i/s - 4.98x  (± 0.13) slower
                  with 100.0% confidence
```
Shared at: https://ips.fastruby.io/62C


### Access Benchmark
```
Warming up --------------------------------------
          OpenStruct   405.434k i/100ms
      FastOpenStruct     1.281M i/100ms
Calculating -------------------------------------
          OpenStruct      4.151M (± 1.0%) i/s -     21.083M in   5.080825s
      FastOpenStruct     12.749M (± 1.1%) i/s -     64.064M in   5.028477s
                  with 100.0% confidence

Comparison:
      FastOpenStruct: 12748892.6 i/s
          OpenStruct:  4151211.2 i/s - 3.07x  (± 0.05) slower
                  with 100.0% confidence
```
Shared at: https://ips.fastruby.io/62D


### All-Together Benchmark
```
Warming up --------------------------------------
          OpenStruct     4.765k i/100ms
      FastOpenStruct   191.309k i/100ms
Calculating -------------------------------------
          OpenStruct     46.667k (± 3.0%) i/s -    233.485k in   5.020000s
      FastOpenStruct      2.009M (± 1.9%) i/s -     10.139M in   5.054678s
                  with 100.0% confidence

Comparison:
      FastOpenStruct:  2008775.4 i/s
          OpenStruct:    46666.7 i/s - 43.04x  (± 1.60) slower
                  with 100.0% confidence
```
Shared at: https://ips.fastruby.io/62E


## Contributing

Bug reports and pull requests are welcome on GitHub

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
