$(function() {
  checkRemoveButton();

  // Add a new field
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

  // Remove a field
  $('body').on('click', 'button.remove-field-btn', function(event) {
    event.preventDefault();

    $(this).closest('.field-group').fadeOut(300, function() {
      $(this).remove();
      checkRemoveButton();
      return false;
    });
  });

  // Build fields json before submit
  $("#form").submit(function(event) {
    var fields = [];

    $(this).find('.field-group').each(function() {
      var field = {
        "name": $(this).find("input[name='field_names[]']").val(),
        "handle": $(this).find("input[name='field_handles[]']").val(),
        "kind": $(this).find("select option:selected").val()
      };

      var id = $(this).find("input[name='field_ids[]']");

      if (!id.length) {
        field["id"] = id.val()
      }

      fields.push(field)
    });

    $('#fields').val(JSON.stringify(fields));
  });
});

// Hide/show remove button
function checkRemoveButton() {
  var buttons = $("form .remove-field-btn")

  if (buttons.length == 1) {
    buttons.hide()
  } else {
    buttons.show();
  }
}
