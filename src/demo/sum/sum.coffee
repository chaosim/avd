if typeof window=='object' then {require, exports, module} = twoside('/dcom/demo/sum')

do (require=require, exports=exports, module=module) ->
  window.onload = ->
    {vars} = require '../expression'
    {$a, $b, _a, _b} = vars({a: 1, b: 2})
    {list, text, add, p} = require '../component'
    comp = list(text($a), text($b), p(add(_a, _b)))
    comp.mount(document.getElementsByTagName('body')[0])
    update = -> comp.render()
    setInterval update, 100