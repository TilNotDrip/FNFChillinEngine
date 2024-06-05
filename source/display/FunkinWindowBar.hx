package display;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

@:deprecated('This isn\'t finished right now! Please don\'t use it.')
class FunkinWindowBar extends Sprite
{
    public var curWidth:Int = 1280;
    public function new()
    {
        super();
        reloadWindowBar();
    }

    public function reloadWindowBar(?curWidth:Int = 1280)
    {
        var bg:Sprite = new Sprite();
        bg.graphics.beginFill(0xffffff);
        bg.graphics.drawRect(0, 0, curWidth, 32);
        bg.graphics.endFill();
		bg.x = 0;
		bg.y = 0;
		addChild(bg);

        var closeButton:Bitmap = new Bitmap(Paths.image("titlebar/close").bitmap);
		closeButton.x = curWidth - (16 * 1);
		closeButton.y = 0;
        closeButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
            //closeButton.scaleX = closeButton.scaleY = 1.3;
            Sys.exit(0);
        });
		addChild(closeButton);

        var maximizeButton:Bitmap = new Bitmap(Paths.image("titlebar/maximize").bitmap);
		maximizeButton.x = curWidth - (16 * 2);
		maximizeButton.y = 0;
        maximizeButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
            //maximizeButton.scaleX = maximizeButton.scaleY = 1.3;
            Lib.application.window.maximized = !Lib.application.window.maximized;
        });
		addChild(maximizeButton);

        var minimizeButton:Bitmap = new Bitmap(Paths.image("titlebar/minimize").bitmap);
		minimizeButton.x = curWidth - (16 * 3);
		minimizeButton.y = 0;
        minimizeButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
            //minimizeButton.scaleX = minimizeButton.scaleY = 1.3;
            Lib.application.window.minimized = !Lib.application.window.minimized;
        });
		addChild(maximizeButton);
    }

    public function changeWindowName(name:String)
    {
        trace(name);
    }
}