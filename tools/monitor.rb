#! /usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'listen'

ROOT = File.absolute_path(File.join(__dir__, '..'))

# Tester with online-judge-tool
class OjTester
  DIRS = %w[abc yukicoder].freeze
  DENVS = { 'abc' => 'dmd-2.070.1', 'yukicoder' => 'dmd-2.076.0' }.freeze

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
    return if file.end_with?('#')
    tokens = file.sub(ROOT, '').split('/')[1..-1]
    site = tokens.shift

    download_test(file, site, tokens)
    compile(site, file)
    test

    @prev_file = file
  end

  def download_test(file, site, tokens)
    url = case site
          when 'abc'
            abc_url(file, tokens)
          when 'yukicoder'
            yukicoder_url(file, tokens)
          end
    puts "url: #{url}"
    return if @prev_url == url
    FileUtils.rm_r('test') if File.exist?('test')
    system "oj download #{url}"
    @prev_url = url
  end

  def abc_url(file, tokens)
    opts = abc_opts(file)
    problem = File.basename(tokens[1], '.d')
    path = if opts[:path]
             opts[:path]
           else
             format 'abc%s_%s',
                    tokens[0],
                    tokens[0] <= '019' ? problem.tr('a-d', '1-4') : problem
           end
    format 'http://abc%s.contest.atcoder.jp/tasks/%s',
           tokens[0],
           path
  end

  def abc_opts(file)
    opts = {}
    IO.foreach(file) do |line|
      if line =~ %r(// path: (.*))
        opts[:path] = Regexp.last_match[1]
      end
    end
    opts
  end

  def yukicoder_url(_file, tokens)
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

    system "denv local #{DENVS[site]}; dmd --version; dmd -ofa.out #{options} #{file}"
  end

  def test
    system 'oj test'
  end
end

Dir.chdir(File.join(__dir__, 'tmp'))
OjTester.new.listen
