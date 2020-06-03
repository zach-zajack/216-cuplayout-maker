require "open-uri"

PATH = "#{__dir__}/cuplayout.cup"
CTGP_WIIKI = "http://wiki.tockdom.com/wiki/CTGP"
LEADERBOARD_ROOT = "https://www.chadsoft.co.uk/time-trials"
LEADERBOARDS = "https://www.chadsoft.co.uk/time-trials/ctgp-leaderboards.html"
NAME_FILTERS = ["- Glitch", "- Shortcut", "Star Slope", "N64 Rainbow Road"]
# rest are flame by default
VEHICLES = {
  "34" => :Magi,  "30" => :Magi, # one for dolphin dasher
  "22" => :Mach,  "21" => :Mach, # one for bullet bike
  "23" => :Flame, "32" => :Spear
}

def open_website(url)
  begin
    return open(url).read
  rescue
    puts "404'd. Trying again..."
    open_website(url)
  end
end

def parse(html, bound_search, index_search=nil, rindex_search)
  index_search ||= bound_search
  bound  = html.index(bound_search)
  return if bound.nil?
  index  = html.index(index_search, bound) + index_search.length
  rindex = html.index(rindex_search, index)
  return html[index...rindex]
end

def get_slot_info
  @slot_info = {}
  tracks = open_website(CTGP_WIIKI)
  tracks = tracks[tracks.index("</th></tr>")..-1]
  loop do
    row_index = tracks.index("<tr")
    break if row_index.nil?
    # add 3 to skip to next row
    tracks = tracks[row_index + 3..-1]
    name = parse(tracks, "<a", ">", "</a>")
    if name.include?("<img")
      # skip row image
      row = parse(tracks, "<a", ">", "</tr>")
      name = parse(row, "<a", ">", "</a>")
    end
    break if name == "Star Slope"
    # parse from music slot info to end of row to skip version, author etc.
    slots_info = parse(tracks, "</span>", "</tr>")
    slot_id = parse(slots_info, "0x", "<").chomp
    @slot_info[name] = slot_id
  end
end

def get_vehicle_info
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
    slot = @slot_info[id]
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
  File.open(PATH, "wb") { |f| f.write(bytes) }
  puts "File written to #{PATH}."
end

get_slot_info
get_vehicle_info
write_cuplayout
