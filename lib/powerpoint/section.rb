module Powerpoint
  class Section
    def initialize(presentation_section_xml)
      @xml = presentation_section_xml
    end

    attr_reader :xml

    def slides
      xml.xpath("p14:sldId").map do |slide|
        Slide.new(slide)
      end
    end

  end
end