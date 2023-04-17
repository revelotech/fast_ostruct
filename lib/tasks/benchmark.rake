# frozen_string_literal: true

require 'benchmark/ips'
require 'fast_ostruct'
require 'ostruct'

# rubocop:disable Style/OpenStructUse
namespace :fast_open_struct do
  desc 'Run Benchmarking Examples'
  task :benchmark do
    puts "Initialization benchmark\n\n"
    Benchmark.ips do |x|
      input_hash = { foo: :bar, bar: :baz, baz: :foo }

      x.report('OpenStruct') do
        OpenStruct.new(input_hash)
      end
      x.report('FastOpenStruct') do
        FastOpenStruct.new(input_hash)
      end
      x.compare!
    end

    puts "\n\nAssignment Benchmark\n\n"
    Benchmark.ips do |x|
      os = OpenStruct.new
      fos = FastOpenStruct.new

      x.report('OpenStruct') do
        os.foo = :bar
        os.bar = :baz
        os.baz = :foo
      end
      x.report('FastOpenStruct') do
        fos.foo = :bar
        fos.bar = :baz
        fos.baz = :foo
      end
      x.compare!
    end

    puts "\n\nAccess Benchmark\n\n"
    Benchmark.ips do |x|
      input_hash = { foo: :bar, bar: :baz, baz: :foo }
      os = OpenStruct.new(input_hash)
      fos = FastOpenStruct.new(input_hash)

      x.report('OpenStruct') do
        os.foo
        os.bar
        os.baz
      end
      x.report('FastOpenStruct') do
        fos.foo
        fos.bar
        fos.baz
      end
      x.compare!
    end

    puts "\n\nAll-Together Benchmark\n\n"
    Benchmark.ips do |x|
      x.report('OpenStruct') do
        os = OpenStruct.new
        os.foo = :bar
        os.foo
        os.bar = :baz
        os.bar
        os.baz = :foo
        os.baz
      end
      x.report('FastOpenStruct') do
        fos = FastOpenStruct.new
        fos.foo = :bar
        fos.foo
        fos.bar = :baz
        fos.bar
        fos.baz = :foo
        fos.baz
      end
      x.compare!
    end
  end
end
# rubocop:enable Style/OpenStructUse
