#!/usr/bin/env ruby

def detect_new_entries(existing_enumerable:, new_enumerable:)
  new_enumerable.find_all do |new|
    !existing_enumerable.find_index do |existing|
      existing.include? new
    end
  end
end

if $0 == __FILE__
  if $*.length < 1
    print <<~EOF
      Usage: detect_new_entries.rb <new file> <existing file>

      Compares each line in new file to each line in existing file and returns lines
      in new file not contained in any line in existing file. Useful for 
      cross-referencing a big list of links to see if there are any missing.
    EOF
    exit 1
  end

  NEW_FILENAME = $*[0].freeze
  EXISTING_FILENAME = $*[1] || 'README.md'.freeze

  existing_entries = 
    open(EXISTING_FILENAME) do |f|
      f
        .read
        .scan(/\* .* (http.*)/)
        .map { |match| match[0] }
    end
  new_entries = 
    open(NEW_FILENAME) do |f|
      f.readlines(chomp: true)
    end
  
  puts detect_new_entries(
    existing_enumerable: existing_entries,
    new_enumerable: new_entries
  )
end
