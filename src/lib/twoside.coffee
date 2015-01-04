### twoside
make modules can be used on both server side and client side.
###
do ->
  oldrequire = window.require
  oldexports = window.exports
  oldmodule = window.module

  getStackTrace = ->
    obj = {}
    Error.captureStackTrace(obj, getStackTrace)
    obj.stack

  twoside = window.twoside = (path) ->
    window.require = oldrequire
    window.exports = oldexports
    window.module = oldmodule

    path = normalize(path)
    exports  = {}
    module = twoside._modules[path] = {exports:exports}
    modulePath =  path.slice(0, path.lastIndexOf("/")+1)
    require = (path) ->
      module  = twoside._modules[path]
      if module then return module.exports
      path = normalize(modulePath+path)
      module = twoside._modules[path]
      if !module
        console.log(getStackTrace())
        window.require = oldrequire
        window.exports = oldexports
        window.module = oldmodule
        throw path+' is a wrong twoside module path.'
      module.exports
    {require:require, exports:exports, module:module}
  twoside._modules = {}
  ### we can alias some external modules.###
  twoside.alias = (path, object) -> twoside._modules[path] = {exports:object}
  if (window and window._) then twoside.alias('lodash', window._)
  else if (typeof global != 'undefined' and global._)
    twoside.alias('lodash', global._) # node-webkit
    window._ = global._

  normalize = (path) ->
    if !path || path == '/' then return '/'
    target = []
    for token in path.split('/')
      if token == '..' then target.pop()
      else if token!= '' and token != '.' then target.push(token)
    ### for IE 6 & 7 - use path.charAt(i), not path[i] ###
    head = if path.charAt(0)=='/' or path.charAt(0)=='.' then '/' else ''
    head + target.join('/').replace(/[\/]{2,}/g, '/')
