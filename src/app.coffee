define ['react',
        'cs!src/timeline',
        'cs!src/model',
        'cs!src/control',
        'cs!src/youtube',
        'lib/Bacon'],
({createClass, renderComponent, DOM},
timeline,
Model,
control,
youtube,
Bacon) ->
        hello = createClass
                render: ->
                        DOM.div {},
                                (youtube @props.youtube ),
                                (control @props.control ),
                                (timeline @props.timeline )

        new Model().render (m) ->
                renderComponent hello(m), document.getElementById('target')
