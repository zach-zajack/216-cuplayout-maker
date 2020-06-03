# test file

require_relative "web_parser"
require_relative "wiiki_parser"

module ListConversion
  include WebParser
  module_function

  LIST = "Bayside Boulevard,Forest Creek,GBA Lakeside Park,GBA Luigi Circuit,GCN Dry Dry Desert,GCN Sherbet Land,Green Park,Haunted Woods,Shadow Woods,SNES Donut Plains 3,Candy Coaster,Cave Island,DS Airship Fortress,Galaxy Base,GBA Riverside Park,GBA Sunset Wilds,GCN Baby Park,GCN Wario Colosseum,GCN Yoshi Circuit,Kartwood Creek,Red Loop,Seaside Circuit,Slot Circuit,SNES Donut Plains 1,SNES Donut Plains 2,Snowy Circuit 2,Underground Sky,Unnamed Valley,White Garden,ASDF_Course,Big Express City,Calidae Desert,Cottonplant Forest,DKR Ancient Lake,DKR Jungle Falls,Dragon Burial Grounds,Dragonite's Island,DS Cheep Cheep Beach,DS Figure-8 Circuit,Fishdom Island,GCN Mushroom Bridge,Incendia Castle,N64 Banshee Boardwalk,N64 Choco Mountain,N64 Kalimari Desert,N64 Koopa Troopa Beach,N64 Luigi Raceway,N64 Moo Moo Farm,N64 Toad's Turnpike,N64 Yoshi Valley,Rock Rock Ridge,SADX Twinkle Circuit,Seaside Resort,SNES Mario Circuit 1,SNES Koopa Beach 2,Subspace Factory,Suzuka Circuit,Toad Raceway,Warp Pipe Island,Winter Paradise,Abyssal Ruins,Alpine Peak,Aquadrom Stage,Aquania,Aura Metropolis,Autumn Leavesway,Big Nature City,Boshi Skatepark,Bowser's Fiery Fortress,Canyon Run,Castle of Darkness,Castle of Time,Celestial Ruins,Cherry Blossom Garden,Christmas Court,Colour Circuit,Comet Starway,Concord Town,Cookie Village,Cool Castle Canyon,Coral Cape,Crystal Dungeon,Crystal Plains,CTR Blizzard Bluff,CTR Cortex Castle,Daisy Hillside,Dark Matter Shrine,Dawn Township,Delfino Island,Desert Castle Raceway,Desert Mushroom Ruins,Desktop Dash,DK Ruins,DKR Star City,Dreamworld Cloudway,DS Bowser Castle,DS DK Pass,DS Luigi's Mansion,DS Mario Circuit,DS Shroom Ridge,DS Tick-Tock Clock,DS Waluigi Pinball,DS Wario Stadium,Festival Town,Final Grounds,Flowery Greenhouse,Flying Kingdom,GBA Boo Lake,GBA Bowser Castle 1,GBA Bowser Castle 2,GBA Bowser Castle 4,GBA Broken Pier,GBA Cheep Cheep Island,GBA Cheese Land,GBA Mario Circuit,GBA Peach Circuit,GBA Rainbow Road (2),GBA Ribbon Road,GBA Sky Garden,GBA Snow Land,GCN Bowser's Castle,GCN Daisy Cruiser,GCN Luigi Circuit,GCN Mushroom City,GCN Rainbow Road,Glimmer Express Trains,Gothic Castle,GP Mario Beach,Halogen Highway,Headlong Skyway,Heart of China,Hell Pyramid,Hellado Mountain,Honeybee Hideout,Icecream Sweetland,Icepeak Mountain,Infernal Pipeyard,Item Fireland,Jiyuu Village,Jungle Cliff,Jungle Jamble,Jungle Ruins,Kinoko Cave,Kirio Raceway,Koopa Shell Pipeland,Lakeside Hill,Lava Lake,Lava Road,Lost Fortress,Lunar Lights,Lunar Spaceway,Luncheon Tour,Mansion of Madness,Marble Towers,Melody Sanctum,Melting Magma Melee,Misty Ruins,Mushroom Island,Mushroom Peaks,N64 Frappe Snowland,N64 Royal Raceway,N64 Wario Stadium,Neo Koopa City,New Moon Manor,Nightlife Party,Nivurbia,Nostalgic Bowser's Castle,Pipe Underworld,Piranha Pipe Pipeline,Rainbow Road: Solar Edition,Retro Raceway,Rezway,Rockside River,Rosalina's Snow World,Rush City Run,Sahara Hideout,Sandcastle Park,Seasonal Circuit,Shy Guy's Market,Six King Labyrinth,Sky Grove,Sky Shrine,Skyline Avenue,SNES Bowser Castle 1,SNES Bowser Castle 2,SNES Bowser Castle 2 (2),SNES Bowser Castle 3,SNES Choco Island 2,SNES Ghost Valley 1,SNES Mario Circuit 2,SNES Rainbow Road 4,Snowy Circuit,Spike Desert,Summer Starville,Sunset Circuit,Sunset Forest,Sunset Raceway,Sunset Ridge,The Rabbit Hole,Thwomp Swamp,Tropical Factory,Twin Peaks,Undiscovered Offlimit,Volcanic Pipeyard,Volcanic Skyway 2,Volcanic Skyway 4,Volcanic Valley,Waluigi's Motocross,Wario's Shipwreck,Wetland Woods,Windmill Village,Wolf Castlegrounds,Wuhu Mountain,Yoshi Lagoon,Yoshi's Woolly Raceway,Sea Stadium".split(",")

  def write_cuplayout
    wiiki = WiikiParser.new
    bytes = "CUP2\000\000\0006" # file magic + cup length ("6" is 0x36, or 54)
    LIST.each do |track_id|
      slot = wiiki.slot_info(track_id) || "FF" # no track selected by default
      bytes += [slot.to_i(16)].pack("C") # convert slot to byte
    end
    File.open(PATH, "wb") { |f| f.write(bytes) }
    puts "File written to #{PATH}."
  end
end

ListConversion.write_cuplayout
