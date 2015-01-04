if typeof window=='object' and typeof twoside == 'function'
  {require, exports, module} = twoside('/dcom/expression')

do (require=require, exports=exports, module=module) ->

  if typeof exports != 'object'
    dcom = window.dcom or {}
    exports = dcom

  exports.get = get = (x) ->
    if x instanceof Expression then x.get()
    else if typeof(x)=='function' then x()
    else x

  exports.set = set = (x, value) ->
    if x instanceof Expression then x.set(value)
    throw new Error 'can not be set value'

  exports.Expression = class Expression
    constructor: -> throw new Error 'not implemented'
    get: -> throw new Error 'not implemented'
    set: (value) -> throw new Error @constructor.name+' can not be set value'

  exports.Fn = class Fn extends Expression
    constructor: (@fn) ->
    get: -> @fn()

  exports.Add = class Add extends Expression
    constructor: (@x, @y) ->
    get: -> get(@x)+get(@y)

  exports.add = (x, y) -> new Add(x, y)

  exports.Sibind = class Sibind extends Sibind
    constructor: (@obj, @attr) ->
    get: ->
      obj = @obj
      if obj==null or obj==undefined then break
      obj(get(@attr))

  exports.Bibind = class Bibind extends Sibind
    constructor: (@obj, @attr) ->
    set: (value) ->
      obj = @obj
      if typeof obj !='object' then throw new Error 'can not be set value'
      obj[get(@attr)] = value

  exports.Lane = class Lane
    constructor: (@list) ->

    get: ->
      lst = @list; x = lst[0]
      for item in lst[1...]
        if x==null or x==undefined then break
        x = x[item]
      x

  exports.Duplex = class Duplex extends Lane
    set: (value) ->
      lst = @list; x = lst[0]
      if lst.length<=1 then return
      if typeof x !='object' then throw new Error 'can not be set value'
      for item in lst[1...lst.length-1]
        item = get(item)
        y = x[item]
        if typeof y !='object'
          if y!=undefined then throw new Error 'can not be set value'
          else y = x[item] = {}
        x = y
      x[get(item)] = value

  exports.If = class If extends Expression
    constructor: (@test, @then_, @else_) ->
    get: -> if get(@test) then get(@then_) else get(@else_)

  exports.if_ = (test, then_, else_) -> new If(test, then_, else_)

  exports.List = class list extends Expression
    constructor: (@list) ->
    get: -> for x in @list then get(x)

  exports.list = (args...) -> new List(args)