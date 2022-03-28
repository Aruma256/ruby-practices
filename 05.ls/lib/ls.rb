#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'pathname'

DEFAULT_COLUMN_COUNT = 3
PERMISSION_STRING = 'rwxrwxrwx'

def main
  glob_flags = 0
  params = {}
  opt = OptionParser.new
  opt.on('-a') { glob_flags |= File::FNM_DOTMATCH }
  opt.on('-r') { params[:r] = true }
  opt.on('-l') { params[:l] = true }
  opt.parse!(ARGV)
  filenames = Dir.glob('*', glob_flags)
  filenames.reverse! if params[:r]
  if params[:l]
    total_blocks = filenames.sum { |filename| File::Stat.new(filename).blocks }
    puts "total #{total_blocks}"
    print_as_list(filenames)
  else
    print_as_table(filenames)
  end
end

def print_as_list(filenames)
  puts to_list(filenames)
end

def print_as_table(filenames)
  table = to_table(filenames)
  lines = convert_table_into_lines(table)
  puts lines
end

def to_list(filenames)
  filenames.map do |filename|
    stat = File.lstat(filename)
    [
      to_permission_string(stat),
      stat.nlink.to_s.rjust(8),
      Etc.getpwuid(stat.uid).name.rjust(8),
      Etc.getgrgid(stat.gid).name.rjust(8),
      stat.size.to_s.rjust(8),
      stat.mtime.month.to_s.rjust(2),
      stat.mtime.day.to_s.rjust(2),
      stat.mtime.strftime('%H:%M'),
      (stat.symlink? ? "#{filename} -> #{File.readlink(filename)}" : filename).ljust(64)
    ].join(' ')
  end
end

def to_permission_string(stat)
  type = if stat.directory?
           'd'
         elsif stat.symlink?
           'l'
         else
           '-'
         end
  permissions = (-9..-1).map do |pos|
    (stat.mode & (1 << (pos.abs - 1))).nonzero? ? PERMISSION_STRING[pos] : '-'
  end
  type + permissions.join
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
