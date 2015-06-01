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
      data.xpath("//p:sldIdLst/p:sldId")
    end

    def highest_slide_id
      slide_id_list = presentation_xml.xpath("//p:sldIdLst")

      slide_id_list.children.map do |slide_id|
         slide_id["id"].to_i
      end.max
    end

    def presentation_rels_filepath
      "#{target_filepath}/ppt/_rels/presentation.xml.rels"
    end

    def presentation_rels_xml
      Nokogiri::XML(File.read(presentation_rels_filepath))
    end

    def highest_relationship_id
      presentation_rels_xml.xpath("//xmlns:Relationship").map do |relationship|
        relationship["Id"].gsub("rId","").to_i
      end.compact.max
    end

    def merge(other_presentation)
      Powerpoint::PresentationMerger.new(self,other_presentation)
    end

  end
end