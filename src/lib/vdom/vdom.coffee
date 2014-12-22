if typeof window=='object' then {require, exports, module} = twoside('/dc/vdom/vdom')
do (require=require, exports=exports, module=module) ->

  {extend} = require '../util'

  exports.Duplex = Duplex = (@attrPath) ->
  exports.duplex = (attrPath) -> new Duplex(attrPath)

  exports.Lane = Lane = (@attrPath) ->
  exports.lane = (attrPath) -> new Lane(attrPath)

  exports.Once = Once = (@attrPath) ->
  exports.once = (attrPath) -> new Once(attrPath)

  # bi means bidirectional binding, i.e. Duplex
  exports.bi = (attrPath) -> new Duplex(attrPath)

  # si means single way binding
  exports.si = (attrPath) -> new Lane(attrPath)

  class DomProxy
    constructor: (@template, @model, @mountElement) ->

    link: (model) ->
      for attr in @attrList
        Object.defineProperty model, attr,
          get: ->
            trace('get', model, attr)
            model[attr]
          set: (value) -> model[attr] = value

    mount: (element, mode, position) ->
      # mode: before, after, replace, position
      if not @created then @element = @create()
      element.appendChild(@element)

    render: ->
      if @created then @update()
      else @create()

    create: ->
      @created = true
      @template.create(@)

    update: ->
      @template.update(@)

  class Template
    makeProxy: (model, mountElement) ->
      htmlMaker = todo
      new DomProxy(@, model, mountElement)
    html: -> (proxy) ->
    createElement: -> (proxy) ->

  exports.List = class List extends Template
    constructor: (@items) ->
    makeProxy: -> new DomProxy()

  exports.list = (items...) -> new List(items)

  exports.Tag = class Tag extends Template
    constructor: (@tagName, @attrs, @children) ->

    makeProxy: ->
      new DomProxy(@)

    html: (model) ->
      attrsStr = (for key, value of @attrs then key+'='+'"'+value+'"').join(' ')
      childrenStr = (for child in @children then @children.create()).join('')
      '<'+@tagName+' '+attrsStr+'>'+childrenStr+'>'

    create: (vdom) ->
      if not vdom then vdom = new VDom(@)
      createElementFromHtml(vdom.html())

  exports.p = (attrs, children) -> new Tag('p', attrs, children)

  class Binary

  exports.add = (x, y) -> new Binary('+', x, y)

  input = (type, attrs) -> new Tag('input', extend({type:type}, attrs), [])
  exports.text = (value, attrs) -> input('text', extend({value:value}, attrs or {}))
  exports.text = (value, attrs) -> input('textarea', extend({value:value}, attrs or {}))
  exports.checkbox = (value, attrs) -> input('checkbox', extend({value:value}, attrs or {}))
  exports.radio = (value, attrs) -> input('radio', extend({value:value}, attrs or {}))
  exports.date = (value, attrs) -> input('date', extend({value:value}, attrs or {}))

  # http://stackoverflow.com/questions/494143/creating-a-new-dom-element-from-an-html-string-using-built-in-dom-methods-or-pro
  createElementFromHtml = (html) ->
    el = document.createElement('div')
    el.innerHTML = html
    el.childNodes

