#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative 'ReadDotEnv'

ios_root, output_path = ARGV
abort 'Usage: BuildSwiftPackageConfig.rb <app ios directory> <output JSON path>' unless ios_root && output_path

variables, = read_dot_env(File.expand_path(ios_root) + '/', escape_objc: false)
FileUtils.mkdir_p(File.dirname(output_path))
File.write(output_path, JSON.generate(variables), encoding: 'UTF-8')
