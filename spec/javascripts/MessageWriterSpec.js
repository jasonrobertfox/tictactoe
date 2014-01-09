describe('MessageWriter', function() {

  beforeEach(function() {
    ce = $('<p id="computer">You Start</p>');
    he = $('<p id="human">You Start</p>');
    pe = $('<p id="prompt">You Start</p>');
    mw = new MessageWriter(ce, he, pe);
  });


  it('Should be constructed', function() {
    expect(mw).toBeDefined();
  });

  it('Can update the message for the computer', function() {
    mw.setComputerMessage('Computer Message');
    expect(ce).toContainText('Computer Message');
  });

  it('Can update the message for the human', function() {
    mw.setHumanMessage('Human Message');
    expect(he).toContainText('Human Message');
  });

  it('Can set the prompt message', function() {
    mw.setPromptMessage('Prompt Message');
    expect(pe).toContainText('Prompt Message');
  });

  it('Can update the prompt to thinking', function() {
    mw.think();
    expect(pe).toContainHtml('<i class="fa fa-cog fa-spin fa-2x"></i>');
  });

});



describe('Player', function(){
  it('Should be constructed', function() {
    firstPlayer = new Player('x', 'fa-times');
    expect(firstPlayer.piece).toBe('x');
    expect(firstPlayer.iconClass).toBe('fa-times');
  });
});




describe('Board', function() {
  beforeEach(function() {
    dirtyBoard = $('<i id="top-left" title="x" class="fa fa-times human"></i><i id="top-right" title="o" class="fa fa-circle-o computer"></i>');
    blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>');
    selectedSpace = $('<i id="top-left"></i>');
    firstPlayer = new Player('x', 'fa-times');
    secondPlayer = new Player('o', 'fa-circle-o');
  });

  it('Should be constructed', function() {
    board = new Board(dirtyBoard);
    expect(board).toBeDefined();
  });

  it('can be cleared', function() {
    board = new Board(dirtyBoard);
    board.clear();
    expect(dirtyBoard).not.toHaveClass('fa-times');
    expect(dirtyBoard).not.toHaveClass('fa-circle-o');
    expect(dirtyBoard).not.toHaveClass('human');
    expect(dirtyBoard).not.toHaveClass('computer');
    expect(dirtyBoard).toHaveProp('title', '');
  });

  it('can be read', function() {
    board = new Board(dirtyBoard);
    data = [{
      id: 'top-left',
      value: 'x'
    }, {
      id: 'top-right',
      value: 'o'
    }];
    expect(board.read()).toEqual(data);
  });

  it('can write to dom', function() {
    board = new Board(blankBoard);
    board.startWith(firstPlayer, secondPlayer);
    data = {
      player_piece: 'x',
      opponent_piece: 'o',
      board: [{
        id: 'top-left',
        value: 'x',
        winning_space: true
      }, {
        id: 'top-right',
        value: 'o'
      }]
    };
    board.write(data);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.human.winning.fa-times[title=x]');
    expect(blankBoard).toBeMatchedBy('#top-right.fa.computer.fa-circle-o[title=o]');
  });

  it('can register a space click when enabled', function() {
    board = new Board(blankBoard);
    board.enable();
    board.registerHumanClick(selectedSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.human.fa-times[title=x]');
  });

  it('is disabled by default', function() {
    board = new Board(blankBoard);
    board.startWith(firstPlayer, secondPlayer);
    board.registerHumanClick(selectedSpace);
    expect(blankBoard).not.toBeMatchedBy('#top-left.fa.human.fa-times[title=x]');
  });

  it('can hover when enabled', function() {
    board = new Board(blankBoard);
    board.startWith(firstPlayer, secondPlayer);
    board.enable();
    board.registerHumanHover(selectedSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.hover.fa-times');
  });

  it('will not override a selected space', function(){
    partialBoard = $('<i id="top-left" class="fa fa-circle-o computer" title="o"></i><i id="top-right" class="fa"></i>');
    board = new Board(partialBoard);
    board.enable();
    board.registerHumanHover(selectedSpace);
    expect(partialBoard).not.toBeMatchedBy('#top-left.fa.hover.fa-times');
  });

  it('will set the correct pieces if begin human', function(){
    board = new Board(blankBoard);
    board.startWith(firstPlayer, secondPlayer);
    board.enable();
    board.registerHumanClick(selectedSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.human.fa-times[title=x]');
  });

  it('will set the correct pieces if begin computer', function(){
    board = new Board(blankBoard);
    board.startWith(secondPlayer, firstPlayer);
    board.enable();
    board.registerHumanClick(selectedSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.human.fa-circle-o[title=o]');
  });


});
