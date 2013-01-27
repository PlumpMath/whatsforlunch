$(function(){
	String.prototype.contains = function(it) { return this.indexOf(it) != -1; };
	$('#allergens').select2();
	$('#allergens').change(function(){
		var allergenList = [];
		$(':selected', this).each(function(i, elt){
			allergenList.push($(elt).val());
		});
		localStorage['allergenList'] = JSON.stringify(allergenList);
		applyAllergenList();
	});
	$('#clear-filters').click(function(){
		$('#allergens').val([]);
		$('#allergens').trigger('change');
	});
	var fadeItemOut = function(elt){
		// Fade menu item and its description
		$(elt).css('color', 'gray');
		$(elt).next().css('color', 'gray');
	};
	var vegFade = function(filter, elt){
		if(filter === '(Vegan)'){
			fadeOnHtml('(Vegan)', null, elt);
		}
		else if(filter === '(Vegetarian)'){
			fadeOnHtml('(Vegan)', '(Vegetarian)', elt);
		}
	};
	// Fades element if its innerHTML does not contain one of filter
	var fadeOnHtml = function(filter1, filter2, elt){
		if(!$(elt).html().contains(filter1) && !$(elt).html().contains(filter2)){
			fadeItemOut(elt);
		}
	};
	var eltsToChange = function(){
		return $('.menu section').children('span').children().filter(function(){
			return $(this).css('font-size') !== '10px'; 
		});
	};
	var applyAllergenList = function(){
		var allergenList = JSON.parse(localStorage['allergenList']);
		eltsToChange().css('color', 'black');
		$.each(allergenList, function(ind, value){
			eltsToChange().each(function(ind2, value2){
				if(value === '(Vegetarian)' || value === '(Vegan)'){
					vegFade(value, value2);
				}
				else{
					if($(value2).attr('title') && $(value2).attr('title').indexOf(value) === -1){
						fadeItemOut(value2);
					}	
				}
			});
		});
	};
	var populateFilterSelect = function(){
		var allergenList = JSON.parse(localStorage['allergenList']);
		$('#allergens').select2('val', allergenList);
	};
	var initializeFilters = function(){
		populateFilterSelect();
		$('#allergens').trigger('change');
	}();

});