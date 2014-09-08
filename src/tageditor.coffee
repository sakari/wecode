define ['react', 'bootstrap'],
({createClass, DOM},
{Button, Modal, OverlayMixin, Input}) ->
        createClass
                mixins: [OverlayMixin]
                render: ->
                        DOM.span {}

                getInitialState: ->
                        tag: @props.item?.content

                componentWillReceiveProps: (props) ->
                        @setState tag: props.item?.content

                _submitTag: (e) ->
                        @props.item.content = @state.tag
                        @props.cb(@props.item)
                        e.preventDefault()

                _dismiss: ->
                        @props.cb(@props.item)

                _inputTag: (e) ->
                        @setState tag: e.target.value

                renderOverlay: ->
                        if !@props.item
                                @props.events.push tagging: false
                                DOM.span {}
                        else
                                console.log '<<', @state.tag
                                @props.events.push tagging: true
                                (Modal {  onRequestHide: @_dismiss },
                                        (DOM.div { className: 'modal-body'},
                                                (DOM.form { onSubmit: @_submitTag },
                                                        (Input { type: 'text', placeholder: 'tag', onChange: @_inputTag, defaultValue: @state.tag }))),
                                        (DOM.div { className: 'modal-footer'},
                                                (Button { onClick: @_dismiss }, 'Close'))
                                )
