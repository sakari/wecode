define ['lib/vis/vis',
        'jquery',
        'react',
        'cs!src/tageditor',
        'cs!src/time'],
(vis, $, {createClass, DOM}, tageditor, time) ->
        createClass
                shouldComponentUpdate: (props, state) ->
                        unless props.position == @props.position
                                pos = time.zero(props.position * 1000)
                                unless state.dragging
                                        @_moveTimeline(state.timeline, pos)
                                @state.timeline.setCurrentTime(pos)
                        @state.item != state.item

                getInitialState: ->
                        opts =
                                showCurrentTime: true
                                zoomMax: 10 * 60 * 1000
                                zoomMin: 1000
                                showMajorLabels: false
                                editable: true
                                onAdd: ->
                                onUpdate: (item, cb) =>
                                        @setState item: item, cb: (i) =>
                                                @setState item: null, cb: null
                                                cb(i)
                                selectable: true
                        node = $('<div>')
                        timeline = new vis.Timeline(node[0], @props.tags.tags, opts)
                        timeline.on 'rangechanged', @_onDragEnd
                        timeline.on 'rangechange', @_onDrag
                        pos = time.zero(@props.position * 1000)

                        @_moveTimeline(timeline, pos)
                        timeline.setCurrentTime(pos)

                        item: null
                        cb: null
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
                                @props.events.push { 'timeScroll' : time.unzero(at) }
                                @setState { dragging: false}

                _onDrag: ({start, end}) ->
                        unless @_preventDragEvent
                                @setState { dragging: true}
                                at = (end.getTime() + start.getTime()) / 2
                                @state.timeline.setCurrentTime(at)
                                @props.events.push { 'timeScroll' : time.unzero(at) }

                componentDidMount: ->
                        $(@getDOMNode()).append(@state.node)

                render: ->
                        (DOM.div {},
                                (tageditor { ref: 'tageditor', events: @props.events, item: @state.item, cb: @state.cb }))
