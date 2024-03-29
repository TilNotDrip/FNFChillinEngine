package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class RGBShader
{
	public var shader(default, null):RGBPaletteShader = new RGBPaletteShader();
	public var rgb(default, set):Array<FlxColor>;
	public var mult(default, set):Float;

	private function set_rgb(color:Array<FlxColor>):Array<FlxColor>
	{
		rgb = color;
		shader.r.value = [color[0].red / 255.0, color[0].green / 255.0, color[0].blue / 255.0];
		shader.g.value = [color[1].red / 255.0, color[1].green / 255.0, color[1].blue / 255.0];
		shader.b.value = [color[2].red / 255.0, color[2].green / 255.0, color[2].blue / 255.0];
		return color;
	}

	private function set_mult(value:Float):Float
	{
		mult = FlxMath.bound(value, 0, 1);
		shader.mult.value = [mult];
		return mult;
	}

	public function new()
	{
		rgb = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];
		mult = 1.0;
	}
}

class RGBPaletteShader extends FlxShader
{
	@:glFragmentHeader('
        #pragma header

        uniform vec3 r;
        uniform vec3 g;
        uniform vec3 b;
        uniform float mult;

        vec4 flixel_texture2DCustom(sampler2D bitmap, vec2 coord) {
            vec4 color = flixel_texture2D(bitmap, coord);
            if (!hasTransform || color.a == 0.0 || mult == 0.0) {
                return color;
            }

            vec4 newColor = color;
            newColor.rgb = min(color.r * r + color.g * g + color.b * b, vec3(1.0));
            newColor.a = color.a;
            
            color = mix(color, newColor, mult);
            
            if(color.a > 0.0) {
                return vec4(color.rgb, color.a);
            }
            return vec4(0.0, 0.0, 0.0, 0.0);
        }')
	@:glFragmentSource('
        #pragma header

        void main() {
            gl_FragColor = flixel_texture2DCustom(bitmap, openfl_TextureCoordv);
        }')
	public function new()
	{
		super();
	}
}
