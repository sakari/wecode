define ['lib/Bacon'],
(Bacon) ->
        class Timeline
                constructor: ->
                        @events = new Bacon.Bus
                        @position = 0
        class Youtube
                constructor: ->
                        @height =  '390'
                        @width = '640'
                        @videoId = 'Oh2TNO5CGXQ'
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
                        @timeline = new Timeline

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

                        @control.events.map('.step-back').onValue (v) =>
                                return unless v?
                                @youtube.mode = 'pause'
                                @_trigger()
                                @youtube.seekTo(@youtube.currentPosition - 0.05)

                        @control.events.map('.step-forward').onValue (v) =>
                                return unless v?
                                @youtube.mode = 'pause'
                                @_trigger()
                                @youtube.seekTo(@youtube.currentPosition + 0.05)

                        @control.events.map('.playback-rate').filter((a) -> a).onValue (v) =>
                                @youtube.playbackRate = v
                                @control.selectedPlaybackRate = v
                                @_trigger()

                        @control.events.map('.mode').filter((a) -> a).onValue (v) =>
                                @youtube.mode = v
                                @_trigger()

        Model
