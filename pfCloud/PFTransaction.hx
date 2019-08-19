package pfCloud;


import haxe.crypto.Sha1;
import haxe.Json;
import haxe.ds.StringMap;
import js.html.XMLHttpRequest;



class PFTransaction
{
public var requestSentTime:Float;
public var responseReceivedTime:Float;
public var response:Dynamic;
public var responseStatus:Int;

static var pfKey:String = "B7TP5M41OBUGKSDKQRNI8RAG6MST35QWBK54AR7CXXKMGQNUHU";
public static var pfTitleID:String = "3C8F7";
static var pfAPIEndpoint:String = "https://3c8f7.playfabapi.com/";
static var pfPublisherID:String = "F6BE039364C4EB0F";

var args:Array<String>;
var dir:String;

static var pfCustomID:String = "";
static var sessionTicket:String = null;
static var entityToken:Dynamic = null;


  public function new( ?dir:String = "" )
  {
    requestSentTime = -1;
    responseReceivedTime = -1;
    response = null;
    responseStatus = -1;

    args = [];
    this.dir = dir;
  }


  static public function setCustomId( id:String )
  {
    pfCustomID = id;
  }

  static public function setSessionTicket( ticket:String )
  {
    sessionTicket = ticket;
    trace( "Session Ticket set to:" );
    trace( sessionTicket );
  }

  static public function getSessionTicket():String
  {
    return sessionTicket;
  }

  static public function setEntityToken( token:Dynamic )
  {
    entityToken = token;
    trace( "Entity Token set to:" );
    trace( entityToken );
  }


  public function addCustomId():PFTransaction
  {
    return addArg( "CustomId", pfCustomID );
  }
  public function addTitleId():PFTransaction
  {
    return addArg( "TitleId", pfTitleID);
  }

  public function addArg( name:String, value:String ):PFTransaction
  {
    args.push( "\"" + name + "\":\"" + value + "\"" );

    return this;
  }

  public function addArgList( name:String, list:Array<String> ):PFTransaction
  {
    args.push( "\"" + name + "\":[" + list.join( "," ) + "]" );

    return this;
  }

  public function getData():String
  {
  var ret:String = "";

    if (args.length > 0)
    {
      ret = "{" + args[0];

      for (i in 1...args.length)
        ret += "," + args[i];

      ret += "}";
    }

    return ret;
  }


  public function send( ?headers:StringMap<String> = null, ?callbackData:(PFTransaction)->Void = null, ?callbackError:(PFTransaction)->Void = null ):PFTransaction
  {
    sendPost( pfAPIEndpoint+dir, getData(), headers, callbackData, callbackError );

    return this;
  }


  public function sendPost( url:String, data:String, ?headers:StringMap<String> = null, ?callbackData:(PFTransaction)->Void = null, ?callbackError:(PFTransaction)->Void = null ):Void
  {
trace( "url: " + url );
trace( "data: " + data );

    requestSentTime = Date.now().getTime();

  var req = new XMLHttpRequest( "" );

    req.open( "POST", url, true );

    req.setRequestHeader( "Content-type", "application/json" );

    if (null != headers)
      for (key in headers.keys())
        req.setRequestHeader( key, headers.get( key ));

    req.onreadystatechange = function() { onResponse( req, callbackData, callbackError ); }

    req.send( data );    
  }

  function onResponse( request:XMLHttpRequest, callbackData:(PFTransaction)->Void, callbackError:(PFTransaction)->Void ):Void
  {
    if (4 != request.readyState) return;

    responseReceivedTime = Date.now().getTime();
    response = Json.parse( request.responseText );
    responseStatus = request.status;

    if (200 == request.status && null != callbackData)
      callbackData( this );

    if (200 != request.status && null != callbackError)
      callbackError( this );
  }

}

