$ = require(\jquery)

{ Varying } = require(\janus)
stdlib = require(\janus-stdlib)
{ from-event, sticky } = stdlib.varying
{ min, max, floor, abs } = Math


module.exports = util =
  defer: (f) -> set-timeout(f, 0)
  wait: (time, f) -> set-timeout(f, time)
  clamp: (min, max, x) --> if x < min then min else if x > max then max else x
  px: (x) -> "#{x}px"
  pct: (x) -> "#{x * 100}%"
  pad: (x) -> if x < 10 then "0#x" else x
  get-time: -> (new Date()).getTime()
  max-int: Number.MAX_SAFE_INTEGER

  nonextant: (x) -> !x?
  is-blank: (x) -> !x? or (x is '') or Number.isNaN(x)
  if-extant: (f) -> (x) -> f(x) if x?

  hms-to-epoch: (hh, mm, ss) -> (hh * 60 * 60) + (mm * 60) + ss
  epoch-to-hms: (epoch) ->
    sign = if epoch < 0 then \- else \+
    epoch = abs(epoch)
    {
      sign
      hh: epoch / 3600 |> floor
      mm: epoch % 3600 / 60 |> floor
      ss: epoch % 60
    }
  hash-to-hms: (hash) ->
    if (hms = /^#?(..):(..):(..)$/.exec(hash))?
      [ _, hh, mm, ss ] = [ parse-int(x) for x in hms ]
      { hh, mm, ss }
    else
      null

  size-of: (selector) ->
    dom = $(selector)
    from-event($(window), \resize, -> { width: dom.width(), height: dom.height() })

  click-touch: (dom, f) ->
    dom.on('click touchstart', (event) ->
      event.preventDefault()
      f.call(this, event)

      unless util.is-blank(this.title)
        # trigger a tooltip but have it fade quickly.
        title = this.title
        trigger = $(this)
        trigger.trigger(\mouseenter)
        trigger.attr(\title, title) # since the browser would never show it anyway.
        $('#tooltip').addClass(\fading)
    )

  get-touch-y: (event) -> min(...[ touch.pageY for touch in event.touches ])
  get-touch-x: (event) -> min(...[ touch.pageX for touch in event.touches ])

  bump: (varying) ->
    varying.set(true)
    <- util.defer
    varying.set(false)

  attach-floating-box: (initiator, view, box-class = 'floating-box') ->
    box = $('<div/>').addClass(box-class)
    box.append(view.artifact())

    box.appendTo($('body'))
    target-offset = initiator.offset()
    box.css(\left, max(0, target-offset.left - box.outerWidth()))
    box.css(\top, min($(window).height() - box.outerHeight(), target-offset.top))

    initiator.addClass(\active)
    is-hovered = new Varying(true)
    targets = initiator.add(box)

    kill = ->
      initiator.removeClass(\active)
      view.destroy()
      box.remove()
    targets.on(\mouseenter, -> is-hovered.set(true))
    targets.on(\mouseleave, -> is-hovered.set(false))
    initiator.on(\mousedown, -> is-hovered.set(false))
    sticky( true: 100 )(is-hovered).react(false, (hovered) ->
      return if hovered
      kill()
      this.stop()
    )
    $('body').one(\touchend, kill)

  load-assets: (assets, done) ->
    done() if !assets? or assets.length is 0

    result = {}
    completed = 0

    for let asset in assets
      (asset-data) <- $.getJSON("/assets/#asset.json")
      completed += 1
      result[asset] = asset-data
      done(result) if completed is assets.length

