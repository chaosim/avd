if typeof window=='object' then {require, exports, module} = twoside('/dc/demo/sum')
do (require=require, exports=exports, module=module) ->
  window.onload = ->
    {a, b} = require '../vars'
    {list, text, add, p} = require '../vdom/vdom'
    template = list(text(a), text(b), p(add(a, b)))
    vdom = template.create()
    vdom.link({a: 1, b: 2})
    body = document.getElementsByTagName('body')[0]
    trace body
    vdom.mount(body)