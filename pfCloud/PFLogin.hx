package pfCloud;

import kha.math.Random;


class PFLogin
{
static var loginWithCustomID:String = "Client/LoginWithCustomID";


  static public function loginCustom( ?create:Bool=false ):PFTransaction
  {
    return new PFTransaction( loginWithCustomID ).addCustomId().addArg( "CreateAccount", create?"true":"false" ).addTitleId().send( null, loginCallback, loginError );
  }

  static public function loginCustomRandom( ?prependid:String = "id" ):PFTransaction
  {
    PFTransaction.setCustomId( prependid + Random.get() );

    return loginCustom( true );
  }


  static function loginCallback( pft:PFTransaction )
  {
    trace( "loginCallback start: " + pft.requestSentTime );
    trace( "loginCallback finish: " + pft.responseReceivedTime + " " + (pft.responseReceivedTime - pft.requestSentTime));
    trace( "loginCallback status: " + pft.responseStatus );
    trace( "loginCallback response: " + pft.response );

    trace( "data: " + pft.response.data );
    trace( "session ticket: " + pft.response.data.SessionTicket );
    trace( ": $$$" + pft.response.data.SessionTicket + "$$$" );

    PFTransaction.setSessionTicket( pft.response.data.SessionTicket );
    PFTransaction.setEntityToken( pft.response.data.EntityToken );
  }


  static function loginError( pft:PFTransaction )
  {
    trace( "loginError()" );
  }

/*
  function getLoginData( customID:String, createAccount:Bool ):String
  {
    return "{\"CustomId\":\""+ customID +"\",\"CreateAccount\":"+ (createAccount?"true":"false") +",\"TitleId\":\""+PFTransaction.pfTitleID+"\"}";
  }

  public function sendLogin( create:Bool )
  {
  var url:String = pfAPIEndpoint+loginWithCustomID;
  var data:String = getLoginData( "test driver", create );
  var headers:StringMap<String> = new StringMap();

    headers.set( "Content-type", "application/json" );

trace( "sendLogin() : " + url );
trace( "sendLogin() : " + data );

    sendPost( url, data, headers, loginCallback, loginError );
  }
/**/
}

