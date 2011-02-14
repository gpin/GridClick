package GridClick
{
	import flash.events.Event;

	public class CellEvent extends Event
	{
		public static const CLICK:String = "CELL_CLICK";
		public static const LOCK:String = "CELL_LOCK";
		
		public var row_index:int = -1;
		public var col_index:int = -1;
		public var button:CellButton = null;

		public function CellEvent(type:String, x:int, y:int, target_button:CellButton)
		{
			super(type, true, false);
			
			this.col_index = x;
			this.row_index = y;
			this.button = target_button;
		}
		
	}
}