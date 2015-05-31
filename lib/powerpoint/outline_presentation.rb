module Powerpoint
  class OutlinePresentation < Presentation

    def slides
      data = Nokogiri::XML(File.read(presentation_filepath))
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
      data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst/p14:sldId")
    end

    def sections
      data = presentation_xml
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
      data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst").map do |section|
        Section.new(section)
      end
    end

  end
end