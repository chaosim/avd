parseClassId = (str) ->
  [klasses, id] = str.split('#')
  klasses = str.split('.')
  [klasses, id]

getModelValue = (model, path) -> model[path]

setModelValue = (model, path, value) -> model[path] = value

class Operand
  constructor: -> throw new Error 'not implemented'
  get:(model) -> throw new Error 'not implemented'
  set: (model, value) -> throw new Error @constructor.name+' can not be set value'

class Constant extends Operand
  constructor: (@value) ->
  get: (model) -> @value

constant = (v) -> new Constant(v)

class Fn
  constructor: (@fn) ->
  get: (model) -> fn()

class Lane
  constructor: (@path) ->
  get: (model) -> model[@path]

class Duplex
  constructor: (@path) ->
  get: (model) -> model[@path]
  set: (model, value) -> model[@path] = value

add = class Add
  constructor: (@x, @y) ->
  get: (model) -> @x.get(model)+@y.get(model)

add = (x, y) -> new Add(x, y)

class IfExpr
  constructor: (@test, @then_, @else_) ->
  get: (model) ->

class Property
  constructor: (@key, @value) ->
  link: (model) -> proxy(@, model)
  create: (vdom) ->

property = (key, value) -> new Property(key, value)

class Template
  constructor: () ->

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