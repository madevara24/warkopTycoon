package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * (Please rearrange the package builder if required!)
	 * This is a general object class
	 * @author Sepay Team
	 * using Quick Code framework v1.0
	 * Created by Julian 'Sepay' Renaldi @2017
	 */
	
	/*
	 * PERLAKUKAN SEPERTI DATABASE
	 * INISIALISASIKAN VARIABEL UNTUK UANG, LEVEL UPGRADE, DSB
	 * PAKAI SETTER GETTER SEPERTI BIASA
	 *
	 */
	public class GameplayDataManager extends MovieClip
	{
		//{region INITIALIZATION
		public function GameplayDataManager()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(_event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		private static var gameplayDataManager:GameplayDataManager = new GameplayDataManager();
		
		public static function getInstance():GameplayDataManager
		{
			return gameplayDataManager;
		}
		
		public function resetData():void
		{
			setMoney(500);
			setExpenses(4);
			arrayOfDrinkStock = [0, 0, 0, 0, 0];
			setSeatingLevel(1);
			setStorageLevel(1);
			setEntertainmentLevel(1);
			setEventLevel(1);
			//cheat();
		}
		
		private function cheat():void{
			setMoney(20000);
			setExpenses(2);
			setSeatingLevel(DatabaseResource.SEATING_MAX_LEVEL);
			setStorageLevel(DatabaseResource.STORAGE_MAX_LEVEL);
			setEntertainmentLevel(DatabaseResource.ENTERTAINMENT_MAX_LEVEL);
			setEventLevel(1);
			arrayOfDrinkStock = [
				DatabaseResource.getInstance().getShelfCapacity(getStorageLevel()), 
				DatabaseResource.getInstance().getShelfCapacity(getStorageLevel()), 
				DatabaseResource.getInstance().getShelfCapacity(getStorageLevel()), 
				DatabaseResource.getInstance().getShelfCapacity(getStorageLevel()), 
				DatabaseResource.getInstance().getShelfCapacity(getStorageLevel()) * 3
				];
		}
		
		//}endregion INITIALIZATION
		
		//{region SETTER-GETTER
		//{subregion eventTimer
		private var eventTimer:int = 0;
		public function setEventTimer(_eventTimer:int = 0):void {
			eventTimer = _eventTimer;
		}
		public function getEventTimer():int {
			return eventTimer;
		}
		public function addEventTimer(_eventTimer:int = 1):void {
			eventTimer += _eventTimer;
		}
		//}endsubregion eventTimer
		//{subregion eventDuration
		private var eventDuration:int = 0;
		public function setEventDuration(_eventDuration:int = 0):void {
			eventDuration = _eventDuration;
		}
		public function getEventDuration():int {
			return eventDuration;
		}
		public function addEventDuration(_eventDuration:int = 1):void {
			eventDuration += _eventDuration;
		}
		//}endsubregion eventDuration
		//{subregion eventLevel
		private var eventLevel:int = 0;
		public function setEventLevel(_eventLevel:int = 0):void {
			eventLevel = _eventLevel;
		}
		public function getEventLevel():int {
			return eventLevel;
		}
		public function addEventLevel(_eventLevel:int = 1):void {
			eventLevel += _eventLevel;
		}
		//}endsubregion eventLevel
		//{subregion seatingLevel
		private var seatingLevel:int = 0;
		public function setSeatingLevel(_seatingLevel:int = 0):void {
			seatingLevel = _seatingLevel;
		}
		public function getSeatingLevel():int {
			return seatingLevel;
		}
		public function addSeatingLevel(_seatingLevel:int = 1):void {
			seatingLevel += _seatingLevel;
		}
		//}endsubregion seatingLevel
		//{subregion storageLevel
		private var storageLevel:int = 0;
		public function setStorageLevel(_storageLevel:int = 0):void {
			storageLevel = _storageLevel;
		}
		public function getStorageLevel():int {
			return storageLevel;
		}
		public function addStorageLevel(_storageLevel:int = 1):void {
			storageLevel += _storageLevel;
		}
		//}endsubregion storageLevel
		//{subregion entertainmentLevel
		private var entertainmentLevel:int = 0;
		public function setEntertainmentLevel(_entertainmentLevel:int = 0):void {
			entertainmentLevel = _entertainmentLevel;
		}
		public function getEntertainmentLevel():int {
			return entertainmentLevel;
		}
		public function addEntertainmentLevel(_entertainmentLevel:int = 1):void {
			entertainmentLevel += _entertainmentLevel;
		}
		//}endsubregion storageLevel
		//{subregion expenses
		private var expenses:Number = 0;
		
		public function setExpenses(_expenses:Number = 0):void
		{
			expenses = _expenses;
		}
		
		public function getExpenses():Number
		{
			return expenses;
		}
		
		public function addExpenses(_expenses:Number = 1):void
		{
			expenses += _expenses;
		}
		//}endsubregion expenses
		//{subregion money
		private var money:Number = 0;
		
		public function setMoney(_money:Number = 0):void
		{
			money = _money;
		}
		
		public function getMoney():Number
		{
			return money;
		}
		
		public function addMoney(_money:Number = 1):void
		{
			money += _money;
		}
		//}endsubregion money
		
		//{subregion drinkStockAmmount
		private var arrayOfDrinkStock:Array;
		
		public function setDrinkStock(_stock:int = 0, _id:int = 0):void
		{
			arrayOfDrinkStock[_id-1] = _stock;
		}
		
		public function getDrinkStock(_id:int=0):Number
		{
			return arrayOfDrinkStock[_id-1];
		}
		
		public function addDrinkStock(_id:int=0, _stock:Number = 1):void
		{
			arrayOfDrinkStock[_id-1] += _stock;
		}
		//}endsubregion drinkStockAmmount
	
		//}endregion SETTER-GETTER
	}
}
