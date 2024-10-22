package funkin.data.registry;

import funkin.structures.ChartStructures;

class SongRegistry extends BaseRegistry<NewSong, ChillinMetadata>
{
	public function getJsonParser():Dynamic
	{
		return new json2object.JsonParser<ChillinMetadata>();
	}
}
