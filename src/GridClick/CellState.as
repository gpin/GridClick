package GridClick
{
	public final class CellState
	{
	    public static const EMPTY:int = 0;
	    public static const OFF:int = 0;
	    public static const LOCKED:int = 1;
	    public static const ON:int = 2;
	    
	    public static const StateChar:Array = [ '.', 'X', 'O'];
	    
	    public static function isOn(state:int):Boolean
	    {
	    	return (state>=2);
	    }

	    public static function isOff(state:int):Boolean
	    {
	    	return (state<2);
	    }

	}
}