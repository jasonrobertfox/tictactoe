function updateGame(board, reporter) {
  $.ajax({
    type: 'POST',
    url: '/api/v2/play',
    dataType: 'json',
    data: JSON.stringify(board.read()),
    processData: false,
    beforeSend: function() {
      board.disable();
      reporter.think();
    },
    success: function(data, status, jqxhr) {
      board.write(data.data);
      reporter.updateStatus(data.data.status);
      if (data.data.status == 'active') {
        board.enable();
      }
    }
  });
}

$(document).ready(function() {

  x = new Player('x', 'fa-times');
  o = new Player('o', 'fa-circle-o');
  board = new Board('.space i');
  reporter = new Reporter('#start-computer p', '#start-human p', '#prompt');

  $('#start-human').click(function() {
    reporter.start();
    board.clear();
    board.startWith(x, o);
    reporter.updateStatus('active');
    board.enable();
  });

  $('#start-computer').click(function() {
    reporter.start();
    board.clear();
    board.startWith(o, x);
    updateGame(board, reporter);
  });

  $('.space').hover(function() {
    board.registerHumanHover($(this).children('i'));
  }, function() {
    board.clearHumanHover($(this).children('i'));
  });

  $('.space').click(function() {
    if (board.registerHumanClick($(this).children('i'))) {
      updateGame(board, reporter);
    }
  });
});
