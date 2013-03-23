// Generated by CoffeeScript 1.6.1
(function() {
  var applyAllergenList, changeDateHandler, eltsToChange, fadeItemOut, fadeOnHtml, fadeOnTitle, getAllergenList, goToSuffix, isFaded, moveDatePickerBy, populateFilterSelect, turnItemToBlack, vegFade,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  goToSuffix = function(newUrlSuffix) {
    return window.location = "/" + newUrlSuffix;
  };

  changeDateHandler = function(ev) {
    var newUrlSuffix;
    newUrlSuffix = ev.date.toString("yyyy-MM-dd");
    return goToSuffix(newUrlSuffix);
  };

  moveDatePickerBy = function(offset) {
    var d, newDate, newUrlSuffix;
    d = Date.parse($(".datepicker").val());
    newDate = d.add(offset).days();
    newUrlSuffix = newDate.toString("yyyy-MM-dd");
    return goToSuffix(newUrlSuffix);
  };

  String.prototype.contains = function(it) {
    return this.indexOf(it) !== -1;
  };

  fadeItemOut = function(elt) {
    if ($(elt).css('color') !== "#d8d8d8") {
      $(elt).animate({
        "color": "#d8d8d8"
      }, 500);
      return $(elt).next().animate({
        "color": "#d8d8d8"
      }, 500);
    }
  };

  isFaded = function(elt) {
    return $(elt).css('color') === "#d8d8d8";
  };

  turnItemToBlack = function(elt) {
    $(elt).css('color', 'black');
    return $(elt).next().css('color', 'black');
  };

  vegFade = function(filter, elt) {
    if (filter === "(Vegan)") {
      return fadeOnHtml("(Vegan)", null, elt);
    } else if (filter === "(Vegetarian)") {
      return fadeOnHtml("(Vegan)", "(Vegetarian)", elt);
    } else {
      return false;
    }
  };

  fadeOnHtml = function(filter1, filter2, elt) {
    if (!$(elt).html().contains(filter1) && !$(elt).html().contains(filter2)) {
      return true;
    } else {
      return false;
    }
  };

  fadeOnTitle = function(filter, elt) {
    var _ref;
    if ((_ref = $(elt).attr('title')) != null ? _ref.contains(filter) : void 0) {
      return false;
    } else {
      return true;
    }
  };

  eltsToChange = function() {
    return $(".menu section").children("span").children().filter(function() {
      return $(this).css("font-size") !== "10px";
    });
  };

  getAllergenList = function() {
    var allergenList;
    try {
      allergenList = JSON.parse(localStorage["allergenList"]);
      return allergenList;
    } catch (e) {
      console.log(e);
      return [];
    }
  };

  applyAllergenList = function() {
    var allMenuItems, allergenList, elt, elts_to_fade, _i, _j, _len, _len1, _ref, _results;
    allergenList = getAllergenList();
    allMenuItems = eltsToChange();
    elts_to_fade = [];
    $.each(allergenList, function(ind, allergen) {
      return allMenuItems.each(function(ind2, elt) {
        if (allergen === "(Vegetarian)" || allergen === "(Vegan)") {
          if (vegFade(allergen, elt)) {
            return elts_to_fade.push(elt);
          }
        } else {
          if (fadeOnTitle(allergen, elt)) {
            return elts_to_fade.push(elt);
          }
        }
      });
    });
    _ref = _.uniq(elts_to_fade);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      elt = _ref[_i];
      fadeItemOut(elt);
    }
    _results = [];
    for (_j = 0, _len1 = allMenuItems.length; _j < _len1; _j++) {
      elt = allMenuItems[_j];
      if (__indexOf.call(elts_to_fade, elt) < 0) {
        _results.push(turnItemToBlack(elt));
      }
    }
    return _results;
  };

  populateFilterSelect = function() {
    var allergenList;
    allergenList = getAllergenList();
    return $("#allergens").select2("val", allergenList);
  };

  $(function() {
    var initializeFilters;
    $(".datepicker").datepicker();
    $(".datepicker").on("changeDate", function(ev) {
      return changeDateHandler(ev);
    });
    $("#next-date").click(function() {
      return moveDatePickerBy(1);
    });
    $("#prev-date").click(function() {
      return moveDatePickerBy(-1);
    });
    $("#allergens").select2();
    $('.allergen-selector').css('visibility', 'visible');
    $("#allergens").select2();
    $("#allergens").change(function() {
      var allergenList;
      allergenList = [];
      $(":selected", this).each(function(i, elt) {
        return allergenList.push($(elt).val());
      });
      localStorage["allergenList"] = JSON.stringify(allergenList);
      return applyAllergenList();
    });
    $("#clear-filters").click(function() {
      $("#allergens").val([]);
      return $("#allergens").trigger("change");
    });
    return initializeFilters = (function() {
      populateFilterSelect();
      return $("#allergens").trigger("change");
    })();
  });

}).call(this);
