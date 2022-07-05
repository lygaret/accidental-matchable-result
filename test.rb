require 'minitest/mock'
require 'minitest/autorun'
require './accidental/matchable_result'

describe Accidental::MatchableResult do
  include Accidental::MatchableResult

  specify "success is a Success instance" do
    payload = Object.new
    result  = success(payload)

    assert_kind_of Dry::Monads::Result, result
    assert result.success?
    assert_equal result.value!, payload
  end

  specify "failure with no exception is a Failure instance" do
    result = failure(:error_code)

    assert_kind_of Dry::Monads::Result, result
    assert result.failure?
    assert_equal result.failure, :error_code
    assert_equal result.key, :error_code
    assert_nil result.exception
  end

  specify "failure with an exception is a Failure instance" do
    result = begin
      raise 'oh no'
    rescue => ex
      failure(:error_code, ex)
    end

    assert_kind_of Dry::Monads::Result, result
    assert result.failure?
    assert_equal result.failure, :error_code
    assert_equal result.key, :error_code
    assert_kind_of RuntimeError, result.exception
    assert_equal 'oh no', result.exception.message
  end

  describe "pattern matching" do
    specify "success" do
      result = success("whatever")

      assert (result in { success: value })
      assert_equal "whatever", value
    end

    specify "failure with no exception" do
      result = failure(:error_code)

      assert (result in { failure:, exception: nil })
      assert (result in { failure: value })
      assert_equal value, :error_code
    end

    specify "failure with an exception" do
      error  = StandardError.new "oh no"
      result = failure(:error_code, error)

      assert (result in { failure: })
      refute (result in { failure:, exception: nil })
      assert (result in { failure:, exception: })
      assert_equal failure, :error_code
      assert_equal exception, error
    end
  end
end

