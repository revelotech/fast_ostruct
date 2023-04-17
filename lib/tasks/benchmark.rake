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
      input_hash = { foo: :bar }

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
      input_hash = { foo: :bar }
      os = OpenStruct.new(input_hash)
      fos = FastOpenStruct.new(input_hash)

      x.report('OpenStruct') do
        os.foo = :bar
      end
      x.report('FastOpenStruct') do
        fos.foo = :bar
      end
      x.compare!
    end

    puts "\n\nAccess Benchmark\n\n"
    Benchmark.ips do |x|
      input_hash = { foo: :bar }
      os = OpenStruct.new(input_hash)
      fos = FastOpenStruct.new(input_hash)

      x.report('OpenStruct') do
        os.foo
      end
      x.report('FastOpenStruct') do
        fos.foo
      end
      x.compare!
    end

    puts "\n\nAll-Together Benchmark\n\n"
    Benchmark.ips do |x|
      input_hash = { foo: :bar }

      x.report('OpenStruct') do
        os = OpenStruct.new(input_hash)
        os.foo = :bar
        os.foo
      end
      x.report('FastOpenStruct') do
        fos = FastOpenStruct.new(input_hash)
        fos.foo = :bar
        fos.foo
      end
      x.compare!
    end
  end
end
# rubocop:enable Style/OpenStructUse
