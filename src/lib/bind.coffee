link = (x, y, bindings) ->
  for item in bindings
    path0 = item.path
    path = parsePath(item.path)
    if item.duplex
      i = 0; child = x
      while i<path.length
        index = path[i]
        Object.defineProperty child, index, path, {
          set: (value) ->
             child[index] = value
             definePropertyForRightPaths(value)
        }
      Object.defineProperty y, path, {
        set: (value) ->
          y[path0] = value
          i = 0
          pathLength = path.length
          while i<path.length-1
            if child[index]==undefined then child = child[index] = {}
            else
              try child = child[index]
              catch e then error
            i++
          child[path[i]] = value
      }
    else if item.lane
      for index in path
        Object.defineProperty x, index, descriptor

