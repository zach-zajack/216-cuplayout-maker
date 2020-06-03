require_relative "web_parser"

class WiikiParser
  include WebParser

  CTGP_WIIKI = "http://wiki.tockdom.com/wiki/CTGP"

  def initialize
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

  def slot_info(name)
    @slot_info[name]
  end
end
