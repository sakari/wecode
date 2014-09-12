define ['react', 'bootstrap'],
({createClass, DOM},
{Modal, Button, OverlayMixin, Input}) ->
        createClass
                mixins: [OverlayMixin]
                getInitialState: ->
                        open : false
                        id: null
                _close: ->
                        @setState open: false
                _open: ->
                        @setState open: true
                _submit: (e) ->
                        @props.events.push open: @state.id
                        e.preventDefault()
                        e.stopPropagation()
                        @_close()

                _input: (e) ->
                        @setState id: e.target.value
                        e.preventDefault()

                renderOverlay: ->
                        unless @state.open
                                DOM.span {}
                        else
                                (Modal { onRequestHide: @_close},
                                        (DOM.div { className: 'modal-body'},
                                                (DOM.form { onSubmit: @_submit },
                                                        (Input { type: 'text', placeholder: 'youtube id', onChange: @_input}))),
                                        (DOM.div { className: 'modal-footer'},
                                                (Button { onClick: @_close }, 'Close')))

                render: ->
                        Button { onClick: @_open, className: 'glyphicon glyphicon-cloud-download'}
