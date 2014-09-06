define ['lib/react',
        'cs!src/model',
        'cs!src/control',
        'cs!src/youtube',
        'lib/Bacon'],
({createClass, renderComponent, DOM},
Model,
control,
youtube,
Bacon) ->
        hello = createClass
                render: ->
                        DOM.div {},
                                (control @props.control ),
                                (youtube @props.youtube )
        new Model().render (m) ->
                renderComponent hello(m), document.getElementById('target')
