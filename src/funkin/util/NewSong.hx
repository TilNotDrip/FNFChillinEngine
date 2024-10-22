package funkin.util;

import funkin.data.IRegistryEntry;

class NewSong implements IRegistryEntry<ChillinMetadata>
{
	public final id:String;
	public final _data:T;

	public function new(id:String)
	{
		this.id = id;
	}

	public function destroy():Void
	{
		// TODO: make stuff happen here
	}

	public function toString():String
	{
		return 'Song($id)';
	}
}
