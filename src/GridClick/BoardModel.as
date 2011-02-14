package GridClick
{
	public class BoardModel
	{
		protected var data_:Array = null;
		protected var title_:String = "Untitled";
		protected var width_:int = 0;
		protected var height_:int = 0;
		
		public function BoardModel(width:int, height:int = 0) // height==0 : match it to width
		{
			width_ = (width>0 ? width : 0);
			height_ = (height>0 ? height : width_); 
			initData();
		}
		
		protected function initData() : void
		{
			data_ = new Array(width_ * height_);
		}
		
		protected function getIndex(x:int, y:int) : int
		{
			return y*height_ + x;
		}
		
		public function clear() : void
		{
			for each(var cell:int in data_)
			{
				cell = CellState.EMPTY;
			} 
		}
		
		public function setTitle(title:String) : void
		{
			title_ = title;
		}
		
		public function getTitle() : String
		{
			return title_;
		}
		
		public function setCell(x:int, y:int, state:int) : void
		{
			data_[getIndex(x,y)] = state;
		}
		
		public function getCell(x:int, y:int) : int
		{
			return data_[getIndex(x,y)];
		}

	}
}