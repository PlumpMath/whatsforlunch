$(function(){
	$('#allergens').select2();
	$('#allergens').change(function(){
		console.log('a');
		var allergenList = [];
		$(':selected', this).each(function(i, elt){
			allergenList.push($(elt).val());
		});
		localStorage['allergenList'] = JSON.stringify(allergenList);
		applyAllergenList();
	});

	var applyAllergenList = function(){
		allergenList = JSON.parse(localStorage['allergenList']);
		$.each(allergenList, function(ind, value){
			$('span').each(function(ind2, value2){
				if($(value2).attr('title') && $(value2).attr('title').indexOf(value) === -1){
					$(value2).fadeTo('fast', 0.5);
				}
				else{
					console.log('adf');
					$(value2).fadeTo('fast', 2);
				}
			});
		});
	};

});