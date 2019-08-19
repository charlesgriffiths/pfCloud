package pfCloud;


import haxe.ds.StringMap;


class PFUserData
{
static var updateUserData:String = "Client/UpdateUserData";
static var readUserData:String = "Client/GetUserData";


  static function setAuthentication( headers:StringMap<String> ):Bool
  {
  var sessionTicket:String = PFTransaction.getSessionTicket();

    if (null == sessionTicket) return false;

    headers.set( "X-Authentication", sessionTicket );

    return true;
  }


  static public function getUserDataList( keys:Array<String> ):PFTransaction
  {
    if (null == keys || 0 == keys.length) return null;

  var headers:StringMap<String> = new StringMap();

    if (!setAuthentication( headers )) return null;

    return new PFTransaction( readUserData ).addArgList( "Keys", keys ).send( headers, getUserDataCallback, getUserDataError );
  }

  static public function getUserData( key:String ):PFTransaction
  {
    if (null == key) return null;

    return getUserDataList( [key] );
  }

  static function getUserDataCallback( pft:PFTransaction )
  {
    trace( "getUserDataCallback()" );
  }

  static function getUserDataError( pft:PFTransaction )
  {
    trace( "getUserDataError()" );
  }


  static public function setUserData( key:String, value:String, ?isPublic:Bool=false ):PFTransaction
  {
  var headers:StringMap<String> = new StringMap();

    if (!setAuthentication( headers )) return null;

  var pft:PFTransaction = new PFTransaction( updateUserData ).addArg( "Data", "{\""+key+"\":\""+value+"\"}" );
  
    if (isPublic)
      pft.addArg( "Permission", "Public" );
  
    pft.send( headers, setUserDataCallback, setUserDataError );

    return pft;
  }

  
  static function setUserDataCallback( pft:PFTransaction )
  {
    trace( "setUserDataCallback()" );
  }

  static function setUserDataError( pft:PFTransaction )
  {
    trace( "setUserDataError()" );
  }



  static public function deleteUserDataList( keys:Array<String> ):PFTransaction
  {
    if (null == keys || 0 == keys.length) return null;

  var headers:StringMap<String> = new StringMap();

    if (!setAuthentication( headers )) return null;

    return new PFTransaction( updateUserData ).addArgList( "KeysToRemove", keys ).send( headers, deleteUserDataCallback, deleteUserDataError );
  }

  static public function deleteUserData( key:String ):PFTransaction
  {
    if (null == key) return null;

    return deleteUserDataList( [key] );
  }

  static function deleteUserDataCallback( pft:PFTransaction )
  {
    trace( "deleteUserDataCallback()" );
  }

  static function deleteUserDataError( pft:PFTransaction )
  {
    trace( "deleteUserDataError()" );
  }

}

