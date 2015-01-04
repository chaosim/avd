if typeof window=='object' and typeof twoside == 'function'
  {require, exports, module} = twoside('/dcom/component')

do (require=require, exports=exports, module=module) ->

  if typeof exports != 'object'
    dcom = window.dcom or {}
    exports = dcom

  exports.Component = class Component
    constructor: ->  throw new Error 'abstract base class can not be instantiated'
    create: ->
    render: ->

  exports.Tag = class Tag extends Component
    constructor: (@name, @props, @children, @namespace) ->
      @element = null

    create: (document=document) ->
      if @namespace then @element = element = document.createElement(tag.name)
      else @element = element = document.createElementNS(@namespace, tag.name)
      @cache = cache = {}
      for key, exp of @props
        @createProperty(key, exp)
      for child in tag.children
        if child instanceof Component then element.appendChild(child.create())
        else if child instanceof Expression then element.append(document.createTextNode(get(child)))
      element

    createProperty: (key, exp) ->
      if exp instanceof Expression
        v = get(exp)
        cache[key] = v
      else v = exp

    render: ->
      if not @element then @create()
      else @patch()

    patch: ->
      element = @element; cache = @cache
      for prop in @props
        [key, exp] = prop
        if exp not instanceof Expression then continue
        else
          v0 = @cache[key]; v = get(exp)
          if v!=v0
            element.setProp(key, v)
            cache[key] = v

  exports.tag = (name, props, children) ->
    new Tag(name, props, children)

  exports.p = (klassID, props, children) ->
    tag('p'+'.'+klassId, props, children) ->

  exports.If class If extends Component
    constructor: (@test, @then_, @else_) ->

    create: ->
      if get(@test)
        @element = @then_.create()
      else
        @element = @else_.create()
      @element

    render: ->
      test = @oldTest
      if test
        if !@oldTest then @else_.remove()
        @then_.render()
      else
        if @oldTest then @then_.remove()
        @else_.render()
      @oldTest = test

  exports.List = class List extends Component
    constructor: (@list, @virtualElementMaker) ->
      lst = @list

      lst.push = (args...) ->
        i = lst.length
        for x in args then indexList.push({i:i++})
        Array.prototype.push.apply(this, args)

      lst.pop = ->
        indexList = @indexList
        indexList.pop()
        Array.prototype.pop.apply(this, arguments)

      lst.unshift = (args...) ->
        indexList = @indexList
        for m in indexList
          m.index++
        i = args.length
        while i<args.length then indexList.unshift({i:--i})
        Array.prototype.unshift.apply(this, arguments)

      lst.shift = ->
        indexList = @indexList
        Array.prototype.shift.apply(this, arguments)
        indexList.shift()
        for m in indexList then m.index--

      lst.splice = (i, count) ->
        deleted = Array.prototype.splice.apply(this, arguments)
        insert = Array.prototype.slice.call(arguments, 2)

      lst.reverse = ->
        result = Array.prototype.reverse.apply(this, arguments)
        length = lst.length
        @remove()
        for index, i in indexList
          index.i = length-1-i
          indexList.unshift(index)
          @virtualElementList[i].mount()
          @virtualElementList[i].render()

      lst.sort = ->
        result = Array.prototype.sort.apply(this, arguments)
        @remove()
        indexList = @indexList

    create: ->
      @virtualElementList = []
      @indexList = []
      i = 0; lst = @lst; lstLength = lst.length
      while i<lstLength
        index = {i:i}
        @indexList.push(index)
        @virtualElementList[i] = tpl = itemComponent(index)
        tpl.create()
        i++

    render: ->
      for e in @virtualElementList
        e.render()

  exports.input = input = (type, attrs) -> new Tag('input', extend({type:type}, attrs), [])
  exports.text = (value, attrs) -> input('text', extend({value:value}, attrs or {}))
  exports.textarea = (value, attrs) -> input('textarea', extend({value:value}, attrs or {}))
  exports.checkbox = (value, attrs) -> input('checkbox', extend({value:value}, attrs or {}))
  exports.radio = (value, attrs) -> input('radio', extend({value:value}, attrs or {}))
  exports.date = (value, attrs) -> input('date', extend({value:value}, attrs or {}))

  # http://stackoverflow.com/questions/494143/creating-a-new-dom-element-from-an-html-string-using-built-in-dom-methods-or-pro
  createElementFromHtml = (html) ->
    el = document.createElement('div')
    el.innerHTML = html
    el.childNodes

  exports.parseClassId = (str) ->
    [klasses, id] = str.split('#')
    [(for x in klasses.split('.') then x.trim()), id.trim()]

