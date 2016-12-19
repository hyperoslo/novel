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

$(function() {
  $(".editor-container").each(function() {
    var quill = new Quill(this, {
      modules: {
        toolbar: [
          ['bold', 'italic'],
          ['link', 'blockquote', 'code-block'],
          [{ list: 'ordered' }, { list: 'bullet' }]
        ]
      },
      placeholder: '',
      theme: 'snow'
    });
	});

  $("#form").submit(function(event) {
    $(this).find('.editor-container').each(function() {
      var id = 'field_' + this.id.replace('editor_', '');
      var value = $(this).find(".ql-editor").html();
      $('#' + id).val(value);
    });
  });
});

$(function () {
	// Toggle sidebar
	$('#sidebar-collapse-btn').on('click', function(event){
		event.preventDefault();

		$("#app").toggleClass("open");
		$("#sidebar").toggleClass("open");
	});

	// Set active navigation item
  $('#sidebar-menu > li > a[href="' + document.location.pathname + '"]').parent().addClass('active');

	// Set active submenu item
  $('#submenu a[href="' + document.location.pathname + '"]').parent().addClass('active');
});
