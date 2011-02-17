package GridClick
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class CellButton extends UIComponent
	{
		protected var row_index_:int = -1;
		protected var col_index_:int = -1;
		protected var sprite_:Sprite = new UIComponent();
		protected var state_:int;
		
		public function CellButton(x:int, y:int)
		{
			col_index_ = x;
			row_index_ = y;
			
			super();
			
			this.width = 25;
			this.height = 25;

			this.State = CellState.EMPTY;
			            
            addChild(sprite_);

			this.addEventListener(MouseEvent.CLICK, this.onClick);
		}
		
		public function set State(state:int) : void
		{
			state_ = state;
			repaint();
		}
		
		public function get State() : int
		{
			return state_;
		}
		
		protected function repaint() : void
		{
			switch(state_)
			{
			case CellState.LOCKED:
				paintLockedState();
				break;
			case CellState.ON:
				paintOnState();
				break;
			default:
				paintOffState();
				break;
			}
		}
		
		protected function paintOffState() : void
		{
            sprite_.graphics.lineStyle(1, 0x555555, 100);
            sprite_.graphics.moveTo(0,0);
            sprite_.graphics.lineTo(this.width,0);
            sprite_.graphics.lineTo(this.width,this.height);
            sprite_.graphics.lineTo(0,this.height);
            sprite_.graphics.lineTo(0,0);
			sprite_.graphics.beginFill(0xeeeeee, 1);
			sprite_.graphics.drawRect(1, 1, this.width-1, this.height-1);
			sprite_.graphics.endFill();
		}
		
		protected function paintOnState() : void
		{
            sprite_.graphics.lineStyle(1, 0x555555, 100);
            sprite_.graphics.moveTo(0,0);
            sprite_.graphics.lineTo(this.width,0);
            sprite_.graphics.lineTo(this.width,this.height);
            sprite_.graphics.lineTo(0,this.height);
            sprite_.graphics.lineTo(0,0);
			sprite_.graphics.beginFill(0x222222, 1);
			sprite_.graphics.drawRect(1, 1, this.width-1, this.height-1);
			sprite_.graphics.endFill();
		}
		
		protected function paintLockedState() : void
		{
            sprite_.graphics.lineStyle(1, 0x555555, 100);
            sprite_.graphics.moveTo(0,0);
            sprite_.graphics.lineTo(this.width,0);
            sprite_.graphics.lineTo(this.width,this.height);
            sprite_.graphics.lineTo(0,this.height);
            sprite_.graphics.lineTo(0,0);

			sprite_.graphics.beginFill(0xcccccc, 1);
			sprite_.graphics.drawRect(1, 1, this.width-1, this.height-1);
			sprite_.graphics.endFill();

            sprite_.graphics.lineStyle(1, 0x222222, 100);
            sprite_.graphics.moveTo(0,0);
            sprite_.graphics.lineTo(this.width,this.height);
            sprite_.graphics.moveTo(0,this.height);
            sprite_.graphics.lineTo(this.width,0);
		}
		
		protected function onClick(event:MouseEvent) : void
		{
			event.stopImmediatePropagation();
			event.preventDefault();
			dispatchEvent(new CellEvent(CellEvent.CLICK, col_index_, row_index_, this));
		}
	}
}