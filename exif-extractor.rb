#!/usr/bin/env ruby
require 'csv'
require 'thor'
require 'exif'

class ExifExtractor < Thor
  # https://github.com/rails/thor/issues/244
  def self.exit_on_failure? = true

  desc 'process', 'collect exif gps data from all images in a specified glob pattern'
  option :input, :aliases => '-i', :type => :string, :default => './**/*', :desc => 'input glob pattern'
  option :output, :aliases => '-o', :type => :string, :desc => 'output file to write results to. writes to stdout if not set'
  option :force, :aliases => '-f', :type => :boolean, :default => false, :desc => 'force overwrite of existing file'
  option :format, :type => :string, :enum => ['csv', 'html'], :desc => 'output format, either csv or html. defaults to csv unless output file ends with .html'
  option :"fail-on-error", :type => :boolean, :default => false, :desc => 'fail if any file cannot be parsed for EXIF GPS data. defaults to false which skips bad files'
  option :quiet, :aliases => '-q', :type => :boolean, :default => false, :desc => 'whether to skip logging file parse errors to stderr'
  def process()
    
    if options[:force] && options[:output].nil?
      STDERR.puts 'cannot use --force without specifying --output'
      exit 1
    end

    data = Dir.glob(options[:input])
      .reject {|e| File.directory? e}
      .map {|f| read_file(f, options[:quiet])}

    STDERR.puts "Exiting due to error" or exit 1 if data.compact! && options[:"fail-on-error"]

    output =
      case get_format(options[:format], options[:output])
      when 'csv' then render_csv(data)
      when 'html' then render_csv(data) # TODO
      end

    options[:output] ?
      write_file(options[:output], output, options[:force]) :
      puts(output)

  end
  default_command :process

  private

  def get_format(format, output)
    format || output&.end_with?('.html') ? 'html' : 'csv'
  end

  def render_csv(rows)
    CSV.generate_lines(rows.map {|r| r.values}.prepend(['Filename', 'Latitude', 'Longitude']))
  end

  def write_file(target, output, force)
    unless File.exist?(target)
      File.write(target, output)
      return
    end

    unless force
      STDERR.puts "Cannot overwrite existing file #{target}. Use --force to overwrite."
      exit 1 # thor seems to not be able to set exit codes, so I manually exit here with an exit code
    end

    if File.directory?(target)
      STDERR.puts "Cannot force overwrite #{target} since it exists as a directory."
      exit 1
    end

    File.write(target, output)
  end

  # reads the file for EXIF GPS data. returns nil if unable to parse
  def read_file(file, quiet)
    data = Exif::Data.new(IO.read(file))
    return nil unless data.gps_longitude&.length == 3 && data.gps_latitude&.length == 3
    
    {
      file:,
      latitude: geo_float(*data.gps_latitude).to_s + data.gps_latitude_ref,
      longitude: geo_float(*data.gps_longitude).to_s + data.gps_longitude_ref,
    }
  rescue Exif::NotReadable => e # https://github.com/tonytonyjan/exif/issues/31
    STDERR.puts "#{e} File: #{file}" unless quiet
    nil
  end

  # https://github.com/tonytonyjan/exif/issues/21
  def geo_float(degrees, minutes, seconds)
    degrees + minutes / 60.0 + seconds / 3600.0
  end

end

ExifExtractor.start(ARGV)
