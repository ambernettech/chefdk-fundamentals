module Powerpoint
  class Presentation
    def initialize(source_filepath)
      @target_filepath = source_filepath.gsub(".pptx","")
      Powerpoint::decompress(source_filepath,@target_filepath)
    end

    attr_reader :target_filepath

    def presentation_filepath
      "#{target_filepath}/ppt/presentation.xml"
    end

    def presentation_xml
      Nokogiri::XML(File.read(presentation_filepath))
    end

    def slides
      data = Nokogiri::XML(File.read(presentation_filepath))
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
      data.xpath("//p:sldIdLst").children
    end

  end
end