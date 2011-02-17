package GridClick
{
	public class BoardSummary
	{
		public static function equals(left:Array, right:Array) : Boolean
		{
			if (left.length != right.length)
			{
				return false;
			}
			
			for (var index:int = 0; index<left.length; index++)
			{
				if (left[index] != right[index])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function getComparison(left:Array, right:Array) : Array
		{
			// returns array the same size as left array, containing only Boolean values 
			var result:Array = new Array();
			var l_index:int;
			var r_index:int;
			
			r_index = 0;
			for (l_index=0; l_index<left.length; l_index++)
			{
				if(left[l_index] == right[r_index])
				{
					result.push(true);
					r_index+=1;
				}
				else
				{
					result.push(false);
				}
			}
			return result;
		}
	}
}