package
{
	public class DatabaseResource
	{
		private static var databaseResource:DatabaseResource = new DatabaseResource();
		
		//{region ENUM-DATABASE
		//}endregion ENUM-DATABASE
		
		public function DatabaseResource()
		{
			super();
			loadDatabase();
		}
		public static function getInstance():DatabaseResource {
			return databaseResource;
		}
		
		public static const SEATING_MAX_LEVEL:int = 5;
		public static const STORAGE_MAX_LEVEL:int = 4;
		public static const ENTERTAINMENT_MAX_LEVEL:int = 4;
		
		private var arrayOfDrinks:Array;
		private var arrayOfSeatings:Array;
		private var arrayOfShelfs:Array;
		private var arrayOfEntertainments:Array;
		private var arrayOfEvents:Array;
		private function loadDatabase():void {
			//CUSTOMER AKAN MERANDOM MINUMAN MANA YANG AKAN DIBELI. JIKA TIDAK ADA TIDAK JADI MEMBELI
			//SEKALI BELI MINUMAN (REFILL STOCK) = MINUMAN YANG DIBELI * SELL PRICE + SELL PRICE/2 (WORK IN PROGRESS)
			arrayOfDrinks = [
								[	"Name",		"Sell Price"],
								/*1*/[	"Pop Ice",		2.5],
								/*2*/[	"Coffee",		4],
								/*3*/[	"Tea",			3],
								/*4*/[	"Milk",			5],
								/*5*/[	"Ice",			0.5]
								];
								
			arrayOfSeatings = [//JUMLAH CUSTOMER YANG AKAN MEMBELI MINUMAN DALAM SATU WAKTU
								[		"Name",			"Capacity",	"Timer Duration",	"Price", "Extra Expense"],
								/*1*/[	"Counter Chair",	2,				2,				0,			0],
								/*2*/[	"Bar Stool",		3,				2,			150,			2],
								/*3*/[	"Long Bench",		3,				1,			300,			4],
								/*4*/[	"Outdoor Seatings",	4,				1,			500,			8],
								/*5*/[	"Table and Sofa",	4,				0.5,		800,			16]
								];
								
			arrayOfShelfs = [//JUMLAH MAKSIMAL STOCK MINUMAN (JUMLAH MINUMAN KETIKA MEMBELI = MAX CAP - STOCK)
								[		"Name",			"Capacity",			"Price"],
								/*1*/[	"Standard Counter",		8,			0],
								/*2*/[	"Sachet Hanger",		12,			100],
								/*3*/[	"Counter Racks",		24,			250],
								/*4*/[	"Floating Cabinet",		48,			450]
								];
								
			arrayOfEntertainments = [//MENAMBAH CHANCE CUSTOMER MEMBELI EXTRA MINUMAN
								[		"Name",			"Extra Chance",			"Price", "Extra Expense"],
								/*1*/[	"None",				0,						0,				0],
								/*2*/[	"Standard TV",		0.2,					300,			2],
								/*3*/[	"LED TV",			0.3,					450,			3],
								/*4*/[	"Projector",		0.5,					900,			8]
								];
								
			arrayOfEvents = [//MENAMBAH HARGA JUAL
								[		"Name",			"Extra Price",		"Price", "Duration"],
								/*1*/[	"None",					0,						0,			0],
								/*2*/[	"Movies",				2,						600,		20],
								/*3*/[	"E-Sport Tournament",	2,						900,		30],
								/*4*/[	"Live World Cup",		2,						1800,		60]
								];					
		}
		
		public function getDrinkName(_id:int = 0):String {
			return arrayOfDrinks[_id][0];
		}
		
		public function getDrinkSellPrice(_id:int = 0):Number {
			return arrayOfDrinks[_id][1];
		}
		
		public function getSeatingName(_id:int = 0):String {
			return arrayOfSeatings[_id][0];
		}
		
		public function getSeatingCapacity(_id:int = 0):int {
			return arrayOfSeatings[_id][1];
		}
		
		public function getSeatingTimerDuration(_id:int = 0):Number {
			return arrayOfSeatings[_id][2];
		}
		
		public function getSeatingPrice(_id:int = 0):int {
			return arrayOfSeatings[_id][3];
		}
		
		public function getSeatingExpense(_id:int = 0):int {
			return arrayOfSeatings[_id][4];
		}
		
		public function getShelfName(_id:int = 0):String {
			return arrayOfShelfs[_id][0];
		}
		
		public function getShelfCapacity(_id:int = 0):int {
			return arrayOfShelfs[_id][1];
		}
		
		public function getShelfPrice(_id:int = 0):int {
			return arrayOfShelfs[_id][2];
		}
		
		public function getEntertainmentName(_id:int = 0):String {
			return arrayOfEntertainments[_id][0];
		}
		
		public function getEntertainmentExtraChance(_id:int = 0):Number {
			return arrayOfEntertainments[_id][1];
		}
		
		public function getEntertainmentPrice(_id:int = 0):int {
			return arrayOfEntertainments[_id][2];
		}
		
		public function getEntertainmentExpense(_id:int = 0):int {
			return arrayOfEntertainments[_id][3];
		}
		
		public function getEventName(_id:int = 0):String {
			return arrayOfEvents[_id][0];
		}
		
		public function getEventExtraPrice(_id:int = 0):Number {
			return arrayOfEvents[_id][1];
		}
		
		public function getEventPrice(_id:int = 0):int {
			return arrayOfEvents[_id][2];
		}
		
		public function getEventDuration(_id:int = 0):int {
			return arrayOfEvents[_id][3];
		}
	}
}