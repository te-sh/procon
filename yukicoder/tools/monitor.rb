#! /usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'open-uri'
require 'pstore'
require 'listen'
require 'nokogiri'
require 'term/ansicolor'

DB_FILE = '/tmp/monitor-sample.db'

URL = 'http://yukicoder.me/problems/no/%d'

Dir.chdir('..')
DIRS = Dir.glob('*').grep(/\A\d+\z/)

FILE_REGEXP = /y(\d+)\.d/

Sample = Struct.new(:in, :out)

include Term::ANSIColor

def listen
  listener = Listen.to(*DIRS) do |modified, _added, _removed|
    modified.each do |file|
      create_child(file) if file.match?(FILE_REGEXP)
    end
  end

  listener.start
  sleep
end

def create_child(file)
  fork do
    run(file)
  end
end

def run(file)
  options = parse_options(file)
  get_samples(file).each do |sample|
    puts(cyan { "Run #{file}" })
    o, e, _s = Open3.capture3('rdmd', file, stdin_data: sample.in)

    puts(magenta { '===== Input =====' })
    print sample.in

    puts(magenta { '===== Output =====' })
    print o
    print e

    put_result(o, sample, options)
  end
end

def parse_options(file)
  options = {}
  File.open(file, 'r') do |f|
    f.each_line do |line|
      if line =~ %r{//\s+allowable-error:\s+(.*)}
        options[:allowable_error] = eval(Regexp.last_match.to_a[1])
      end
    end
  end
  options
end

def put_result(o, sample, options)
  if acceptable?(o, sample, options)
    puts(magenta { '===== Result =====' })
    puts(green { 'SUCCESS' })
  else
    puts(magenta { '===== Expected =====' })
    puts sample.out
    puts(magenta { '===== Result =====' })
    puts(red { 'FAILURE' })
  end
  puts
end

def acceptable?(o, sample, options)
  if options[:allowable_error]
    o.split(/\s+/).zip(sample.out.split(/\s+/)).all? do |n1, n2|
      (n1.to_f - n2.to_f).abs < options[:allowable_error]
    end
  else
    o == sample.out
  end
end

def get_samples(file)
  db = PStore.new(DB_FILE)
  db.transaction do
    if db[file]
      db[file]
    else
      db[file] = fetch_samples(file)
    end
  end
end

def fetch_samples(file)
  n = FILE_REGEXP.match(file).to_a[1].to_i
  open(URL % n) do |f|
    doc = Nokogiri::HTML.parse(f.read)
    divs = doc.css('div.sample')
    divs.map do |div|
      inout = div.css('pre').take(2).map(&:inner_html).map do |s|
        s.sub(/\A\n/, '').chomp + "\n"
      end
      Sample.new(*inout)
    end
  end
end

FileUtils.rm(DB_FILE, force: true)
listen
