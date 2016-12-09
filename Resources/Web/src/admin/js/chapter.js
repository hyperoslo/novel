$(function() {
  checkRemoveButton();

  $('body').on('click', '#new-field-btn', function(event) {
		event.preventDefault();

    var field = $(this).prev(".field-group")

    if (!field.length) {
      return false;
    }

    var template = field.clone();

    template.find('input,select,textarea').each(function() {
      $(this).val('');
    }).end().insertAfter(field);

    checkRemoveButton();
	});

  $('body').on('click', 'button.remove-field-btn', function(event) {
    event.preventDefault();

    $(this).closest('.field-group').fadeOut(300, function() {
      $(this).remove();
      checkRemoveButton();
      return false;
    });
  });
});

function checkRemoveButton() {
  var buttons = $("form .remove-field-btn")

  if (buttons.length == 1) {
    buttons.hide()
  } else {
    buttons.show();
  }
}
