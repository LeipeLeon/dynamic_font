require 'spec_helper'

describe DynamicFont do

  before(:all) do
    @object = Object.new
    @object.extend(DynamicFont)
    options = {}
  end

  it "should create a basic image" do
    @object.getImage('text').should eql('size28.0cache_pathcachebackground#cccccctexttextcolor#ffffff#000000fontfonts_Blackout-Midnight.ttfspacing5.png')
  end

  it "should accept options" do
    @object.getImage('text', 'background' =>  '#ffffff' ).should eql('size28.0cache_pathcachebackground#fffffftexttextcolor#ffffff#000000fontfonts_Blackout-Midnight.ttfspacing5.png')
    @object.getImage('text', 'color'      => ['#bbbbbb']).should eql('size28.0cache_pathcachebackground#cccccctexttextcolor#bbbbbbfontfonts_Blackout-Midnight.ttfspacing5.png')
  end
end
