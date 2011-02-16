package Resources
{
	import flash.utils.ByteArray;
	
	public class BoardList extends ByteArray
	{
		public function getBoards() : Array
		{
			var str:String = this.toString().replace("\r", "");
			return str.split("\n\n\n");
		}

	}
}