#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class WcTest < Minitest::Test
  def to_stat(lines, words, bytes)
    {
      lines: lines,
      words: words,
      bytes: bytes
    }
  end

  def test_stat
    assert_equal to_stat(0, 0, 0), stat('')
    assert_equal to_stat(0, 3, 5), stat('a b c')
    assert_equal to_stat(1, 4, 7), stat("a\nb\tc d")
    assert_equal to_stat(1000, 1000, 2000), stat("a\n" * 1000)
  end

  def test_to_formatted_string
    assert_equal '       1       2       3', to_formatted_string(to_stat(1, 2, 3))
    assert_equal '    1000    2000    3000', to_formatted_string(to_stat(1000, 2000, 3000))
    assert_equal '       1       4       7 abc.txt', to_formatted_string(to_stat(1, 4, 7), name: 'abc.txt')
    assert_equal '       5', to_formatted_string(to_stat(5, nil, nil), only_lines: true)
    assert_equal '      10 total', to_formatted_string(to_stat(10, 40, 70), name: 'total', only_lines: true)
  end
end
