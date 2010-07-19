# copied from / inspired by http://github.com/narced133/radiant-dynamic-image-extension

require 'RMagick'
module DynamicFont

  def font_config
    # cachePath =  Radiant::Config['image.cache_path']
    {
      'font'       => 'fonts/Blackout-Midnight.ttf',
      'size'       => 28.0,
      'spacing'    => 5,
      'color'      => ['#ffffff','#000000'],
      'cache_path' => 'cache',
      'background' => '#cccccc'
    }
  end

  def getImage(text, options = {})
    config = font_config.merge(options)

    # text = cleanText(text)
    words = text.split(/[\s]/)
    imageName = "%s.png" % config.merge('text' => text).to_s.gsub('/','_')
    imageName = config['outfile'] if config['outfile']
    imagePath = File.join(config['cache_path'], imageName)

    # Generate the image if not using cache
    if(not config['cache'] or not File.exists?(imagePath))
      # Generate the image list
      canvas = Magick::ImageList.new

      # Generate the draw object with the font parameters
      draw = Magick::Draw.new
      draw.stroke    = 'transparent'
      draw.font      = config['font']
      draw.pointsize = config['size']

      # Generate a temporary image for use with metrics and find metrics
      tmp = Magick::Image.new(100,100)
      metrics = draw.get_type_metrics(tmp, text)

      # Generate the image of the appropriate size
      canvas.new_image(metrics.width,metrics.height){
        self.background_color = config['background']
      }
      # Iterate over each of the words and generate the appropriate annotation
      # Alternate colors for each word

      xPos = 0;
      count = 0;
      words.each do |word|
        draw.fill = config['color'][(count % config['color'].length)]
        draw.annotate(canvas,0,0,xPos,metrics.ascent,word)

        metrics = draw.get_type_metrics(tmp, word)
        xPos = xPos + metrics.width + config['spacing']
        count = count + 1;
      end

      # Write the file
      canvas.write(imagePath)
    end

    return imageName

  end

end
