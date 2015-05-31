require 'spec_helper'

describe Powerpoint do

  it "has the methods to decompress and compress a PPTX file" do
    expect(Powerpoint).to respond_to(:decompress)
    expect(Powerpoint).to respond_to(:compress)
  end

end