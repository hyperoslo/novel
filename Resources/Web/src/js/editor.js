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

  var form = document.querySelector('form');
  form.onsubmit = function() {
    $('#app').find('.editor-container').each(function() {
      var id = 'field_' + this.id.replace('editor_', '');
      var value = JSON.stringify(this.getContents());
      $('#' + id).val(value);
    })

    console.log("Submitted", $(form).serialize(), $(form).serializeArray());
    alert('Open the console to see the submit data!')
    return false;
  };
});
