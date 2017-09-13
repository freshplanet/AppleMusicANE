package com.freshplanet.ane.AppleMusic.VOs {
public class AirAppleMusicPlaylist {

    private var _id:String;
    private var _name:String;

    public function AirAppleMusicPlaylist(id:String, name:String) {
        _id = id;
        _name = name;
    }

    public function get id():String {
        return _id;
    }

    public function get name():String {
        return _name;
    }
}
}
