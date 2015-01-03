get = (x) ->
  if x instanceof Expression then x.get()
  else x

set = (x, value) ->
  if x instanceof Expression then x.set(value)
  throw new Error 'can not be set value'

class Expression
  constructor: -> throw new Error 'not implemented'
  get: -> throw new Error 'not implemented'
  set: (value) -> throw new Error @constructor.name+' can not be set value'

class Fn extends Expression
  constructor: (@fn) ->
  get: -> @fn()

add = class Add extends Expression
  constructor: (@x, @y) ->
  get: -> get(@x)+get(@y)

add = (x, y) -> new Add(x, y)

class IfExpr extends Expression
  constructor: (@test, @then_, @else_) ->
  get: -> if get(@test) then get(@then_) else get(@else_)

class Lane
  constructor: (@list) ->

  get: ->
    lst = @list; x = lst[0]
    for item in lst[1...]
      if x==null or x==undefined then break
      x = x[item]
    x

class Duplex extends Lance
  set: (value) ->
    if lst.length<=1 then return
    lst = @list; x = lst[0]
    if typeof x !='object' then throw new Error 'can not be set value'
    for item in lst[1...lst.length-1]
      item = get(item)
      y = x[item]
      if typeof y !='object'
        if y!=undefined then throw new Error 'can not be set value'
        else y = x[item] = {}
      x = y
    x[get(item)] = value

class Property
  constructor: (@key, @value) ->
  create: (vdom) ->

property = (key, value) -> new Property(key, value)

class VirtualElement
  constructor: ->
  create: ->
  render: ->

class Tag extends VirtualElement
  constructor: (@name, @props, @children) ->
    @element = null

  create: ->
    @element = element = createElement(tag.name)
    @cache = cache = {}
    for prop in @props
      [key, exp] = prop
      if exp instanceof Expression
        v = get(exp)
        cache[key] = v
      else v = exp
      createProperty(element, key, v)
    for child in tag.children
      element.appendChild(child.create())
    element

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

parseClassId = (str) ->
  [klasses, id] = str.split('#')
  [(for x in klasses.split('.') then x.trim()), id.trim()]

tag = (name, props, children) ->
  new Tag(name, props, children)

p = (klassID, props, children) ->
  tag('p'+'.'+klassId, props, children) ->

class IfElement extends VirtualElement
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

class ListElement extends VirtualElement
  constructor: (@list, @virtualElementMaker) ->
    lst = @list

    lst.push = (args...) ->
      i = lst.length
      for x in args then modelList.push({list:lst, index:i++})
      Array.prototype.push.apply(this, args)

    lst.pop = ->
      modelList = @modelList
      modelList.pop()
      Array.prototype.pop.apply(this, arguments)

    lst.unshift = (args...) ->
      modelList = @modelList
      for m in modelList
        m.index++
      i = args.length
      while i<args.length then modelList.unshift({list:lst, index:--i})
      Array.prototype.unshift.apply(this, arguments)

    lst.shift = ->
      modelList = @modelList
      Array.prototype.shift.apply(this, arguments)
      modelList.shift()
      for m in modelList then m.index--

    lst.splice = (i, count) ->
      deleted = Array.prototype.splice.apply(this, arguments)
      insert = Array.prototype.slice.call(arguments, 2)

    lst.reverse = ->
      result = Array.prototype.reverse.apply(this, arguments)
      modelList = []
      @remove()
      for m, i in @modelList
        m.index = @modelList.length-i
        modelList.unshift(m)
        @elementList[i].mount()
        @elementList[i].render()

    lst.sort = ->
      result = Array.prototype.sort.apply(this, arguments)
      @remove()
      modelList = @modelList

  create: ->
    @virtualElementList = []
    @modelList = []
    i = 0; lst = @lst; lstLength = lst.length
    while i<lstLength
      model = {list:lst, index:i}
      @modelList.push(model)
      @virtualElementList[i] = tpl = itemVirtualElement(model)
      tpl.create()
      i++

  render: ->

class Element
  appendChild: ->
  removeChild: ->
  change: ->

c = com(tag('p'), (model={}), new Element())
c.render()
c.unmount()