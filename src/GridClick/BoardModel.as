package GridClick
{
	import mx.controls.Alert;
	
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
		
		public function get width() : int
		{
			return width_;
		}
		
		public function get height() : int
		{
			return height_;
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
			for(var index:int=0; index<data_.length; index++)
			{
				data_[index] = CellState.EMPTY;
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
		
		public function equals(model:BoardModel) : Boolean
		{
			var x:int;
			var y:int;
			if (width_ == model.width && height_ == model.height)
			{
				for (y=0; y<height_; y++)
				{
					for (x=0; x<width_; x++)
					{
						if (getCell(x,y) != model.getCell(x,y))
						{
							return false;
						}
					}
				}
				return true;
			}
			return false;
		}
		
		public function getRowSummary(y:int) : Array
		{
			var temp:String = "";
			var state:int;
			for (var index:int = 0; index<width_; index++)
			{
				state = getCell(index, y);
				if (CellState.isOff(state))
				{
					temp += " ";
				}
				else
				{
					temp += CellState.StateChar[state];
				}
			}
			var chunks:Array = temp.match(/\S+/g);
			return chunks;
		}

		public function getColSummary(x:int) : Array
		{
			var temp:String = "";
			var state:int;
			for (var index:int = 0; index<height_; index++)
			{
				state = getCell(x, index);
				if (CellState.isOff(state))
				{
					temp += " ";
				}
				else
				{
					temp += CellState.StateChar[state];
				}
			}
			var chunks:Array = temp.match(/\S+/g);
			if (chunks.length == 0)
			{
				chunks.push("");
			}
			return chunks;
		}
		
		public function exportString() : String
		{
			var str:Array = new Array();
			var x:int;
			var y:int;
			var line:String;
			
			str.push("title: " + title_);
			str.push("size: " + width_ + ((width_!=height_) ? "x"+height_ : ""));
			str.push("");
			for(y=0;y<height_;y++)
			{
				line = "";
				for (x=0; x<width_; x++)
				{
					line += CellState.StateChar[getCell(x, y)];
				}
				str.push(line);
			}
			
			return str.join("\n");
		}
		
		public function importString(data_str:String) : Boolean
		{
			var data:Array = data_str.split("\n");
//			var index:int;
//			var line:String;
			var section:int = 0;
			var header_data:Array; 
			var v_size:int = 0;
			var v_title:String = "";
			var v_data:Array = new Array();
			var rx_body_line:RegExp;
			
			for each (var line:String in data)
			{
				switch(section)
				{
				case 0: // header
					if (line.match(/^\s*$/))
					{
						// end of header -> check for sanity and switch to section 1 (body)
						if (v_size>0)
						{
							rx_body_line = new RegExp("^[\\" + CellState.StateChar.join("\\") + "]{" + v_size + "}$");
							section = 1;
						}
					}
					else
					{
						if (line.match(/^\s*(\w+)\: (.*)$/))
						{
							header_data = line.split(": ", 2)
							switch(header_data[0].toString().replace(/\s/g, ""))
							{
							case "size":
								v_size = parseInt(header_data[1].toString(), 10);
								break;
							case "title":
								v_title = header_data[1];
								break;
							}
							
						}
					}
					break;
				case 1: // body
					if (line.match(rx_body_line))
					{
						for each (var char:String in line.split(""))
						{
							v_data.push(CellState.StateChar.indexOf(char));
						}
					}
					break;
				}
			}
			
			// check data sanity and change internal state if ok
			if (v_size>0 && v_data.length==(v_size*v_size))
			{
				width_ = height_ = v_size;
				title_ = v_title;
				data_ = v_data;
				return true;
			}

			return false;
		}

	}
}