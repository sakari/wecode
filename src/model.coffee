define ['lib/Bacon',
        'lib/vis/vis',
        'cs!src/time'],
(Bacon, vis, time) ->
        class Timeline
                constructor: ({@tags}) ->
                        @events = new Bacon.Bus
                        @position = 0
        class Tags
                constructor: ->
                        @tags = new vis.DataSet([])

                addTag: (tag, at) ->
                        console.log 'adding tag', tag, at
                        @tags.add [{ id: @_tagId(), content: tag, start: time.zero(at * 1000) }]

                _tagId: ->
                        chars = 'abcdef1234567890'
                        ([0..20].map -> chars[Math.floor(Math.random() * chars.length)]).join('')

        class Youtube
                constructor: ->
                        @height =  390
                        @width = 640
                        @mode = 'stop'
                        @events = new Bacon.Bus
                        @playbackRate = 1
                        @commands = new Bacon.Bus
                        @events.map('.position').onValue (v) =>
                                return unless v?
                                @currentPosition = v
                seekTo: (position) ->
                        @commands.push({ seekTo: position })
        class Control
                constructor: ->
                        @allowedPlaybackRates = []
                        @selectedPlaybackRate =  1
                        @events = new Bacon.Bus

        class Model
                _trigger: ->
                        @_change.push(true)
                render: (renderer) ->
                        @_renderer ||= renderer
                        @_renderer(@)
                        @
                constructor:->
                        @_change = new Bacon.Bus
                        @_change.onValue @render.bind(@)
                        @control = new Control
                        @youtube = new Youtube
                        @tags = new Tags
                        @timeline = new Timeline tags: @tags

                        @control.events.map('.open').onValue (v) =>
                                return unless v
                                @youtube.videoId = v
                                @_trigger()

                        @control.events.map('.tag').onValue (v) =>
                                return unless v
                                @tags.addTag v, @youtube.currentPosition
                                @_trigger()

                        @youtube.events.map('.playerReady').onValue (v) =>
                                return unless v?
                                @youtube.mode = 'stop'
                                @_trigger()

                        @youtube.events.map('.position').onValue (v) =>
                                return unless v?
                                @timeline.position = v
                                @_trigger()

                        @timeline.events.map('.timeScroll').onValue (v) =>
                                return unless v? && v > 0
                                @youtube.mode = 'pause'
                                @_trigger()
                                @youtube.seekTo(v / 1000)

                        @youtube.events.map('.playback-rates').onValue (v) =>
                                return unless v
                                @control.allowedPlaybackRates = v
                                @_trigger()

                        @control.events.map('.step').onValue (v) =>
                                return unless v?
                                @youtube.mode = 'pause'
                                @_trigger()
                                @youtube.seekTo(@youtube.currentPosition + v)

                        @control.events.map('.playback-rate').filter((a) -> a).onValue (v) =>
                                @youtube.playbackRate = v
                                @control.selectedPlaybackRate = v
                                @_trigger()

                        @control.events.map('.mode').onValue (v) =>
                                return unless v?
                                @youtube.mode = v
                                @_trigger()

                        @control.events.map('.tagging').onValue (v) =>
                                return unless v?
                                mode = @youtube.mode
                                if v == false && @youtube.mode == 'interrupted'
                                        @youtube.mode = 'play'
                                if v == true && @youtube.mode == 'play'
                                        @youtube.mode = 'interrupted'
                                @_trigger() unless mode == @youtube.mode

        Model
