require 'open-uri'
require 'csv'

def webDL(link, file)
  ## -----*----- Webからダウンロード -----*----- ##
  FileUtils.mkdir_p(File.dirname(file)) unless FileTest.exist?(File.dirname(file))
  begin
    open(file, 'wb') do |local_file|
      URI.open(link) do |web_file|
        local_file.write(web_file.read)
      end
    end

  rescue => e
    $logger.error(e.to_s)
  end
end


def scraping(doc, delay: 3, depth_limit: nil)
  ## -----*----- スクレイピング -----*----- ##
  list = doc.css('tr')
  emoji_list = []

  mdap(list.length) { |i|
    next  if list[i].css('.name').length==0
    emoji = list[i].css('img').attr('alt')
    name  = list[i].css('.name').inner_text.gsub(' ', '_')
    emoji_list << [emoji, name]
  }

  puts
  puts "Dump to csv..."
  File.open('emoji.csv', 'w') do |f|
    emoji_list.each do |row|
      f.write row.join(',')
      f.write("\n")
    end
  end

  $logger.info('取得完了')
end
