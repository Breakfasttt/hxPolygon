package src.geom;
import geom.Vector2D;

/**
 * ...
 * @author Yann C
 */
class Segment 
{

	private var m_pA : Vector2D;
	
	private var m_pB : Vector2D;
	
	private var m_segment : Vector2D;
	
	private var m_normal : Vector2D;
	
	public var slope(default, null) : Float;
	
	public var yIntercept(default, null) : Float;
	
	public function new(pA : Vector2D, pB : Vector2D) 
	{
		m_pA = pA;
		m_pB = pB;
		calculSegmentAndNormal();
	}
	
	public function sqLength() :Float
	{
		if (!this.isValid())
			return -1;
			
		return m_segment.sqLength();
	}
	
	public function isValid() : Bool
	{
		return m_pA != null && m_pB != null && m_segment != null;
	}
	
	public function calculSegmentAndNormal()
	{
		m_segment.copy(m_pB);
		m_segment.vSubstract(m_pA);
		
		m_normal.copy(m_segment);
		m_normal.normalize();
		m_normal.rotate(90); //todo, refaire la fonction qui tourne de 90° plus rapidement aka rotate90
	}
	
	/**
	 * Rotate the segment (if valid) around an origin point
	 * @param	deg
	 * @param	origin
	 */
	public function rotate(deg : Float, origin : Vector2D = null) : Void
	{
		if (!this.isValid())
			return;
			
		m_pA.rotate(deg/*, origin*/);
		m_pB.rotate(deg/*, origin*/);
		calculSegmentAndNormal();
	}
	
	public function crossedBy(cSegment : Segment, asLine : Bool = false) : Vector2D
	{
		// segment not valid, return null
		if (!isValid() || !cSegment.isValid())
			return null;
		
		//same slope so the segment (or line) are parallel
		if ( this.slope == cSegment.slope )
		{
			//same line equation (y=slope * x + yIntercept) so, lines are mixed
			if ( this.yIntercept == cSegment.yIntercept )
			{
				if(asLine) //as a line, all points are mixed between the 2 lines (because of same equation)
					return Vector2D.v2(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY); //we return a special point with infinite value
				else //as a segment
				{
					//we check if pA.x are between pA'.x and pB'.x on the line(not necessary to check y because same equation
					//or if pB.x are between pA' and pB'
					if ( MathFunction.insideWithInclude(m_pA.x, Math.min(cSegment.getPA().x, cSegment.getPB().x), Math.max(cSegment.getPA().x, cSegment.getPB().x)) ||
						 MathFunction.insideWithInclude(m_pB.x, Math.min(cSegment.getPA().x, cSegment.getPB().x), Math.max(cSegment.getPA().x, cSegment.getPB().x)) )
					{
						//if segment cross each other in this situation there are 3 solutions possible : 
						
						// 1- pA is the same point of pB'
						if (m_pA.x == cSegment.getPB().x)
							return m_pA.clone(); //so we return pA as the intersect point
						else if (m_pB.x == cSegment.getPA().x) //2- or pB is the same point of pA'
							return m_pB.clone(); //so we return pB as the intersect point
						else // 3- there are an infinite of points mixed between the 2 segments. So we return a special point with infinite value
							return Vector2D.v2(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
					}
					else
						return null; //we return null if segment don't cross in this case
				}
			}
			else
				return null; //same slope parallel but not mixed so no cross point
		}
		
		//else, there are a cross Point between the 2 segments/line
		
		var crossX : Float = 0.0;
		var crossY : Float = 0.0;
		
		if (this.slope == Math.POSITIVE_INFINITY) //infinite slope = vertical line
		{
			//all point as same abcisses, so the cross point too if slope are infinite
			crossX = m_pA.x;
			
			//to calculate the Y coordonate of cross point when this.slope is infinite
			//we need to used the other segment. At this state, 
			//the other segment have not an infinite slope, otherwise, we are in the case
			//that the two segment/line are parallel.
			crossY = cSegment.slope * crossX + cSegment.yIntercept;
		}
		else if(cSegment.slope == Math.POSITIVE_INFINITY)
		{
			//same idea but if the other segment have an infinite slope, and this not
			crossX = cSegment.getPA().x;
			crossY = this.slope * crossX + this.yIntercept;
		}
		else  //simple calcul
		{
			crossX = (cSegment.yIntercept - this.yIntercept) / (this.slope - cSegment.slope);
			crossY = this.slope * crossX + this.yIntercept;
		}
		
		if (!asLine) // as a segment, we check if the x of cross point is include [pAx, pBx] and [pA'x, pB'x] (on the 2 segment)
		{
			if ( !MathFunction.insideWithInclude(crossX, Math.min(m_pA.x, m_pB.x), Math.max(m_pA.x, m_pB.x)) || 
				 !MathFunction.insideWithInclude(crossX, Math.min(cSegment.getPA().x, cSegment.getPB().x), Math.max(cSegment.getPA().x, cSegment.getPB().x)) )
			{
				return null; // if not, no cross point we return a null result
			}
		}
			
		return Vector2D.v2(crossX, crossY); ///finally return the cross point
	}
	
	public function toString() : String
	{
		if (!isValid())
			return "segment not valid";
		
		var result = "";
		result += m_pA.toString() +"," + m_pB.toString();
		result += "segment(vector) : " + m_segment.toString();
		result += "normal : " + m_normal.toString();
		result += "slope : " + this.slope; 
		result += "yIntercept : " + this.yIntercept;
		return result;
	}	
	
}