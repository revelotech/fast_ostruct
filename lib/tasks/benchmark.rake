# frozen_string_literal: true

require 'benchmark/ips'
require 'fast_ostruct'
require 'ostruct'

# rubocop:disable Style/OpenStructUse
namespace :fast_open_struct do
  desc 'Run Benchmarking Examples'

  task :initilization_benchmark do
    initilization_benchmark
  end

  task :assignment_benchmark do
    assignment_benchmark
  end

  task :access_benchmark do
    access_benchmark
  end

  task :all_together_benchmark do
    all_together_benchmark
  end

  def initilization_benchmark
    puts "Initialization benchmark\n\n"
    ENV['SHARE'] = '1'
    Benchmark.ips do |x|
      input_hash = { foo: :foo, bar: :bar, baz: :baz, qux: :qux }

      x.config(:stats => :bootstrap, :confidence => 100)
      x.report('OpenStruct') do
        OpenStruct.new(input_hash)
      end
      x.report('FastOpenStruct') do
        FastOpenStruct.new(input_hash)
      end
      x.compare!
      x.json! 'benchmark-initialization.json'
    end
  end

  def assignment_benchmark
    puts "\n\nAssignment Benchmark\n\n"
    ENV['SHARE'] = '1'
    Benchmark.ips do |x|
      os = OpenStruct.new
      fos = FastOpenStruct.new

      x.config(:stats => :bootstrap, :confidence => 100)
      x.report('OpenStruct') do
        os.foo = :foo
        os.bar = :baz
        os.baz = :baz
        os.qux = :qux
      end
      x.report('FastOpenStruct') do
        fos.foo = :foo
        fos.bar = :bar
        fos.baz = :baz
        fos.qux = :qux
      end
      x.compare!
      x.json! 'benchmark-assignment.json'
    end
  end

  def access_benchmark
    puts "\n\nAccess Benchmark\n\n"
    ENV['SHARE'] = '1'
    Benchmark.ips do |x|
      input_hash = { foo: :foo, bar: :bar, baz: :baz, qux: :qux }
      os = OpenStruct.new(input_hash)
      fos = FastOpenStruct.new(input_hash)

      x.config(:stats => :bootstrap, :confidence => 100)
      x.report('OpenStruct') do
        os.foo
        os.bar
        os.baz
        os.qux
      end
      x.report('FastOpenStruct') do
        fos.foo
        fos.bar
        fos.baz
        fos.qux
      end
      x.compare!
      x.json! 'benchmark-access.json'
    end
  end

  def all_together_benchmark
    puts "\n\nAll-Together Benchmark\n\n"
    ENV['SHARE'] = '1'
    Benchmark.ips do |x|
      x.config(:stats => :bootstrap, :confidence => 100)
      x.report('OpenStruct') do
        os = OpenStruct.new
        os.foo = :foo
        os.foo
        os.bar = :bar
        os.bar
        os.baz = :baz
        os.baz
        os.qux = :qux
        os.qux
      end
      x.report('FastOpenStruct') do
        fos = FastOpenStruct.new
        fos.foo = :foo
        fos.foo
        fos.bar = :bar
        fos.bar
        fos.baz = :baz
        fos.baz
        fos.qux = :qux
        fos.qux
      end
      x.compare!
      x.json! 'benchmark-all.json'
    end
  end
end
# rubocop:enable Style/OpenStructUse
