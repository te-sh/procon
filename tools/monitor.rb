#! /usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'listen'

ROOT = File.absolute_path(File.join(__dir__, '..'))

# Tester with online-judge-tool
class OjTester
  DIRS = %w[abc yukicoder].freeze

  def listen
    dirs = DIRS.map { |dir| File.join(ROOT, dir) }
    listener = Listen.to(*dirs) do |modified, added, _removed|
      [modified, added].flatten.each do |file|
        run_test(file)
      end
    end

    listener.start
    sleep
  end

  def run_test(file)
    tokens = file.sub(ROOT, '').split('/')[1..-1]
    site = tokens.shift

    download_test(site, tokens) if @prev_file != file
    compile(site, file)
    test

    @prev_file = file
  end

  def download_test(site, tokens)
    url = case site
          when 'abc'
            abc_url(tokens)
          when 'yukicoder'
            yukicoder_url(tokens)
          end
    p url
    FileUtils.rm_r('test') if File.exist?('test')
    system "oj download #{url}"
  end

  def abc_url(tokens)
    format 'http://abc%s.contest.atcoder.jp/tasks/abc%s_%s',
           tokens[0],
           tokens[0],
           File.basename(tokens[1], '.d').tr('a-d', '1-4')
  end

  def yukicoder_url(tokens)
    format 'https://yukicoder.me/problems/no/%d',
           File.basename(tokens[1], '.d')[1..-1].to_i
  end

  def compile(site, file)
    options = case site
              when 'abc'
                '-m64 -w -O -release -inline'
              when 'yukicoder'
                '-m64 -w -wi -O -release -inline'
              end
    system "dmd -ofa.out #{options} #{file}"
  end

  def test
    system 'oj test'
  end
end

Dir.chdir(File.join(__dir__, 'tmp'))
OjTester.new.listen
