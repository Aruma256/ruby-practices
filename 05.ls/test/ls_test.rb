#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  def test_to_table
    assert_equal [], to_table([])
    assert_equal [['test']], to_table(['test'], column_count: 1)
    assert_equal [['test', nil, nil]], to_table(['test'], column_count: 3)
    assert_equal [%w[aa bb], %w[cc dd], %w[ee ff]], to_table(%w[aa bb cc dd ee ff], column_count: 2)
    assert_equal [%w[aa bb cc], %w[dd ee ff]], to_table(%w[aa bb cc dd ee ff], column_count: 3)
    assert_equal [%w[aa bb cc], %w[dd ee ff], ['gg', nil, nil]], to_table(%w[aa bb cc dd ee ff gg], column_count: 3)
    assert_equal [%w[. .conf a]], to_table(%w[. .conf a], column_count: 3)
    assert_equal [%w[ff ee dd], %w[cc bb aa]], to_table(%w[ff ee dd cc bb aa], column_count: 3)
  end

  def test_format_table_empty
    input = []
    expected = []
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_1_element
    input = [%w[a]]
    expected = ['a']
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_3_elements
    input = [%w[a b c]]
    expected = %w[
      a
      b
      c
    ]
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_7_elements_mixed_length
    input = [
      %w[a bb c],
      %w[d e fff],
      ['g', nil, nil]
    ]
    expected = [
      'a  d   g',
      'bb e',
      'c  fff'
    ]
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_12_elements_mixed_length
    input = [
      %w[a bb c d],
      %w[e ff gg hhh],
      %w[ii j k l]
    ]
    expected = [
      'a  e   ii',
      'bb ff  j',
      'c  gg  k',
      'd  hhh l'
    ]
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_5_columns
    input = [
      %w[a b c d],
      %w[e f g h],
      %w[i j k l],
      %w[m n o p]
    ]
    expected = [
      'a e i m',
      'b f j n',
      'c g k o',
      'd h l p'
    ]
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_start_with_dot
    input = [
      %w[. .config .hidden],
      %w[.zzz aaa b]
    ]
    expected = [
      '.       .zzz',
      '.config aaa',
      '.hidden b'
    ]
    assert_equal expected, convert_table_into_lines(input)
  end

  def test_format_table_3_elements_reversed
    input = [%w[c b a]]
    expected = %w[
      c
      b
      a
    ]
    assert_equal expected, convert_table_into_lines(input)
  end
end
