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
