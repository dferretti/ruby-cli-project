require 'thor'
require 'exif'

class ExifExtractor < Thor
  # https://github.com/rails/thor/issues/244
  def self.exit_on_failure? = true

  desc "process", "test NAME"
  def process(name = 'lol')
    puts "hello #{name}"
    begin
      data = Exif::Data.new(IO.read('images/gps_images/image_a.jpg'))
      puts geo_float(*data.gps_longitude).to_s + data.gps_longitude_ref
      puts geo_float(*data.gps_latitude).to_s + data.gps_latitude_ref
    rescue Exif::NotReadable => e # https://github.com/tonytonyjan/exif/issues/31
      puts e
    end
  end
  default_command :process

  private 
  # https://github.com/tonytonyjan/exif/issues/21
  def geo_float(degrees, minutes, seconds)
    degrees + minutes / 60.0 + seconds / 3600.0
  end

end

ExifExtractor.start(ARGV)
