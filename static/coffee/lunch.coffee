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
  $(elt).css "color", "gray"
  $(elt).next().css "color", "gray"

vegFade = (filter, elt) ->
  if filter is "(Vegan)"
    fadeOnHtml "(Vegan)", null, elt
  else fadeOnHtml "(Vegan)", "(Vegetarian)", elt  if filter is "(Vegetarian)"

# Fades element if its innerHTML does not contain one of filter
fadeOnHtml = (filter1, filter2, elt) ->
  fadeItemOut elt  if not $(elt).html().contains(filter1) and not $(elt).html().contains(filter2)

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
  eltsToChange().css "color", "black"
  $.each allergenList, (ind, value) ->
    eltsToChange().each (ind2, value2) ->
      if value is "(Vegetarian)" or value is "(Vegan)"
        vegFade value, value2
      else
        fadeItemOut(value2) if $(value2).attr("title") and value not in $(value2).attr("title")



populateFilterSelect = ->
  allergenList = getAllergenList()
  $("#allergens").select2 "val", allergenList

initializeFilters = ->
  populateFilterSelect()
  $("#allergens").trigger "change"

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
