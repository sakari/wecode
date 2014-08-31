define ['lib/react'], ({createClass, renderComponent, DOM}) ->
        hello = createClass
                render: ->
                        DOM.p {}, "aoeuaoeuaeou"
        renderComponent (hello {}), document.getElementById('target')
