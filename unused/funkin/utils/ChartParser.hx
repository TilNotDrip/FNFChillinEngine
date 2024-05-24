package funkin.utils;

import flixel.util.FlxStringUtil;

/**
 * Legacy Chart System
 *
 * (This is the one that uses png's instead of jsons.)
 */
class ChartParser
{
	/**
	 * Gets a section from a png file
	 * @param songName The song name with the chart
	 * @param section The section to return
	 * @return Section Data from PNG
	 */
	public static function parse(songName:String, section:Int):Array<Dynamic>
	{
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");

		var csvData:String = FlxStringUtil.imageToCSV(Paths.file('data/' + songName + '/' + songName + '_section' + section + '.png'));

		var lines:Array<String> = regex.split(csvData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		csvData.replace("\n", ',');

		var heightInTiles:Float = rows.length;
		var widthInTiles:Float = 0;

		var row:Int = 0;

		var dopeArray:Array<Int> = [];
		while (row < heightInTiles)
		{
			var rowString:String = rows[row];

			if (rowString.endsWith(","))
				rowString = rowString.substr(0, rowString.length - 1);

			var columns:Array<String> = rowString.split(",");

			if (columns.length == 0)
			{
				heightInTiles--;
				continue;
			}

			if (widthInTiles == 0)
				widthInTiles = columns.length;

			var column:Int = 0;
			var pushedInColumn:Bool = false;
			while (column < widthInTiles)
			{
				var columnString:String = columns[column];
				var curTile:Int = Std.parseInt(columnString);

				if (curTile == null)
					throw 'String in row $row, column $column is not a valid integer: "$columnString"';

				if (curTile == 1)
				{
					if (column < 4)
						dopeArray.push(column + 1);
					else
					{
						var tempCol:Int = (column + 1) * -1;
						tempCol += 4;
						dopeArray.push(tempCol);
					}

					pushedInColumn = true;
				}

				column++;
			}

			if (!pushedInColumn)
				dopeArray.push(0);

			row++;
		}
		return dopeArray;
	}
}
