require 'spec_helper'

describe Powerpoint::Presentation do

  it "can be created" do
    expect { subject }.to_not raise_error
  end

  context "when loading a presentation that exists" do

    before do
      `rm -rf scene_01`
    end

    let(:subject) { Powerpoint::Presentation.new("scene_01-SLIDES.pptx") }

    it "has the correct slide count" do
      expect(subject.slides.count).to eq(11)
    end
  end

  context "when loading an outline presentation that exists" do

    before do
      `rm -rf day_one`
    end

    let(:subject) { Powerpoint::OutlinePresentation.new("day_one.pptx")}

    it "has the correct number of sections" do
      expect(subject.sections.count).to eq(9)
    end

    context "when examining the first section" do
      let(:section) { subject.sections.first }

      it "has the correct number of slides within a section" do
        expect(section.slides.count).to eq(2)
      end
    end

    context "when examining the last section" do
      let(:section) { subject.sections.last }

      it "has the correct number of slides within a section" do
        expect(section.slides.count).to eq(1)
      end
    end


    it "has the correct slide count" do
      expect(subject.slides.count).to eq(17)
    end

    context "when merging a valid presentation" do
      context "when the section exists" do

        before do
          `rm -rf scene_01`
        end

        let(:other_presentation) { Powerpoint::Presentation.new("scene_01-SLIDES.pptx") }

        it "adds the slides into the appropriate section" do

          Powerpoint::PresentationMerger.merge(subject,other_presentation,1)
          first_section_slide_count = subject.sections.first.slides.count
          expect(first_section_slide_count).to eq(13)

        end
      end
    end

  end

  context "when loading a presentation that is not well-formed" do

  end

  context "when loading a presentation that does not exist" do

  end

end