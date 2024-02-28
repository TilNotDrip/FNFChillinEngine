package options;

import flixel.effects.FlxFlicker;

import flixel.util.FlxSignal;

class MenuTypedList<T:MenuItem> extends FlxTypedGroup<T>
{
	public var selectedIndex(default, null) = 0;
	public var selectedItem(get, never):T;
	public var onChange(default, null) = new FlxTypedSignal<T->Void>();
	public var onAcceptPress(default, null) = new FlxTypedSignal<T->Void>();
	public var navControls:NavControls;
	public var enabled:Bool = true;
	public var wrapMode:WrapMode = Both;

	var byName = new Map<String, T>();
	public var busy(default, null):Bool = false;

	public function new (navControls:NavControls = Vertical, ?wrapMode:WrapMode)
	{
		this.navControls = navControls;
		
		if (wrapMode != null)
			this.wrapMode = wrapMode;
		else
			this.wrapMode = switch (navControls)
			{
				case Horizontal: Horizontal;
				case Vertical: Vertical;
				default: Both;
			}
		super();
	}

	public function addItem(name:String, item:T):T
	{
		if (length == selectedIndex)
			item.select();
		
		byName[name] = item;
		return add(item);
	}

	public function resetItem(oldName:String, newName:String, ?callback:Void->Void):T
	{
		if (!byName.exists(oldName))
			throw "No item named:" + oldName;

		var item = byName[oldName];
		byName.remove(oldName);
		byName[newName] = item;
		item.setItem(newName, callback);

		return item;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (enabled && !busy)
			updateControls();
	}

	inline function updateControls()
	{
		var controls = PlayerSettings.player1.controls;

		var wrapX = wrapMode.match(Horizontal | Both);
		var wrapY = wrapMode.match(Vertical | Both);
		var newIndex = switch(navControls)
		{
			case Vertical    : navList(controls.UI_UP_P  , controls.UI_DOWN_P, wrapY);
			case Horizontal  : navList(controls.UI_LEFT_P, controls.UI_RIGHT_P, wrapX);
			case Both        : navList(controls.UI_LEFT_P || controls.UI_UP_P, controls.UI_RIGHT_P || controls.UI_DOWN_P, !wrapMode.match(None));

			case Columns(num): navGrid(num, controls.UI_LEFT_P, controls.UI_RIGHT_P, wrapX, controls.UI_UP_P  , controls.UI_DOWN_P , wrapY);
			case Rows   (num): navGrid(num, controls.UI_UP_P  , controls.UI_DOWN_P , wrapY, controls.UI_LEFT_P, controls.UI_RIGHT_P, wrapX);
		}

		if (newIndex != selectedIndex)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			selectItem(newIndex);
		}

		if (controls.ACCEPT)
			accept();
	}

	function navAxis(index:Int, size:Int, prev:Bool, next:Bool, allowWrap:Bool):Int
	{
		if (prev == next)
			return index;

		if (prev)
		{
			if (index > 0)
				index--;
			else if (allowWrap)
				index = size - 1;
		}
		else
		{
			if (index < size - 1)
				index++;
			else if (allowWrap)
				index = 0;
		}

		return index;
	}

	inline function navList(prev:Bool, next:Bool, allowWrap:Bool)
	{
		return navAxis(selectedIndex, length, prev, next, allowWrap);
	}

	function navGrid(latSize:Int, latPrev:Bool, latNext:Bool, latAllowWrap:Bool, prev:Bool, next:Bool, allowWrap:Bool):Int
	{
		var size = Math.ceil(length / latSize);
		var index = Math.floor(selectedIndex / latSize);
		var latIndex = selectedIndex % latSize;

		latIndex = navAxis(latIndex, latSize, latPrev, latNext, latAllowWrap);
		index = navAxis(index, size, prev, next, allowWrap);

		return Std.int(Math.min(length - 1, index * latSize + latIndex));
	}

	public function accept()
	{
		var selected = members[selectedIndex];
		onAcceptPress.dispatch(selected);

		if (selected.fireInstantly)
			selected.callback();
		else
		{
			busy = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(selected, 1, 0.06, true, false, function(_)
			{
				busy = false;
				selected.callback();
			});
		}
	}

	public function selectItem(index:Int)
	{
		members[selectedIndex].idle();
		
		selectedIndex = index;
		
		var selected = members[selectedIndex];
		selected.select();
		onChange.dispatch(selected);
	}

	public function has(name:String)
	{
		return byName.exists(name);
	}

	public function getItem(name:String)
	{
		return byName[name];
	}

	override function destroy()
	{
		super.destroy();
		byName.clear();
		onChange.removeAll();
		onAcceptPress.removeAll();
	}

	inline function get_selectedItem():T
	{
		return members[selectedIndex];
	}
}

class MenuItem extends FlxSprite
{
	public var callback:Void->Void;
	public var name:String;

	public var fireInstantly = false;
	public var selected(get, never):Bool;
	function get_selected() return alpha == 1.0;

	public function new (x = 0.0, y = 0.0, name:String, callback)
	{
		super(x, y);
		
		antialiasing = true;
		setData(name, callback);
		idle();
	}

	function setData(name:String, ?callback:Void->Void)
	{
		this.name = name;

		if (callback != null)
			this.callback = callback;
	}

	public function setItem(name:String, ?callback:Void->Void)
	{
		setData(name, callback);
		
		if (selected)
			select();
		else
			idle();
	}

	public function idle()
	{
		alpha = 0.6;
	}

	public function select()
	{
		alpha = 1.0;
	}
}

class MenuTypedItem<T:FlxSprite> extends MenuItem
{
	public var label(default, set):T;

	public function new (x = 0.0, y = 0.0, label:T, name:String, callback)
	{
		super(x, y, name, callback);
		this.label = label;
	}

	function setEmptyBackground()
	{
		var oldWidth = width;
		var oldHeight = height;
		makeGraphic(1, 1, 0x0);
		width = oldWidth;
		height = oldHeight;
	}

	function set_label(value:T)
	{
		if (value != null)
		{
			value.x = x;
			value.y = y;
			value.alpha = alpha;
		}
		return this.label = value;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (label != null)
			label.update(elapsed);
	}

	override function draw()
	{
		super.draw();
		if (label != null)
		{
			label.cameras = cameras;
			label.scrollFactor.copyFrom(scrollFactor);
			label.draw();
		}
	}

	override function set_alpha(value:Float):Float
	{
		super.set_alpha(value);

		if (label != null)
			label.alpha = alpha;

		return alpha;
	}

	override function set_x(value:Float):Float
	{
		super.set_x(value);

		if (label != null)
			label.x = x;

		return x;
	}

	override function set_y(Value:Float):Float
	{
		super.set_y(Value);

		if (label != null)
			label.y = y;

		return y;
	}
}

enum NavControls
{
	Horizontal;
	Vertical;
	Both;
	Columns(num:Int);
	Rows(num:Int);
}

enum WrapMode
{
	Horizontal;
	Vertical;
	Both;
	None;
}