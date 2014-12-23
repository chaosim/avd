class Constant
  constructor: (@value) ->
  link: (model, proxy) ->
    Object.defineProperty proxy, 'value'
      get: -> value
      set: (v) -> throw new Error 'constant can not be set value'
  get: (model) -> @value
  set: (model, value) -> throw new Error 'constant can not be set value'

constant = (v) -> new Constant(v)
constant(1)

class Fn
  constructor: (@fn) ->
  get: (model) -> fn()
  set: (model, value) -> throw new Error 'fn can not be set value'

class Lane
  constructor: (@path) ->
  get: (model) -> model[@path]
  set: (model, value) -> throw new Error 'lane can not be set value'

class Duplex
  constructor: (@path) ->
  get: (model) -> model[@path]
  set: (model, value) -> model[@path] = value

add = class Add
  constructor: (@x, @y) ->
  link: (model, proxy) ->
  get: (model) -> @x.get(model)+@y.get(model)
  set: (model, value) ->  throw new Error 'operation can not be set value'

add = (x, y) -> new Add(x, y)

add(1, 2)

class Property
  constructor: (@key, @value) ->
  link: (model) ->
    (vdom) ->

property = (key, value) -> new Property(key, value)

class Tag
  constructor: (@name, @props, @children) ->
  link: (model) -> (com) ->
    for p in @props
      linkProp = p.link(model)(c)

class Template
  constructor: () ->

class Proxy
  constructor: (template, model) ->

# Com is COMponent
class Com
  constructor: (@proxy) ->
  clone: ->
  create: ->
  mount: (element) ->
  unmount: (element) ->
  render: ->

tag = (name, props, children) ->
  new Tag(name, props, children)

c = new Com(proxy)

c = com(tag(model), element)

proxy = tag.link(model)

c.mount(element)

constant = (v) -> (model) -> (vdom) ->
  Object.defineProperty vdom, 'value',
    get: -> v
    set: (v) -> vdom.v = v