goToSuffix = (newUrlSuffix) ->
  window.location = "/" + newUrlSuffix
changeDateHandler = (ev) ->
  newUrlSuffix = ev.date.toString("yyyy-MM-dd")
  goToSuffix newUrlSuffix
moveDatePickerBy = (offset) ->
  d = Date.parse($(".datepicker").val())
  newDate = d.add(offset).days()
  newUrlSuffix = newDate.toString("yyyy-MM-dd")
  goToSuffix newUrlSuffix

String::contains = (it) ->
  @indexOf(it) isnt -1
fadeItemOut = (elt) ->
  # Fade menu item and its description
  if $(elt).css('color') isnt "#d8d8d8"
    $(elt).animate {"color":"#d8d8d8"}, 500
    $(elt).next().animate {"color":"#d8d8d8"}, 500
isFaded = (elt) -> $(elt).css('color') is "#d8d8d8"

turnItemToBlack = (elt) ->
  $(elt).css('color', 'black')
  $(elt).next().css('color', 'black')

vegFade = (filter, elt) ->
  if filter is "(Vegan)"
    fadeOnHtml "(Vegan)", null, elt
  else if filter is "(Vegetarian)"
    fadeOnHtml "(Vegan)", "(Vegetarian)", elt
  else
    false

# Return true iff the element's innerHTML contains neither filter1 nor filter2
fadeOnHtml = (filter1, filter2, elt) ->
  if not $(elt).html().contains(filter1) and not $(elt).html().contains(filter2)
    return true
  else
    return false
# Return true iff the element's title does not contain filter
fadeOnTitle = (filter, elt) ->
  if $(elt).attr('title')?.contains(filter)
    return false
  else
    return true

eltsToChange = ->
  $(".menu section").children("span").children().filter ->
    $(this).css("font-size") isnt "10px"


getAllergenList = ->
  try
    allergenList = JSON.parse(localStorage["allergenList"])
    return allergenList
  catch e
    console.log e
    return []

applyAllergenList = ->
  allergenList = getAllergenList()
  allMenuItems = eltsToChange()
  elts_to_fade = []
  $.each allergenList, (ind, allergen) ->
    allMenuItems.each (ind2, elt) ->
      if allergen in ["(Vegetarian)", "(Vegan)"]
        elts_to_fade.push(elt) if vegFade allergen, elt
      else
        elts_to_fade.push(elt) if fadeOnTitle allergen, elt
  (fadeItemOut(elt) for elt in _.uniq(elts_to_fade))
  (turnItemToBlack(elt) for elt in allMenuItems when elt not in elts_to_fade)


populateFilterSelect = ->
  allergenList = getAllergenList()
  $("#allergens").select2 "val", allergenList



$ ->
  $(".datepicker").datepicker()
  $(".datepicker").on "changeDate", (ev) ->
    changeDateHandler ev

  $("#next-date").click ->
    moveDatePickerBy 1

  $("#prev-date").click ->
    moveDatePickerBy -1

  $("#allergens").select2()
  $('.allergen-selector').css('visibility', 'visible')
  $("#allergens").select2()
  $("#allergens").change ->
    allergenList = []
    $(":selected", this).each (i, elt) ->
      allergenList.push $(elt).val()

    localStorage["allergenList"] = JSON.stringify(allergenList)
    applyAllergenList()

  $("#clear-filters").click ->
    $("#allergens").val []
    $("#allergens").trigger "change"

  initializeFilters = do ->
    populateFilterSelect()
    $("#allergens").trigger "change"
  $('body').scrollspy()