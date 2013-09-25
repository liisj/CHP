// DMA code from index.html

$(function() {
	$("button").button();
	$(".dialog-messages").hide();
	$('#modules').buttonset();
	$('#submodules').buttonset();
	$("#Order")
		.button( {
			icons: {
				primary: null,
				secondary: "ui-icon-triangle-1-s"
			}
		});
	$(".optBtn")
		.button( {
			label: "Incoming Package",
			icons: {
				primary: "ui-icon-cart"
			}
		});
	$("#clearBtn")
		.button( {
			label: "Clear",
			icons: {
				primary: "ui-icon-trash"
			}
		});
	$("#backBtn")
		.button( {
			label: "Back",
			icons: {
				primary: "ui-icon-circle-arrow-w"
			}
		});				
});	
