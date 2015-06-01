require 'nokogiri'
require 'pry'
require 'zip'

require 'powerpoint/presentation'
require 'powerpoint/slide'
require 'powerpoint/section'
require 'powerpoint/outline_presentation'
require 'powerpoint/presentation_merger'

require 'powerpoint/filesystem/content_types'
require 'powerpoint/filesystem/presentation_relationships'
require 'powerpoint/filesystem/presentation'

module Powerpoint

  def self.decompress in_path, out_path
    Zip::File.open(in_path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(out_path, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
  end

  def self.compress in_path, out_path
    Zip::File.open(out_path, Zip::File::CREATE) do |zip_file|
      Dir.glob("#{in_path}/**/*", ::File::FNM_DOTMATCH).each do |path|
        zip_path = path.gsub("#{in_path}/","")
        next if zip_path == "." || zip_path == ".." || zip_path.match(/DS_Store/)
        begin
          zip_file.add(zip_path, path)
        rescue Zip::ZipEntryExistsError
          raise "#{out_path} allready exists!"
        end
      end
    end
  end

end