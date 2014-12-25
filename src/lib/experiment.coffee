parseClassId = (str) ->
  [klasses, id] = str.split('#')
  [(for x in klasses.split('.') then x.trim()), id.trim()]

getValueByPath = (model, path) ->
  x = model
  for item in path
    if x==null or x==undefined then break
    x = x[item]
  x

getValue = (model, x) ->
  if x instanceof expression then x.get(model)
  else x

setvalue = (model, x, value) ->
  if x instanceof expression then x.set(model, value)
  throw new Error 'x is not property value expression of dc.js, can not be set value'

setValueByPath = (model, path, value) ->
  x = model
  for item in path
    if x[item] then x = x[item]
    else x = x[item] = {}

setModelValue(0, ['a', 1, 'b'], 1)

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
  get: (model) -> model[@path]

class Duplex extends Expression
  constructor: (@path, @host=it) ->
  get: (model) -> model[@path]
  set: (model, value) -> model[@path] = value

add = class Add extends Expression
  constructor: (@x, @y) ->
  get: (model) -> @x.get(model)+@y.get(model)

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
  link: (model) ->
    new Com(@, model)

tag = (name, props, children) ->
  new Tag(name, props, children)

p = (klassID, props, children) ->
  tag('p'+'.'+klassId, props, children) ->

class IfElement extends Template
  constructor: (@test, @then_, @else_) ->
  link: (model) ->

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

model = {}
c = com(tag('p'), model, new Element())
c.render()
c.unmount()