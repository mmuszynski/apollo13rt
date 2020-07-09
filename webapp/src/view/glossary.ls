$ = require(\jquery)
marked = require(\marked)

{ DomView, template, find, from } = require(\janus)
{ Player, Term, Glossary } = require('../model')


base-term-edit-url = "https://github.com/issa-tseng/apollo13rt/edit/master/script/glossary.txt"
class TermView extends DomView.build($('
    <div class="term">
      <div class="term-name">
        <span class="name"/>
        <span class="synonyms"/>
        <a class="term-edit" target="_blank" title="Suggest an edit"/>
        <a class="term-hide" href="#"/>
      </div>
      <p class="term-definition"/>
    </div>
  '), template(
    find('.term').classGroup(\category-, from(\category))

    find('.term').classed(\active,
      from(\hidden)
        .and(\glossary).get(\show.hidden)
        .and(\matches)
        .and.app(\global).get(\player).get(\nearby_terms)
        .all.flatMap((hidden, show-hidden, f, terms) ->
          if hidden and show-hidden then true
          else if hidden then false
          else terms?.find(f)?
        )
    )

    find('.term-name .name').text(from(\term))
    find('.term-name .synonyms').render(
      from(\synonyms).and.app(\global).get(\player).get(\nearby_terms)
        .all.map((synonyms, terms) -> synonyms.filter((term) -> terms.map((nearby) -> term in nearby)))
    )

    find('.term-edit').attr(\href, from(\line).map(-> "#base-term-edit-url\#L#it"))
    find('.term-hide').classed(\active, from(\hidden))
    find('.term-hide').attr(\title, from(\hidden).map(-> if it then "Show this term" else "Don't show me again"))
    find('.term-definition').html(from(\definition).map (marked))
))
  _wireEvents: ->
    dom = this.artifact()
    term = this.subject

    dom.find('.term-hide').on(\click, -> term.set(\hidden, !term.get_(\hidden)))

class GlossaryView extends DomView.build($('
    <div class="glossary">
      <div class="glossary-items"/>
      <p>Glossary</p>
      <div class="glossary-controls">
        <label class="glossary-show-personnel" title="Show personnel titles">
          <span class="checkbox"/> Personnel
        </label>
        <label class="glossary-show-technical" title="Show technical jargon">
          <span class="checkbox"/> Technical
        </label>
        <label class="glossary-show-hidden" title="Show terms you\'ve hidden">
          <span class="checkbox"/> Hidden
        </label>
      </div>
    </div>
  '), template(
    find('.glossary').classed(\hide-personnel, from(\show.personnel).map (not))
    find('.glossary').classed(\hide-technical, from(\show.technical).map (not))

    find('.glossary-items').render(from(\list))

    find('.glossary-show-personnel').classed(\checked, from(\show.personnel))
    find('.glossary-show-personnel span').render(from.attribute(\show.personnel)).context(\edit)

    find('.glossary-show-technical').classed(\checked, from(\show.technical))
    find('.glossary-show-technical span').render(from.attribute(\show.technical)).context(\edit)

    find('.glossary-show-hidden').classed(\checked, from(\show.hidden))
    find('.glossary-show-hidden span').render(from.attribute(\show.hidden)).context(\edit)
))


module.exports = {
  TermView, GlossaryView
  registerWith: (library) ->
    library.register(Term, TermView)
    library.register(Glossary, GlossaryView)
}

