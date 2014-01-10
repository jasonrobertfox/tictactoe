var Board = function(boardSpaceSelector) {
  boardSpaces = $(boardSpaceSelector);
  enabled = false;

  getSpaceById = function(id) {
    return $($.grep(boardSpaces, function(e) {
      return e.id === id;
    })[0]);
  };
};

Board.prototype.startWith = function(humanPlayerArg, computerPlayerArg) {
  humanPlayer = humanPlayerArg;
  computerPlayer = computerPlayerArg;
};

Board.prototype.read = function() {
  var board_data = [];
  boardSpaces.each(function() {
    var space_data = {};
    space_data.id = this.id;
    space_data.value = $(this).prop('title');
    board_data.push(space_data);
  });
  return {
    player_piece: computerPlayer.piece,
    opponent_piece: humanPlayer.piece,
    board: board_data
  };
};

Board.prototype.write = function(data) {
  data.board.forEach(function(space) {
    dom_space = getSpaceById(space.id);
    dom_space.prop('title', space.value);
    if (space.winning_space === true) {
      dom_space.addClass('winning');
    }
    if (space.value == humanPlayer.piece) {
      dom_space.addClass('human').addClass(humanPlayer.iconClass);
    }
    if (space.value == computerPlayer.piece) {
      dom_space.addClass('computer').addClass(computerPlayer.iconClass);
    }
  });
};

Board.prototype.clear = function() {
  boardSpaces.prop('title', '').attr('class', 'fa');
};

Board.prototype.registerHumanClick = function(element) {
  dom_space = getSpaceById(element[0].id);
  if (enabled === true && dom_space.prop('title') === '') {
    dom_space.prop('title', humanPlayer.piece);
    dom_space.addClass('human').addClass(humanPlayer.iconClass);
    return true;
  }
  return false;
};

Board.prototype.registerHumanHover = function(element) {
  dom_space = getSpaceById(element[0].id);
  if (enabled === true && dom_space.prop('title') === '') {
    dom_space.addClass('hover').addClass(humanPlayer.iconClass);
  }
};

Board.prototype.clearHumanHover = function(element) {
  dom_space = getSpaceById(element[0].id);
  if (enabled === true && dom_space.prop('title') === '') {
    dom_space.removeClass('hover').removeClass(humanPlayer.iconClass);
  }
};

Board.prototype.disable = function() {
  enabled = false;
};

Board.prototype.enable = function() {
  enabled = true;
};
