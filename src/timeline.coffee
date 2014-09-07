define ['lib/vis/vis',
        'jquery',
        'react'],
(vis, $, {createClass, DOM}) ->
        createClass
                shouldComponentUpdate: (props, state) ->
                        unless props.position == @props.position
                                unless state.dragging
                                        @_moveTimeline(state.timeline, @_zerotime(props.position * 1000))
                                @state.timeline.setCurrentTime(@_zerotime(props.position * 1000))
                        false

                _zerotime: (time) ->
                        time - 2 * 1000 * 60 * 60

                _unzerotime: (time) ->
                        time + 2 * 1000 * 60 * 60

                getInitialState: ->
                        opts =
                                showCurrentTime: true
                                zoomMax: 10 * 60 * 1000
                                zoomMin: 1000
                                showMajorLabels: false
                        node = $('<div>')
                        timeline = new vis.Timeline(node[0], @props.tags.tags, opts)
                        timeline.on 'rangechanged', @_onDragEnd
                        timeline.on 'rangechange', @_onDrag
                        pos = @_zerotime(@props.position * 1000)

                        @_moveTimeline(timeline, pos)
                        timeline.setCurrentTime(pos)

                        dragging: false
                        node: node
                        timeline: timeline

                _moveTimeline: (timeline, pos) ->
                        @_preventDragEvent = true
                        timeline.moveTo(pos, { animate: false })
                        @_preventDragEvent = false

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
