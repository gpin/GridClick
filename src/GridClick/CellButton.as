package GridClick
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;

	public class CellButton extends Button
	{
		protected var row_index_:int = -1;
		protected var col_index_:int = -1;
		
		public function CellButton(x:int, y:int)
		{
			col_index_ = x;
			row_index_ = y;
			
			super();
			
			this.toggle = true;
			this.width = 30;
			this.height = 30;
			this.toolTip = "-" + x + ":" + y + "-";
			this.addEventListener(MouseEvent.CLICK, this.onClick);
		}
		
		protected function onClick(event:MouseEvent) : void
		{
			event.stopImmediatePropagation();
			event.preventDefault();
			dispatchEvent(new CellEvent(CellEvent.CLICK, col_index_, row_index_, this));
		}
	}
}