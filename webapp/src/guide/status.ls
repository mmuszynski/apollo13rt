$ = require(\jquery)
{ Model, bind, DomView, template, find, from } = require(\janus)
{ event-idx } = require('./util')

class Status extends Model

class StatusView extends DomView.build(
  Model.build(
    bind(\epoch, from.app(\epoch))
    bind(\event-idx, event-idx)

    bind(\status, from.subject(\events).and(\event-idx).all.map((events, idx) ->
      events[idx]?.name))
  )
  $('<div class="guide-box status">
  <div class="moon-panel"><div class="moon"/></div>
  <div class="earth">
    <img src="/assets/earth.svg"/>
    <div class="station station-1">
      <div class="station-waves"/>
    </div>
    <div class="station station-2">
      <div class="station-waves"/>
    </div>
    <div class="station station-3">
      <div class="station-waves"/>
    </div>
    <div class="station station-4">
      <div class="station-waves"/>
    </div>
    <div class="station station-5">
      <div class="station-waves"/>
    </div>
  </div>

  <div class="ship">
    <div class="ship-csm">
      <div class="ship-sm">
        <img src="/assets/sm.svg"/>
        <span class="sublabel">Command/Service Module (CSM)</span>
        <span class="subsublabel">Service Module (SM)</span>
      </div>
      <div class="ship-cm">
        <img src="/assets/cm.svg"/>
        <span class="subsublabel">Command Module (CM)</span>
      </div>
    </div>
    <div class="imu">
      <div class="imu-member"/>
    </div>
    <div class="ship-lm">
      <div class="ship-lm-a">
        <img src="/assets/lm-a.svg"/>
        <span class="sublabel">Lunar Module (LM)</span>
        <span class="subsublabel"><span>Ascent</span></span>
      </div>
      <div class="ship-lm-d">
        <span class="lm-leg stbd">
          <span class="leg-sec"/>
          <span class="leg-prim">
            <span class="leg-foot"/>
          </span>
        </span>
        <span class="lm-leg port">
          <span class="leg-sec"/>
          <span class="leg-prim">
            <span class="leg-foot"/>
          </span>
        </span>
        <img src="/assets/lm-d.svg"/>
        <span class="lm-leg center">
          <span class="foot"/>
          <span class="leg"/>
        </span>
        <span class="subsublabel">Descent</span>
      </div>
    </div>
  </div>

  <div class="s-ivb"><img src="/assets/s-ivb.svg"/></div>
  <div class="attitude">
    <div class="roll">roll</div>
    <div class="pitch">pitch</div>
    <div class="yaw">yaw</div>
  </div>
  <div class="stars">
    <div class="star star-a"/>
    <div class="star star-b"/>
    <div class="star star-c"/>
    <div class="star star-d"/>
    <div class="star star-e"/>
    <div class="star star-f"/>
  </div>
  <div class="angle">
    <div class="angle-fixed"/>
    <div class="angle-member"/>
  </div>
  <div class="compass">
    <div class="compass-rose"/>
    <div class="compass-rose"/>
    <div class="compass-minor"/>
    <div class="compass-minor"/>
    <div class="compass-stable">
      <div class="needle"/>
      <span>N</span>
    </div>
  </div>
</div>')
  template(
    find('.status').classGroup(\status-, from.vm(\status))
  )
)


module.exports = {
  Status, StatusView
  registerWith: (library) ->
    library.register(Status, StatusView)
}

