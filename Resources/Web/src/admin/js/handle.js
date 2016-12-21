$(function() {
  $('body').on('keyup', '.auto-title', function(event) {
    var value =  $(this).val();
    $(this).parent().next(".form-group").find("input").val(value.toLowerCase());
  });
});
