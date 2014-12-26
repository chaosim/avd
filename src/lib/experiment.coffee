get = (model, x) ->
  if x instanceof Expression then x.get(model)
  else x

set = (model, x, value) ->
  if x instanceof Expression then x.set(model, value)
  throw new Error 'x is not property value expression of dc.js, can not be set value'

class Path
  constructor: (@list) ->

  get: (model) ->
    x = model
    for item in @path
      if x==null or x==undefined then break
      x = x[item]
    x

  set: (model, value) ->
    x = model
    for item in @path
      if x[item] then x = x[item]
      else x = x[item] = {}

class Expression
  constructor: -> throw new Error 'not implemented'
  get:(model) -> throw new Error 'not implemented'
  set: (model, value) -> throw new Error @constructor.name+' can not be set value'

class Constant extends Expression
  constructor: (@value) ->
  get: (model) -> @value

constant = (v) -> new Constant(v)

class Fn extends Expression
  constructor: (@fn) ->
  get: (model) -> fn()

class It extends Expression
  get: (model) -> model

it = new It()

class Lane extends Expression
  constructor: (@path) ->
  get: (model) -> getByPath(model, @path)

class Duplex extends Expression
  constructor: (@path, @host=it) ->
  get: (model) -> getByPath(model, @path)
  set: (model, value) -> setByPath(model, @path, value)

add = class Add extends Expression
  constructor: (@x, @y) ->
  get: (model) -> get(model, @x)+get(model, @y)

add = (x, y) -> new Add(x, y)

class IfExpr extends Expression
  constructor: (@test, @then_, @else_) ->
  get: (model) ->

class Property
  constructor: (@key, @value) ->
  link: (model) -> proxy(@, model)
  create: (vdom) ->

property = (key, value) -> new Property(key, value)

class Template
  constructor: ->

class Tag extends Template
  constructor: (@name, @props, @children) ->
  create: (model) ->
    m = @model
    e = createElement(tag.name)
    for prop in @props
      [key, exp] = prop
      createProperty(e, key, get(m, exp))
    for child in tag.children
      e.appendChild(child.create(model))
    e

  patch: (model, com) ->
    for prop in @props
      [key, exp] = prop
      if exp not instanceof Expression then continue
      else
        mirror = com.mirror
        v0 = get(mirror, exp); v1 = get(model, exp)
        if v1!=v0 then patches push [setProp, key, v2]

parseClassId = (str) ->
  [klasses, id] = str.split('#')
  [(for x in klasses.split('.') then x.trim()), id.trim()]

tag = (name, props, children) ->
  new Tag(name, props, children)

p = (klassID, props, children) ->
  tag('p'+'.'+klassId, props, children) ->

class IfElement extends Template
  constructor: (@test, @then_, @else_) ->

  link: (model) ->

  create: (comp) ->
    m = @model
    if get(m, @test) then get(m, @then_)
    else get(m, @else_)

  patch: (comp) ->
    test = get(m, @test)
    if test==@oldTest
      if test then @thenPatch
      else @elsePatch
    else
      if test then @elseToThenPatch
      else @thenToElsePatch

class IfProxy
  create: ->
    m = @model
    if get(m, @test) then get(m, @then_)
    else get(m, @else_)

  patch: ->
    test = get(m, @test)
    if test==@oldTest
      if test then @thenPatch
      else @elsePatch
    else
      if test then @elseToThenPatch
      else @thenToElsePatch


# Com is COMponent
class Com
  constructor: (@template, @model, @mountElement) ->
    @creater = -> console.log '<p>hello dc </p>'
    @patcher = -> console.log 'patching'
    if @mountElement then @create()

  create: ->
    @element = @creater()

  mount: (element) ->
    element.appendChild(@create())
    @mountElement = element

  unmount: ->
    @mountElement.removeChild(@element)

  render: ->  @patcher()

com = (template, model, element) ->
  new Com(template, model, element)

class Element
  appendChild: ->
  removeChild: ->
  change: ->

c = com(tag('p'), (model={}), new Element())
c.render()
c.unmount()