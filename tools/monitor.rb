#! /usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'listen'

ROOT = File.absolute_path(File.join(__dir__, '..'))

# Tester with online-judge-tool
class OjTester
  DENVS = {
    'abc' => 'dmd-2.070.1',
    'arc' => 'dmd-2.070.1',
    'yukicoder' => 'dmd-2.077.1'
  }.freeze
  DIRS = DENVS.keys

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
    url = get_url(file, site, tokens)
    puts "url: #{url}"
    return if @prev_url == url
    FileUtils.rm_r('test') if File.exist?('test')
    system "oj download #{url}"
    @prev_url = url
  end

  def get_url(file, site, tokens)
    opts = get_opts(file)
    return opts[:url] if opts.key?(:url)
    case site
    when 'abc'
      abc_url(tokens, opts)
    when 'arc'
      arc_url(tokens, opts)
    when 'yukicoder'
      yukicoder_url(tokens, opts)
    end
  end

  def get_opts(file)
    opts = {}
    IO.foreach(file) do |line|
      if line =~ %r{// url: (.*)}
        opts[:url] = Regexp.last_match[1]
      elsif line =~ %r{// path: (.*)}
        opts[:path] = Regexp.last_match[1]
      end
    end
    opts
  end

  def abc_url(tokens, opts)
    num = tokens[0]
    problem = File.basename(tokens[1], '.d')
    problem_c = num <= '019' ? problem.tr('a-d', '1-4') : problem
    path = if opts[:path]
             opts[:path]
           else
             format 'abc%s_%s', num, problem_c
           end
    format 'http://abc%s.contest.atcoder.jp/tasks/%s', num, path
  end

  def arc_url(tokens, opts)
    num = tokens[0]
    problem = File.basename(tokens[1], '.d')
    problem_c = num <= '034' ? problem.tr('a-d', '1-4') : problem
    path = if opts[:path]
             opts[:path]
           else
             format 'arc%s_%s', num, problem_c
           end
    format 'http://arc%s.contest.atcoder.jp/tasks/%s', num, path
  end

  def yukicoder_url(tokens, _opts)
    num = File.basename(tokens[1], '.d')[1..-1].to_i
    format 'https://yukicoder.me/problems/no/%d', num
  end

  def compile(site, file)
    options = d_options(site)
    set_denv = "denv local #{DENVS[site]}"
    system "#{set_denv}; dmd --version; dmd -ofa.out #{options} #{file}"
  end

  def d_options(site)
    case site
    when 'abc', 'arc'
      '-m64 -w -O -release -inline'
    when 'yukicoder'
      '-m64 -w -wi -O -release -inline'
    end
  end

  def test
    system 'oj test'
  end
end

Dir.chdir(File.join(__dir__, 'tmp'))
OjTester.new.listen
