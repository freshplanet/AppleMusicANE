/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 22/06/2017.
 */
package com.freshplanet.applemusicdemo {
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.events.Event;

public class UIView extends PanelScreen {

	/**
	 * ACTION IDs
	 */
	public static const CHECK_MEDIA_LIBRARY_AUTHORIZATION:String = "CHECK_MEDIA_LIBRARY_AUTHORIZATION";
	public static const CHECK_CLOUD_SERVICE_AUTHORIZATION:String = "CHECK_CLOUD_SERVICE_AUTHORIZATION";
	public static const REQUEST_AUTHORIZATION:String = "REQUEST_AUTHORIZATION";
	public static const PLAY_MEDIA_LIBRARY_SONGS:String = "PLAY_MEDIA_LIBRARY_SONGS";
	public static const NOW_PLAYING_ITEM:String = "NOW_PLAYING_ITEM";
	public static const CURRENT_PLAYBACK_STATE:String = "CURRENT_PLAYBACK_STATE";
	public static const TOGGLE_PLAY_PAUSE:String = "TOGGLE_PLAY_PAUSE";
	public static const SKIP:String = "SKIP";
	public static const SKIP_TO_BEGINNING:String = "SKIP_TO_BEGINNING";
	public static const SKIP_TO_PREVIOUS:String = "SKIP_TO_PREVIOUS";
	public static const STOP:String = "STOP";
	public static const SEARCH:String = "SEARCH";
	public static const PRESENT_TRIAL:String = "PRESENT_TRIAL";

	override protected function initialize():void {
		super.initialize();

		this.layout = new AnchorLayout();
		this.title = "AppleMusic";

		const spacing:Number = 20;

		var layoutData:AnchorLayoutData;
		var button:Button;



		layoutData = new AnchorLayoutData();
		layoutData.top = spacing;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Check Media Library Authorization");
		button.layoutData = layoutData;
		button.name = CHECK_MEDIA_LIBRARY_AUTHORIZATION;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Check Cloud Service Authorization");
		button.layoutData = layoutData;
		button.name = CHECK_CLOUD_SERVICE_AUTHORIZATION;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Request Authorization");
		button.layoutData = layoutData;
		button.name = REQUEST_AUTHORIZATION;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Now Playing Item");
		button.layoutData = layoutData;
		button.name = NOW_PLAYING_ITEM;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Current Playback State");
		button.layoutData = layoutData;
		button.name = CURRENT_PLAYBACK_STATE;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Skip To Beginning");
		button.layoutData = layoutData;
		button.name = SKIP_TO_BEGINNING;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Skip To Previous");
		button.layoutData = layoutData;
		button.name = SKIP_TO_PREVIOUS;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Play Media Library Songs");
		button.layoutData = layoutData;
		button.name = PLAY_MEDIA_LIBRARY_SONGS;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Toggle Play/Pause");
		button.layoutData = layoutData;
		button.name = TOGGLE_PLAY_PAUSE;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Skip");
		button.layoutData = layoutData;
		button.name = SKIP;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Stop");
		button.layoutData = layoutData;
		button.name = STOP;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Perform Apple Music Catalog Search");
		button.layoutData = layoutData;
		button.name = SEARCH;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

		layoutData = new AnchorLayoutData();
		layoutData.topAnchorDisplayObject = button;
		layoutData.top = spacing;
		layoutData.left = spacing;
		layoutData.right = spacing;

		button = createButton("Present Trial");
		button.layoutData = layoutData;
		button.name = PRESENT_TRIAL;
		button.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(button);

	}

	private function onButtonTriggered(event:Event):void {
		var args:Array = null;

		var button:Button = Button(event.target);
		this.dispatchEventWith(button.name, true, args);
	}

	private function createButton(label:String):Button {
		const buttonHeight:Number = 50;
		var button:Button = new Button();
		button.label = label;
		button.height = buttonHeight;
		return button;
	}
}
}
