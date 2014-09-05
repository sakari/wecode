define ['lib/react', 'cs!src/youtube'], ({createClass, renderComponent, DOM}, youtube) ->
        hello = createClass
                render: ->
                        DOM.p {}, "aoeuaoeuaeou"
        renderComponent (youtube {
                height: '390',
                width: '640',
                videoId: 'Oh2TNO5CGXQ'
        }) ,document.getElementById('target')
