package {

import com.freshplanet.applemusicdemo.AppRoot;

import feathers.utils.ScreenDensityScaleFactorManager;


import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageAspectRatio;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;

[SWF (backgroundColor="#000000", frameRate=60)]
public class AppleMusicDemo extends Sprite {

	private var _starling:Starling;
	private var _scaler:ScreenDensityScaleFactorManager;
	public function AppleMusicDemo() {
		stage ? init() : addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
    }

	private function init(event:flash.events.Event = null):void {

		if(event)
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);

		stage.setAspectRatio( StageAspectRatio.PORTRAIT );
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		this.stage.align = StageAlign.TOP_LEFT;

		_starling = new Starling(AppRoot, stage, new Rectangle(0,0,stage.fullScreenWidth, stage.fullScreenHeight));

		_starling.start();
		_starling.showStats = true;

		this._scaler = new ScreenDensityScaleFactorManager(this._starling);

	}
}
}
