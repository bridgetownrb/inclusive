# frozen_string_literal: true

require "test_helper"

module Package
  module Math
    extend Inclusive::Public

    # This takes a number and multiplies it by one hundred.
    #
    # @param int [Integer]
    # @return [Integer]
    def multiply_by_100(int) = int * 100

    public_function :multiply_by_100 # optional, just here for testing purposes
  end

  module Ownership
    attr_accessor :owner

    def owner_classname
      owner.class.name
    end
  end
end

class TestInclusive < Minitest::Test
  include Inclusive

  def test_that_it_has_a_version_number
    refute_nil ::Inclusive::VERSION
  end

  # @return [Package::Math]
  packages def math = [Package::Math]

  def test_packages
    assert_equal 400, math.multiply_by_100(4)
  end

  def test_inline_packages
    my_math = packages[Package::Math]

    assert_equal 800, my_math.multiply_by_100(8)
    assert_equal my_math.method(:multiply_by_100).source_location,
                 Package::Math.method(:multiply_by_100).source_location
  end

  def test_public_module_function
    public_math = Inclusive.packages[Package::Math]

    assert_equal 1200, public_math.multiply_by_100(12)
  end

  def test_package_ownership
    bare_mod = Module.new do
      extend Package::Ownership
    end
    ownership = Inclusive.packages[Package::Ownership].tap { _1.owner = self }

    assert_equal "TestInclusive", ownership.owner_classname
    assert_equal "NilClass", bare_mod.owner_classname
  end
end
