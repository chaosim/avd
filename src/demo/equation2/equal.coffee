{a, b, c} = require('./vars')
vdom = list(text(a), text(b), text(c))
x = {a: 1, b: 2}

vdom.link(x)
vdom.mount(getElementByTag('body'))

vdom.append(p(1))

