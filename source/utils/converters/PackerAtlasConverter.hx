package utils.converters;

class PackerAtlasConverter
{
	public static function convert(key:String, ?library:String)
	{
		trace('getPackerAtlas is deprecated!');
		trace('Converting $key.txt to $key.xml...');

		var headOfYay:Xml = Xml.createDocument();
		var yay:Xml = Xml.createElement('TextureAtlas');

		yay.set('imagePath', key.split('/').getLastInArray() + '.png');

		for (i in CoolUtil.coolTextFile(Paths.location.get('images/$key.txt', library, TEXT)))
		{
			var daThing:Array<String> = i.substring(i.lastIndexOf(' = ')).split(' ');
			var stupidNameFix:Array<String> = i.substring(0, i.indexOf(' = ')).split('_');

			var nameFix:String = '';

			nameFix += stupidNameFix[0];

			for (j in 1...4 - stupidNameFix[1].length + 1)
				nameFix += '0';
			nameFix += stupidNameFix[1];

			var subTexture:Xml = Xml.createElement('SubTexture');

			subTexture.set('name', nameFix);
			subTexture.set('x', daThing[0]);
			subTexture.set('y', daThing[1]);
			subTexture.set('width', daThing[2]);
			subTexture.set('height', daThing[3]);

			yay.addChild(subTexture);
		}

		headOfYay.addChild(yay);

		trace('Converted $key.txt to $key.xml!');

		return FlxAtlasFrames.fromSparrow(Paths.content.image(key, library), headOfYay);
	}
}
