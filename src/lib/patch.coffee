if typeof window=='object' then {require, exports, module} = twoside('/dc/vars')
do (require=require, exports=exports, module=module) ->

  equal = (x, y) ->

  ConstFn = (x) -> x

  EqualFn = (attr) -> getAttr(model, attr)

  patch = (vdom) ->
    if vdom instanceof constFn then return new Noop()
    else if vdom instanceof equalFn then return (oldValue, newValue) ->
      if newValue==oldValue then return
      else parent.set(newValue)
    else if vdom instanceof If then return

  If = class
    constructor: (@watcher, @then_, @else_) ->
    @getPatch: ->
      oldValue = @oldValue; newValue = @watcher()
      if newValue==oldValue then new EmptyPatch()
      else if newValue
        if @patchThen then @patchThen
        else patchDiff(@then_, @else_)
      else
        if @patchElse then @patchElse
        else patchDiff(@else_, @then_)


  if_ (-> counter > 0), p('greater than 0'), p('less than 0')
  if_ (-> counter > 0), (-> p(counter+'> 0')), (-> p(counter+'<=0'))
  if_  (-> counter > 0), p(span('sdaf'), textnode(list((-> counter), '> 0'))), (-> p(counter+'<=0'))

  Tag = class
    constructor: (@tagName, @props, @children) ->
    getPatch: ->

  d = new Vdom('<p>adfs</p>')

  if a>0 then d.appendChild('<p>wula</p>')
  else d.replaceWith('<p>dfs</p>')

  d.css('width', 1)

  d.on('click', (event) -> x.css('height', 10+'px'))

  a = textInput(x); b = textInput(y); c = textInput(y)
  a.on('change', -> x = a.value)
  b.on('change', -> y = b.value)
  c.on('change', -> z = c.value)

  a = textInput(->x); b = textInput(->y); c = textInput(z)

  duplex = (attr) -> (model) ->
    a = textInput(-> model[attr])
    a.on('change', -> model[attr] = a.value)

  bind = duplex('a')
  model = {x:1}

  vdom = bind(model)

  a = textInput(-> model.x)

  duplex = (path) -> (model) ->
    a = textInput( -> getAttrValue(model, attr))
    a.on('change', -> setAttrValue(model, a.value))

  duplex = (path) -> (vdom) -> (model) ->
    vdom.on('getValue', -> getAttrValue(model, attr))
    vdom.on('change', -> setAttrValue(model, a.value))

  lane = (path) -> (vdom) -> (model) ->
    vdom.on('getValue', -> getAttrValue(model, attr))

  add = (x, y) -> (vdom) -> (model) ->
    vdom.on 'value', -> x.value + y.value
    vdom.on 'change', -> throw new Error 'can not change the value of add by binding'

  class Property
    constructor: (@key, @_value) ->

