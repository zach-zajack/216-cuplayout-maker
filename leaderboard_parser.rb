require_relative "web_parser"
require_relative "wiiki_parser"

module LeaderboardParser
  extend WebParser
  module_function

  LEADERBOARD_ROOT = "https://www.chadsoft.co.uk/time-trials"
  LEADERBOARDS = "https://www.chadsoft.co.uk/time-trials/ctgp-leaderboards.html"
  NAME_FILTERS = ["- Glitch", "- Shortcut", "Star Slope", "N64 Rainbow Road"]
  # rest are flame by default
  VEHICLES = {
    "34" => :Magi,  "30" => :Magi, # one for dolphin dasher
    "22" => :Mach,  "21" => :Mach, # one for bullet bike
    "23" => :Flame, "32" => :Spear
  }

  def get_vehicle_info
    wiiki = WiikiParser.new
    @cuplayout = {:Magi => [], :Mach => [], :Spear => [], :Flame => []}
    tracks = open_website(LEADERBOARDS)
    loop do
      row_index = tracks.index("<tr search-key")
      break if row_index.nil?
      # add 3 to skip to next row
      tracks = tracks[row_index + 3..-1]
      track_url = LEADERBOARD_ROOT + parse(tracks, '<a href=".', '"')
      id = parse(tracks, 'search-key="', '"')
      name = parse(tracks, "<a", ">", "</a>")
      next if NAME_FILTERS.any? { |name_filter| name.include?(name_filter) }
      slot = wiiki.slot_info(id)
      track = open_website(track_url)
      vehicle_id = parse(track, "<tr order-key", 'vehicle="', '"')
      vehicle = VEHICLES[vehicle_id] || :Flame # flame by default
      puts "#{id} -> #{vehicle}"
      @cuplayout[vehicle] << (slot || "FF") # no track selected by default
    end
  end

  def write_cuplayout
    bytes = "CUP2\000\000\0006" # file magic + cup length ("6" is 0x36, or 54)
    @cuplayout.each do |vehicle, slots|
      slots.each { |slot| bytes += [slot.to_i(16)].pack("C") } # convert to byte
    end
    File.open(WebParser::PATH, "wb") { |f| f.write(bytes) }
    puts "File written to #{WebParser::PATH}."
  end
end

LeaderboardParser.get_vehicle_info
LeaderboardParser.write_cuplayout
