if typeof window=='object' then {require, exports, module} = twoside('/dc/demo/once')
do (require=require, exports=exports, module=module) ->
  window.onload = ->
    {a, b} = require '../vars'
    {list, text, add, p} = require '../vdom/vdom'
    template = p(1)
    model = {}
    d = template(model)
    trace body
    vdom.mount('body')