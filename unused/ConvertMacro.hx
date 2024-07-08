package;

import sys.FileSystem;

class ConvertMacro
{
    static function main()
    {
        trace('Converting OGG Files to MP3...');
        convertFiles();
    }

    static function convertFiles() 
    {
        var currentDirectories:Array<String> = ['assets'];
        while(currentDirectories.length > 0)
        {
            for(path in FileSystem.readDirectory(currentDirectories.shift()))
            {
                trace(path);
                if(path.substring(path.length-3) == 'ogg')
                {
                    var convertedPath:String = path.substring(0, path.lastIndexOf('.ogg')-3);
                    var process = new sys.io.Process('ffmpeg', ['-i $convertedPath.ogg', '$convertedPath.mp3', '-hide_banner', '-loglevel error', '-y']);

                    if (process.exitCode() == 0) 
                        trace("Converted " + path + " successfully!");
                    /*else
                    {
                        var message = process.stderr.readAll().toString();
                        var pos = haxe.macro.Context.currentPos();
                        haxe.macro.Context.error("Error while converting ogg to mp3! Details:\n" + message, pos);
                    }*/
                }
                else if(FileSystem.isDirectory(path))
                    currentDirectories.push(path);

                trace(currentDirectories);
            }
        }
    }
}