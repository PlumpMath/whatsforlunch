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
  $(elt).animate {"color":"#d8d8d8"}, 500
  $(elt).next().animate {"color":"#d8d8d8"}, 500

turnItemToBlack = (elt) ->
  $(elt).css('color', 'black')
  $(elt).next().css('color', 'black')

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
  eltsToChange().each (ind, value) ->
    turnItemToBlack(value)
  $.each allergenList, (ind, value) ->
    eltsToChange().each (ind2, value2) ->
      if value in ["(Vegetarian)", "(Vegan)"]
        vegFade value, value2
      else
        fadeItemOut(value2) if $(value2).attr("title") and not $(value2).attr("title").contains(value)



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