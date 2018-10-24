package
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.geom.ColorTransform;
	import flash.system.fscommand;
	
	public class GameplayManager extends MovieClip
	{
		//{region INITIALIZATION
		public function GameplayManager()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(_event:Event = null):void
		{
			gotoAndStop(1);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initSplashScreen();
		}
		
		private function initSplashScreen():void
		{
			button_play.addEventListener(MouseEvent.CLICK, onClickPlayButton);
		}
		
		private function onClickPlayButton(e:MouseEvent):void
		{
			gotoAndStop(2);
			startCore();
		}
		
		private function initEndScreen():void
		{
			button_replay.addEventListener(MouseEvent.CLICK, onClickReplayButton);
		}
		
		private function onClickReplayButton(e:MouseEvent):void
		{
			button_replay.removeEventListener(MouseEvent.CLICK, onClickReplayButton);
			init();
		}
		
		private function startCore()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			activateAllEventListener();
			activateAllButtons();
			GameplayDataManager.getInstance().resetData();
			setInitialGameData();
			setLoss(false);
		}
		
		//}endregion INITIALIZATION
		
		//{region EVENT AND BODY LOGIC OF THE GAME
		
		private function onEnterFrame(e:Event):void
		{
		}
		
		private function setInitialGameData():void
		{
			GameplayDataManager.getInstance().resetData();
			updateUiText();
		}
		
		private function onFrequentlyUpdateResource():void
		{
			updateEvent();
			customerBuyDrink();
			calculateExpenses();
			updateUiText();
			checkDisco();
			checkMoney();
			if (!isLoss())
				TweenMax.delayedCall(DatabaseResource.getInstance().getSeatingTimerDuration(GameplayDataManager.getInstance().getSeatingLevel()), onFrequentlyUpdateResource);
		}
		
		private function checkMoney():void
		{
			if (GameplayDataManager.getInstance().getMoney() <= 0)
			{
				setLoss(true);
				deactivateAllButtons();
				gotoAndStop(3);
				initEndScreen();
			}
		}
		
		private function checkStock():Boolean
		{
			for (var i:int = 1; i < 5; i++)
			{
				if (GameplayDataManager.getInstance().getDrinkStock(i) != 0)
				{
					return true;
				}
			}
			return false;
		}
		
		private function startGame():void
		{
			onFrequentlyUpdateResource();
		}
		
		//UI FUNCTION REGION ###############################################################################################
		
		private function updateUiText():void
		{
			updateUpgradeText();
			updateUpgradeUI();
			updateDrinkStockText();
			updateMoneyText();
			updateEventText();
			updateEventUi();
		}
		
		private function updateEventText():void
		{
			if (!isEventRunning())
			{
				entertainmentStatus_txt.text = "";
			}
			else
			{
				entertainmentStatus_txt.text = DatabaseResource.getInstance().getEventName(GameplayDataManager.getInstance().getEventLevel()).toString();
			}
		}
		
		private function updateEventUi():void
		{
			if (!isEventRunning())
			{
				bar_eventDuration.scaleX = 0;
			}
			else
			{
				bar_eventDuration.scaleX = (GameplayDataManager.getInstance().getEventDuration() - GameplayDataManager.getInstance().getEventTimer()) / GameplayDataManager.getInstance().getEventDuration();
			}
		}
		
		private function updateUpgradeUI():void
		{
			if (isUpgradingSeating())
			{
				bar_seatingUpgrade.scaleX = 1;
			}
			else
			{
				bar_seatingUpgrade.scaleX = 0;
			}
			
			if (isUpgradingStorage())
			{
				bar_storageUpgrade.scaleX = 1;
			}
			else
			{
				bar_storageUpgrade.scaleX = 0;
			}
			
			if (isUpgradingEntertainment())
			{
				bar_entertainmentUpgrade.scaleX = 1;
			}
			else
			{
				bar_entertainmentUpgrade.scaleX = 0;
			}
		}
		
		private function updateUpgradeText():void
		{
			updateSeatingText();
			updateStorageText();
			updateEntertainmentText();
		}
		
		private function updateEntertainmentText():void
		{
			if (GameplayDataManager.getInstance().getEntertainmentLevel() < DatabaseResource.ENTERTAINMENT_MAX_LEVEL)
			{
				entertainmentLevel_txt.text = "lv." + (GameplayDataManager.getInstance().getEntertainmentLevel() - 1).toString();
				entertainmentUpgradeCost_txt.text = "$" + DatabaseResource.getInstance().getEntertainmentPrice(GameplayDataManager.getInstance().getEntertainmentLevel() + 1).toString() + ".00";
			}
			else
			{
				entertainmentLevel_txt.text = "lv. Max";
				entertainmentUpgradeCost_txt.text = "";
			}
		}
		
		private function updateStorageText():void
		{
			if (GameplayDataManager.getInstance().getStorageLevel() < DatabaseResource.STORAGE_MAX_LEVEL)
			{
				storageLevel_txt.text = "lv." + GameplayDataManager.getInstance().getStorageLevel().toString();
				storageUpgradeCost_txt.text = "$" + DatabaseResource.getInstance().getShelfPrice(GameplayDataManager.getInstance().getStorageLevel() + 1).toString() + ".00";
			}
			else
			{
				storageLevel_txt.text = "lv. Max";
				storageUpgradeCost_txt.text = "";
			}
		}
		
		private function updateSeatingText():void
		{
			if (GameplayDataManager.getInstance().getSeatingLevel() < DatabaseResource.SEATING_MAX_LEVEL)
			{
				seatingLevel_txt.text = "lv." + GameplayDataManager.getInstance().getSeatingLevel().toString();
				seatingUpgradeCost_txt.text = "$" + DatabaseResource.getInstance().getSeatingPrice(GameplayDataManager.getInstance().getSeatingLevel() + 1).toString() + ".00";
			}
			else
			{
				seatingLevel_txt.text = "lv. Max";
				seatingUpgradeCost_txt.text = "";
			}
		}
		
		private function updateMoneyText():void
		{
			money_txt.text = "$" + GameplayDataManager.getInstance().getMoney().toFixed(2);
		}
		
		private function updateDrinkStockText():void
		{
			bar_popIceStock.scaleY = GameplayDataManager.getInstance().getDrinkStock(ENUM_POPICE) / DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel());
			bar_coffeeStock.scaleY = GameplayDataManager.getInstance().getDrinkStock(ENUM_COFFEE) / DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel());
			bar_teaStock.scaleY = GameplayDataManager.getInstance().getDrinkStock(ENUM_TEA) / DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel());
			bar_milkStock.scaleY = GameplayDataManager.getInstance().getDrinkStock(ENUM_MILK) / DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel());
			bar_iceStock.scaleY = GameplayDataManager.getInstance().getDrinkStock(ENUM_ICE) / (DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel()) * 3);
		}
		
		//DRINK FUNCTION REGION ###############################################################################################
		
		private function countCustomer():String
		{
			return (4 * DatabaseResource.getInstance().getSeatingCapacity(GameplayDataManager.getInstance().getSeatingLevel()) / DatabaseResource.getInstance().getSeatingTimerDuration(GameplayDataManager.getInstance().getSeatingLevel())).toString();
		}
		
		private function customerBuyDrink():void
		{
			for (var i:int = 0; i < DatabaseResource.getInstance().getSeatingCapacity(GameplayDataManager.getInstance().getSeatingLevel()); i++)
			{
				drinkPurchasement(false);
				secondDrinkPurchasement();
			}
		}
		
		private function secondDrinkPurchasement():void
		{
			if (DatabaseResource.getInstance().getEntertainmentExtraChance(GameplayDataManager.getInstance().getEntertainmentLevel()) > 0)
			{
				var temp:Number = Math.random();
				if (DatabaseResource.getInstance().getEntertainmentExtraChance(GameplayDataManager.getInstance().getEntertainmentLevel()) > temp)
				{
					drinkPurchasement(true);
				}
			}
		}
		
		private function customerGiveTip():void
		{
			GameplayDataManager.getInstance().addMoney(0.5);
		}
		
		private function drinkPurchasement(_isSecondPurchase:Boolean = false):void
		{
			var temp:int = Math.floor((Math.random() * 4) + 1);
			if (GameplayDataManager.getInstance().getDrinkStock(temp) > 0)
			{
				if (_isSecondPurchase)
				{
					customerGiveTip();
				}
				if (GameplayDataManager.getInstance().getDrinkStock(ENUM_ICE) > 0)
				{
					addMoneyFromDrinkPurchase(temp, true);
					drainDrinkStock(temp, true);
				}
				else
				{
					addMoneyFromDrinkPurchase(temp, false);
					drainDrinkStock(temp, false);
				}
			}
			else
			{
				GameplayDataManager.getInstance().addMoney(-1);
			}
		}
		
		private function drainDrinkStock(_drinkId:int = 0, _isIce:Boolean = false):void
		{
			GameplayDataManager.getInstance().addDrinkStock(_drinkId, -1);
			if (_isIce)
			{
				GameplayDataManager.getInstance().addDrinkStock(ENUM_ICE, -1);
			}
		}
		
		private function addMoneyFromDrinkPurchase(_drinkId:int = 0, _isIce:Boolean = false):void
		{
			if (GameplayDataManager.getInstance().getEventLevel() > 1)
			{
				GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getDrinkSellPrice(_drinkId) * DatabaseResource.getInstance().getEventExtraPrice(GameplayDataManager.getInstance().getEventLevel()));
				
				if (_isIce)
				{
					GameplayDataManager.getInstance().addMoney((DatabaseResource.getInstance().getDrinkSellPrice(ENUM_ICE) + 1) * DatabaseResource.getInstance().getEventExtraPrice(GameplayDataManager.getInstance().getEventLevel()));
				}
			}
			else
			{
				GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getDrinkSellPrice(_drinkId));
				if (_isIce)
				{
					GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getDrinkSellPrice(ENUM_ICE) + 1);
				}
			}
		}
		
		private function refillDrink(_drinkId:int):void
		{
			var amount:int;
			if (_drinkId == ENUM_ICE)
			{
				amount = Math.floor((GameplayDataManager.getInstance().getMoney() - 2) / ((DatabaseResource.getInstance().getDrinkSellPrice(_drinkId) * 0.8) + 0.2));
				if (amount > (DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel()) * 3) - GameplayDataManager.getInstance().getDrinkStock(_drinkId))
					amount = (DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel()) * 3) - GameplayDataManager.getInstance().getDrinkStock(_drinkId);
				GameplayDataManager.getInstance().addMoney((((DatabaseResource.getInstance().getDrinkSellPrice(_drinkId) * -0.8) + 0.2) * amount) - 2);
			}
			else
			{
				amount = Math.floor((GameplayDataManager.getInstance().getMoney() - 2) / ((DatabaseResource.getInstance().getDrinkSellPrice(_drinkId) * 0.8) + 0.5));
				if (amount > DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel()) - GameplayDataManager.getInstance().getDrinkStock(_drinkId))
					amount = DatabaseResource.getInstance().getShelfCapacity(GameplayDataManager.getInstance().getStorageLevel()) - GameplayDataManager.getInstance().getDrinkStock(_drinkId);
				GameplayDataManager.getInstance().addMoney((((DatabaseResource.getInstance().getDrinkSellPrice(_drinkId) * -0.8) + 0.5) * amount) - 2);
			}
			addDrinkStock(_drinkId, amount);
		}
		
		private function addDrinkStock(_drinkId:int, _amount:int):void
		{
			GameplayDataManager.getInstance().addDrinkStock(_drinkId, _amount);
		}
		
		private function calculateExpenses():void
		{
			GameplayDataManager.getInstance().addMoney(GameplayDataManager.getInstance().getExpenses() * -1);
		}
		
		//EVENT FUNCTION REGION ###############################################################################################
		
		private function updateEvent():void
		{
			if (GameplayDataManager.getInstance().getEventLevel() > 1)
			{
				if (GameplayDataManager.getInstance().getEventTimer() < GameplayDataManager.getInstance().getEventDuration())
				{
					GameplayDataManager.getInstance().addEventTimer(1);
					trace("Timer " + GameplayDataManager.getInstance().getEventTimer() + "/" + GameplayDataManager.getInstance().getEventDuration());
				}
				else
				{
					setEventRunning(false);
					GameplayDataManager.getInstance().setEventLevel(1);
					GameplayDataManager.getInstance().setEventTimer(0);
					GameplayDataManager.getInstance().setEventDuration(0);
				}
			}
		}
		
		private function startEvent(_eventId:int):void
		{
			setEventRunning(true);
			GameplayDataManager.getInstance().setEventLevel(_eventId);
			changeEventDuration();
		}
		
		private function changeEventDuration():void
		{
			if (GameplayDataManager.getInstance().getEventLevel() > 1)
			{
				GameplayDataManager.getInstance().setEventDuration(DatabaseResource.getInstance().getEventDuration(GameplayDataManager.getInstance().getEventLevel()) / DatabaseResource.getInstance().getSeatingTimerDuration(GameplayDataManager.getInstance().getSeatingLevel()));
				changeEventTimerOnChangedDuration();
			}
		}
		
		private function changeEventTimerOnChangedDuration():void
		{
			GameplayDataManager.getInstance().setEventTimer(GameplayDataManager.getInstance().getEventTimer() * (DatabaseResource.getInstance().getSeatingTimerDuration(GameplayDataManager.getInstance().getSeatingLevel() - 1) / DatabaseResource.getInstance().getSeatingTimerDuration(GameplayDataManager.getInstance().getSeatingLevel())));
		}
		
		//UPGRADE FUNCTION REGION ###############################################################################################
		
		private function upgradeSeating():void
		{
			setUpgradingSeating(false);
			GameplayDataManager.getInstance().addSeatingLevel(1);
			GameplayDataManager.getInstance().addExpenses(DatabaseResource.getInstance().getSeatingExpense(GameplayDataManager.getInstance().getSeatingLevel()));
			changeEventDuration();
			updateUiText();
		}
		
		private function upgradeStorage():void
		{
			setUpgradingStorage(false);
			GameplayDataManager.getInstance().addStorageLevel(1);
			updateUiText();
		}
		
		private function upgradeEntertainment():void
		{
			setUpgradingEntertainment(false);
			GameplayDataManager.getInstance().addEntertainmentLevel(1);
			GameplayDataManager.getInstance().addExpenses(DatabaseResource.getInstance().getEntertainmentExpense(GameplayDataManager.getInstance().getEntertainmentLevel()));
			updateUiText();
		}
		
		//MISC ###########################################################################################################
		
		private function checkDisco():void
		{
			if (isDisco())
			{
				paintBackground();
			}
		}
		
		private function resetBackground():void
		{
			setDisco(false);
			background.transform.colorTransform = new ColorTransform(0.68, 0.68, 0.68);
		}
		
		private function paintBackground():void
		{
			background.transform.colorTransform = new ColorTransform(Math.random() * 2.55, Math.random() * 2.55, Math.random() * 2.55);
		}
		
		private function activateAllEventListener():void
		{
		}
		
		private function removeAllEventListener():void
		{
		}
		
		//}endregion EVENT AND BODY LOGIC OF THE GAME
		
		//{region BUTTONS
		private function activateAllButtons(_event:Event = null):void
		{
			startGame_btn.addEventListener(MouseEvent.CLICK, onClickStartGameButton);
			popIceRefill_btn.addEventListener(MouseEvent.CLICK, onClickPopIceRefillButton);
			coffeeRefill_btn.addEventListener(MouseEvent.CLICK, onClickCoffeeRefillButton);
			teaRefill_btn.addEventListener(MouseEvent.CLICK, onClickTeaRefillButton);
			milkRefill_btn.addEventListener(MouseEvent.CLICK, onClickMilkRefillButton);
			iceRefill_btn.addEventListener(MouseEvent.CLICK, onClickIceRefillButton);
			seatingUpgrade_btn.addEventListener(MouseEvent.CLICK, onClickUpgradeSeating);
			storageUpgrade_btn.addEventListener(MouseEvent.CLICK, onClickUpgradeStorage);
			entertainmentUpgrade_btn.addEventListener(MouseEvent.CLICK, onClickUpgradeEntertainment);
			eventBoxing_btn.addEventListener(MouseEvent.CLICK, onClickStartEventBoxingMatch);
			eventFilm_btn.addEventListener(MouseEvent.CLICK, onClickStartBoxOfficeFilm);
			eventCup_btn.addEventListener(MouseEvent.CLICK, onClickStartLiveWorldCup);
			changeBackground_btn.addEventListener(MouseEvent.CLICK, onClickChangeBackground);
		}
		
		private function deactivateAllButtons(_event:Event = null):void
		{
			startGame_btn.removeEventListener(MouseEvent.CLICK, onClickStartGameButton);
			popIceRefill_btn.removeEventListener(MouseEvent.CLICK, onClickPopIceRefillButton);
			coffeeRefill_btn.removeEventListener(MouseEvent.CLICK, onClickCoffeeRefillButton);
			teaRefill_btn.removeEventListener(MouseEvent.CLICK, onClickTeaRefillButton);
			milkRefill_btn.removeEventListener(MouseEvent.CLICK, onClickMilkRefillButton);
			iceRefill_btn.removeEventListener(MouseEvent.CLICK, onClickIceRefillButton);
			seatingUpgrade_btn.removeEventListener(MouseEvent.CLICK, onClickUpgradeSeating);
			storageUpgrade_btn.removeEventListener(MouseEvent.CLICK, onClickUpgradeStorage);
			entertainmentUpgrade_btn.removeEventListener(MouseEvent.CLICK, onClickUpgradeEntertainment);
			eventBoxing_btn.removeEventListener(MouseEvent.CLICK, onClickStartEventBoxingMatch);
			eventFilm_btn.removeEventListener(MouseEvent.CLICK, onClickStartBoxOfficeFilm);
			eventCup_btn.removeEventListener(MouseEvent.CLICK, onClickStartLiveWorldCup);
			changeBackground_btn.removeEventListener(MouseEvent.CLICK, onClickChangeBackground);
		}
		
		//region BUTTONS_FUNCTION
		
		private function onClickChangeBackground(e:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getMoney() > 500)
			{
				setDisco(true);
				GameplayDataManager.getInstance().addMoney(-500);
				TweenMax.delayedCall(10, resetBackground);
			}
		}
		
		private function onClickStartEventBoxingMatch(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getEntertainmentLevel() > 1)
			{
				if (!isEventRunning())
				{
					startEvent(ENUM_EVENT_BOXINGMATCH);
				}
			}
		}
		
		private function onClickStartBoxOfficeFilm(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getEntertainmentLevel() > 1)
			{
				if (!isEventRunning())
				{
					startEvent(ENUM_EVENT_BOXOFFICEFILM);
				}
			}
		}
		
		private function onClickStartLiveWorldCup(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getEntertainmentLevel() > 1)
			{
				if (!isEventRunning())
				{
					startEvent(ENUM_EVENT_WORLDCUP);
				}
			}
		}
		
		private function onClickUpgradeSeating(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getSeatingLevel() < DatabaseResource.SEATING_MAX_LEVEL && GameplayDataManager.getInstance().getMoney() > DatabaseResource.getInstance().getSeatingPrice(GameplayDataManager.getInstance().getSeatingLevel() + 1))
			{
				if (!isUpgrading())
				{
					setUpgradingSeating(true);
					bar_seatingUpgrade.scaleX = 1;
					GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getSeatingPrice(GameplayDataManager.getInstance().getSeatingLevel() + 1) * -1);
					updateMoneyText();
					TweenMax.delayedCall(2, upgradeSeating);
				}
			}
		}
		
		private function onClickUpgradeStorage(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getStorageLevel() < DatabaseResource.STORAGE_MAX_LEVEL && GameplayDataManager.getInstance().getMoney() > DatabaseResource.getInstance().getShelfPrice(GameplayDataManager.getInstance().getStorageLevel() + 1))
			{
				if (!isUpgrading())
				{
					setUpgradingStorage(true);
					bar_storageUpgrade.scaleX = 1;
					GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getShelfPrice(GameplayDataManager.getInstance().getStorageLevel() + 1) * -1);
					updateMoneyText();
					TweenMax.delayedCall(2, upgradeStorage);
				}
			}
		}
		
		private function onClickUpgradeEntertainment(_mouseEvent:MouseEvent):void
		{
			if (GameplayDataManager.getInstance().getEntertainmentLevel() < DatabaseResource.ENTERTAINMENT_MAX_LEVEL && GameplayDataManager.getInstance().getMoney() > DatabaseResource.getInstance().getEntertainmentPrice(GameplayDataManager.getInstance().getEntertainmentLevel() + 1))
			{
				if (!isUpgrading())
				{
					setUpgradingEntertainment(true);
					bar_entertainmentUpgrade.scaleX = 1;
					GameplayDataManager.getInstance().addMoney(DatabaseResource.getInstance().getEntertainmentPrice(GameplayDataManager.getInstance().getEntertainmentLevel() + 1) * -1);
					updateMoneyText();
					TweenMax.delayedCall(5, upgradeEntertainment);
				}
				
			}
		}
		
		private function onClickIceRefillButton(_mouseEvent:MouseEvent):void
		{
			refillDrink(ENUM_ICE);
			updateUiText();
		}
		
		private function onClickMilkRefillButton(_mouseEvent:MouseEvent):void
		{
			refillDrink(ENUM_MILK);
			updateUiText();
		}
		
		private function onClickTeaRefillButton(_mouseEvent:MouseEvent):void
		{
			refillDrink(ENUM_TEA);
			updateUiText();
		}
		
		private function onClickCoffeeRefillButton(_mouseEvent:MouseEvent):void
		{
			refillDrink(ENUM_COFFEE);
			updateUiText();
		}
		
		private function onClickPopIceRefillButton(_mouseEvent:MouseEvent):void
		{
			refillDrink(ENUM_POPICE);
			updateUiText();
		}
		
		private function onClickStartGameButton(_mouseEvent:MouseEvent):void
		{
			if (checkStock())
			{
				startGame();
			}
		}
		
		//}endregion BUTTONS
		
		//{region ATTACHER-REMOVER
		
		private function removeAllExistingObjects():void
		{
		}
		//}endregion ATTACHER-REMOVER
		
		//{region SETTER-GETTER
		private static const ENUM_POPICE:int = 1;
		private static const ENUM_COFFEE:int = 2;
		private static const ENUM_TEA:int = 3;
		private static const ENUM_MILK:int = 4;
		private static const ENUM_ICE:int = 5;
		private static const ENUM_EVENT_BOXINGMATCH:int = 2;
		private static const ENUM_EVENT_BOXOFFICEFILM:int = 3;
		private static const ENUM_EVENT_WORLDCUP:int = 4;
		
		private var loss:Boolean = false;
		
		private function isLoss():Boolean
		{
			return loss;
		}
		
		private function setLoss(_loss:Boolean = false):void
		{
			loss = _loss;
		}
		
		private var disco:Boolean = false;
		
		private function isDisco():Boolean
		{
			return disco;
		}
		
		private function setDisco(_disco:Boolean = false):void
		{
			disco = _disco;
		}
		
		private var upgradingSeating:Boolean = false;
		private var upgradingStorage:Boolean = false;
		private var upgradingEntertainment:Boolean = false;
		
		private function isUpgrading():Boolean
		{
			if (isUpgradingSeating())
				return true;
			
			if (isUpgradingStorage())
				return true;
			
			if (isUpgradingEntertainment())
				return true;
			
			return false;
		}
		
		private function isUpgradingSeating():Boolean
		{
			return upgradingSeating;
		}
		
		private function setUpgradingSeating(_upgradingSeating:Boolean = false):void
		{
			upgradingSeating = _upgradingSeating;
		}
		
		private function isUpgradingStorage():Boolean
		{
			return upgradingStorage;
		}
		
		private function setUpgradingStorage(_upgradingStorage:Boolean = false):void
		{
			upgradingStorage = _upgradingStorage;
		}
		
		private function isUpgradingEntertainment():Boolean
		{
			return upgradingEntertainment;
		}
		
		private function setUpgradingEntertainment(_upgradingEntertainment:Boolean = false):void
		{
			upgradingEntertainment = _upgradingEntertainment;
		}
		
		private var eventRunning:Boolean = false;
		
		private function isEventRunning():Boolean
		{
			return eventRunning;
		}
		
		private function setEventRunning(_eventRunning:Boolean):void
		{
			eventRunning = _eventRunning;
		}
		//}endregion SETTER-GETTER
		public static const EVENT_REMOVE:String = "EVENT_REMOVE";
		
		public function remove():void
		{
			removeAllEventListener();
			deactivateAllButtons();
			removeAllExistingObjects();
			this.removeChildren();
			dispatchEvent(new Event(EVENT_REMOVE));
		}
	}
}