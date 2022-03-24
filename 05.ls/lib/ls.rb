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
  # opt.on('-a') { glob_flags |= File::FNM_DOTMATCH }
  # opt.on('-r') { params[:r] = true }
  opt.on('-l') { params[:l] = true }
  opt.parse!(ARGV)
  filenames = Dir.glob('*', glob_flags)
  filenames.reverse! if params[:r]
  if params[:l]
    total_blocks = filenames.map { |filename| File::Stat.new(filename).blocks }.sum
    puts "total #{total_blocks}"
    table = to_long_table(filenames)
  else
    table = to_table(filenames)
  end
  lines = convert_table_into_lines(table)
  puts lines
end

def to_long_table(filenames)
  table = filenames.map do |filename|
    stat = File.lstat(filename)
    [
      to_permission_string(stat),
      stat.nlink,
      Etc.getpwuid(stat.uid).name,
      Etc.getgrgid(stat.gid).name,
      stat.size,
      stat.mtime.month,
      stat.mtime.day,
      stat.mtime.strftime('%H:%M'),
      stat.symlink? ? "#{filename} -> #{File.readlink(filename)}" : filename
    ]
  end
  table.transpose
end

def to_permission_string(stat)
  res = +''
  res << if stat.directory?
           'd'
         elsif stat.symlink?
           'l'
         else
           '-'
         end
  (-9..-1).each do |pos|
    res << if (stat.mode & (1 << (pos.abs - 1))).nonzero?
             PERMISSION_STRING[pos]
           else
             '-'
           end
  end
  res
end

def to_table(filenames, column_count: DEFAULT_COLUMN_COUNT)
  filenames << nil until filenames.length.modulo(column_count).zero?
  filenames.each_slice(column_count).to_a
end

def convert_table_into_lines(table)
  table.map! do |row|
    max_length = row.compact.map { |elem| elem.to_s.length }.max
    row.map do |element|
      if element.is_a?(Integer)
        element.to_s.rjust(max_length)
      else
        element&.ljust(max_length)
      end
    end
  end
  table.transpose.map do |row|
    row.join(' ').strip
  end
end

main if __FILE__ == $PROGRAM_NAME # テスト時にmainが実行されることを避ける
