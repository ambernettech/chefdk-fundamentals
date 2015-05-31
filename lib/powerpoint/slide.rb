module Powerpoint
  class Slide
    def initialize(presentation_section_slide_xml)
      @xml = presentation_section_slide_xml
    end

    attr_reader :xml
  end
end