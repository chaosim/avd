if typeof window=='object' then {require, exports, module} = twoside('/dc/vars')
do (require=require, exports=exports, module=module) ->

  {bi, si, once} = require('./vdom/vdom')

  for x in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    exports[x] = bi(x)
    exports['_'+x] = si(x)
    exports['$'+x] = once(x)
