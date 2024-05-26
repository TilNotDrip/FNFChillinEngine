package flxanimate.shaders;

import flixel.system.FlxAssets.FlxShader;

class BlurShader extends FlxShader
{
	@:glFragmentSource("uniform sampler2D openfl_Texture;

		varying vec2 vBlurCoords[7];

		void main(void) {

			vec4 sum = vec4(0.0);
			sum += texture2D(openfl_Texture, vBlurCoords[0]) * 0.00443;
			sum += texture2D(openfl_Texture, vBlurCoords[1]) * 0.05399;
			sum += texture2D(openfl_Texture, vBlurCoords[2]) * 0.24197;
			sum += texture2D(openfl_Texture, vBlurCoords[3]) * 0.39894;
			sum += texture2D(openfl_Texture, vBlurCoords[4]) * 0.24197;
			sum += texture2D(openfl_Texture, vBlurCoords[5]) * 0.05399;
			sum += texture2D(openfl_Texture, vBlurCoords[6]) * 0.00443;

			gl_FragColor = sum;

		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		uniform mat4 openfl_Matrix;

		uniform vec2 uRadius;
		varying vec2 vBlurCoords[7];
		uniform vec2 uTextureSize;

		void main(void) {

			gl_Position = openfl_Matrix * openfl_Position;

			vec2 r = uRadius / uTextureSize;
			vBlurCoords[0] = openfl_TextureCoord - r;
			vBlurCoords[1] = openfl_TextureCoord - r * 0.75;
			vBlurCoords[2] = openfl_TextureCoord - r * 0.5;
			vBlurCoords[3] = openfl_TextureCoord;
			vBlurCoords[4] = openfl_TextureCoord + r * 0.5;
			vBlurCoords[5] = openfl_TextureCoord + r * 0.75;
			vBlurCoords[6] = openfl_TextureCoord + r;

		}")
	public function new(blurX:Float, blurY:Float)
	{
		super();
        uRadius.value = [blurX, blurY];
	}

    public var blurX(default, set):Float = 0;
    public var blurY(default, set):Float = 0;

    function set_blurX(val:Float):Float
    {
        uRadius.value[0] = blurX;
        return val;
    }
      
    function set_blurY(val:Float):Float
    {
        uRadius.value[1] = blurY;
        return val;
    }
}