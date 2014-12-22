{a, b, c} = require('./vars')
vdom = list(text([a, sub(c, b)]), text([b, sub(c, a)]), text([c, sub(a, b)]))
vdom.link({a: 1, b: 2})
vdom.mount(getElementByTag('body'))