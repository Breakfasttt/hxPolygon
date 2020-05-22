package src.geom;

/**
 * A collection of Math static function
 * @author Breakyt
 */
class MathUtils 
{

	public static function toRad(deg : Float) : Float
	{
		return deg * Math.PI / 180.0;
	}
	
	public static function toDeg(rad : Float) : Float
	{
		return rad * 180.0 / Math.PI;
	}
	
	public static function clamp(value : Float, min : Float, max : Float)
	{
		if (max < min)
		{
			var temp = min;
			min = max;
			max = temp;
		}
		
		if (value > max)
			return max;
		else if (value < min)
			return min
		else
			return value;
	}
	
	public static function intClamp(value : Int, min : Int, max : Int)
	{
		if (max < min)
		{
			var temp = min;
			min = max;
			max = temp;
		}
		
		if (value > max)
			return max;
		else if (value < min)
			return min
		else
			return value;
	}
	
}