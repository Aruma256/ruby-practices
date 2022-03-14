#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

DEFAULT_COLUMN_COUNT = 3

def main
  target_path = ARGV[0] ? Pathname.new(ARGV[0]) : Pathname.getwd
  filenames = target_path.glob('*').map { |item| item.basename.to_s }
  table = to_table(filenames)
  lines = convert_table_into_lines(table)
  puts lines
end

def to_table(filenames, column_count: DEFAULT_COLUMN_COUNT)
  filenames << nil until filenames.length.modulo(column_count).zero?
  filenames.each_slice(column_count).to_a
end

def convert_table_into_lines(table)
  table.map! do |row|
    max_length = row.compact.map(&:length).max
    row.map do |element|
      element&.ljust(max_length)
    end
  end
  table.transpose.map do |row|
    row.join(' ').strip
  end
end

main if __FILE__ == $PROGRAM_NAME # テスト時にmainが実行されることを避ける
