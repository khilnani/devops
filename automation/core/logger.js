//----------------------------------------------

var logger = exports,
    util = require('./util');

// 0, 1, 2, 3, 4, 5, 6
var log_types = ["system", "error", "warn", "event", "info", "debug", "trace"];
var log_labels = ["[SYSTEM]","[ERROR] ", "[WARN]  ", "[EVENT] ", "[INFO]  ", "[DEBUG] ", "[TRACE] "];
var log_level = 4;  // info and higher


//----------------------------------------------

function log(level, message, stackLevel) 
{ 
  var index = log_types.indexOf(level);
  if (index <= log_level ) 
  {
    if (typeof message !== 'string') 
    {
      message = JSON.stringify(message);
    }
    
    if(index == 1) message = "*** " + message;
                  
    console.log( util.timestamp() + ' - ' + log_labels[index] + ' '+ message);
  }
}

//----------------------------------------------


logger.setLogLevel = function (level)
{
  if(level != undefined && level != null && level >= 0 &&  level < log_types.length)
  {
    log_level = level;
    log("system", "logger.setLogLevel() " + log_types[log_level].toUpperCase());
//   this.system(log_types[log_level].toUpperCase());
  }
  else
  {
    log("system", "logger.setLogLevel() Invalid level: " + level + ". Using: " + log_types[log_level].toUpperCase());
//  this.system("Invalid level: " + level + ". Using: " + log_types[log_level].toUpperCase());
  }
}

//----------------------------------------------

logger.system = function( message ) 
{
  log("system", message);
}

logger.event = function( message ) 
{
  log("event", message);
}

logger.error = function( message ) 
{
  log("error", message);
}

logger.warn = function( message ) 
{
  log("warn", message);
}


logger.info = function( message ) 
{
  log("info", message);
}

logger.debug = function( message ) 
{
  log("debug", message);
}

logger.trace = function( message ) 
{
  log("trace", message);
}

//----------------------------------------------
