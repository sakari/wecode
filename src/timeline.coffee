define ['lib/vis/vis',
        'jquery',
        'react'],
(vis, $, {createClass, DOM}) ->
        createClass
                shouldComponentUpdate: (props, state) ->
                        unless props.position == @props.position
                                unless state.dragging
                                        @_preventDragEvent = true
                                        state.timeline.moveTo(@_zerotime(props.position * 1000), { animate: false })
                                        @_preventDragEvent = false
                                @state.timeline.setCurrentTime(@_zerotime(props.position * 1000))
                        false

                _zerotime: (time) ->
                        time - 2 * 1000 * 60 * 60

                _unzerotime: (time) ->
                        time + 2 * 1000 * 60 * 60

                getInitialState: ->
                        items = new vis.DataSet([
                                {id: 1, content: 'item 1', start: @_zerotime(10)},
                                {id: 3, content: 'item 3', start: @_zerotime(1000)}
                                ])
                        opts =
                                showCurrentTime: true
                                zoomMax: 10 * 60 * 1000
                                zoomMin: 1000
                                showMajorLabels: false
                        node = $('<div>')
                        timeline = new vis.Timeline(node[0], items, opts)
                        timeline.on 'rangechanged', @_onDragEnd
                        timeline.on 'rangechange', @_onDrag
                        dragging: false
                        node: node
                        timeline: timeline

                _onDragEnd: ({start, end}) ->
                        unless @_preventDragEvent
                                at = (end.getTime() + start.getTime()) / 2
                                @state.timeline.setCurrentTime(at)
                                @props.events.push { 'timeScroll' : @_unzerotime(at) }
                                @setState { dragging: false}

                _onDrag: ({start, end}) ->
                        unless @_preventDragEvent
                                @setState { dragging: true}
                                at = (end.getTime() + start.getTime()) / 2
                                @state.timeline.setCurrentTime(at)
                                @props.events.push { 'timeScroll' : @_unzerotime(at) }

                componentDidMount: ->
                        $(@getDOMNode()).append(@state.node)

                render: ->
                        DOM.div {}
