module Powerpoint
  # outline_presentation.merge(presentation).into(section: section_number, after: { slide: 1 })
  class PresentationMerger

    def initialize(source_presentation,other_presentation)
      @source_presentation = source_presentation
      @other_presentation = other_presentation
    end

    attr_reader :source_presentation, :other_presentation

    alias_method :outline_presentation, :source_presentation
    alias_method :presentation, :other_presentation

    def into(options)
      merge_into_section(options[:section])
    end

    private

    def merge_into_section(section_number)

      slides_to_insert_count = presentation.slides.count

      insertion_point = outline_presentation.slide_insertion_point_in_section(section_number)
      total_slide_count = outline_presentation.slides.count

      puts "[?] In outline presentation I am shifting slides by #{slides_to_insert_count} starting at #{insertion_point} to #{total_slide_count}"

      shift_slides(outline_presentation,"ppt/slides/_rels","xml.rels",insertion_point,total_slide_count,slides_to_insert_count)
      copy_slides(presentation,outline_presentation,"ppt/slides/_rels","xml.rels",insertion_point,1,slides_to_insert_count)

      # From the insert position, place the slides rels in there

      shift_slides(outline_presentation,"ppt/slides","xml",insertion_point,total_slide_count,slides_to_insert_count)
      copy_slides(presentation,outline_presentation,"ppt/slides","xml",insertion_point,1,slides_to_insert_count)

      # updated the [Content Types].xml
      #   - slide entry

      (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
        puts "[+] Adding [Content_Types].xml entry for slide #{num}"
        outline_presentation.content_type.add_slide(num)
      end

      outline_presentation.content_type.save


      # updated the ppt/_rels/presentation.xml.rels
      #   - slide entry

      # TODO: Instead of finding the highest relationship_id this file needs the slide
      #   relationships added and then for all the relationship_ids to be rebuilt

      # Find the highest relationship_id
      starting_relationship_id = outline_presentation.highest_relationship_id

      puts "[?] Relationships Starting Count : #{starting_relationship_id}"

      (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
        puts "[+] Adding ppt/_rels/presentation.xml.rels entry for slide #{num}"
        outline_presentation.relationships.add_slide(num)
        outline_presentation.relationships.save
      end

      finishing_relationship_id = outline_presentation.highest_relationship_id

      puts "[?] Relationships Finishing Count :#{finishing_relationship_id}"

      # updated the ppt/presentation.xml
      #   - slide id in the slide list that translates relationship_id
      #   - slide id in the extList
      ((starting_relationship_id + 1)..finishing_relationship_id).each do |num|
        puts "[+] Adding ppt/presentation.xml entry for slide rId#{num} into section #{section_number}"
        outline_presentation.presentation.add_slide(num,section_number)
        outline_presentation.presentation.save
      end
    end

    def move(source,destination)
      `mv #{source} #{destination}`
      # puts "mv #{source} #{destination}"
    end

    def copy(source,destination)
      `cp #{source} #{destination}`
    end

    def shift_slides(presentation,partial_path,extension,insertion_point,total_slide_count,shift)
      (insertion_point..total_slide_count).to_a.reverse.each do |mover|
        source_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover}.#{extension}"
        dest_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover + shift}.#{extension}"
        move(source_filepath,dest_filepath)
      end
    end

    def copy_slides(source_presentation,destination_presentation,partial_path,extension,insertion_point,start,finish)
      (start..finish).each do |num|
        source_filepath = "#{source_presentation.target_filepath}/#{partial_path}/slide#{num}.#{extension}"
        dest_filepath = "#{destination_presentation.target_filepath}/#{partial_path}/slide#{num + insertion_point - 1}.#{extension}"
        copy(source_filepath,dest_filepath)
      end
    end

  end
end