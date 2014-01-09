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

// describe('Game', function(){
//   beforeEach(function(){
//     blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>')
//     dirtyBoard = $('<i id="top-left" title="x" class="fa fa-times human"></i><i id="top-right" title="o" class="fa fa-circleo computer"></i>')
//     tests = $('<i id="top-left" title="x" class="fa fa-times human">')
//   });

//   it('Should be constructed', function(){
//       game = new Game(blankBoard, messageWriter);
//       expect(game).toBeDefined();
//   });

//   it('should start a game by resetting the board', function(){
//     game = new Game(dirtyBoard, messageWriter);
//     game.humanStart();
//     expect(dirtyBoard).not.toHaveClass('fa-times');
//     expect(dirtyBoard).not.toHaveClass('fa-circleo');
//     expect(dirtyBoard).not.toHaveClass('human');
//     expect(dirtyBoard).not.toHaveClass('computer');
//     expect(dirtyBoard).toHaveProp('title', '');
//     expect(messageWriter.setComputerMessage).toHaveBeenCalled();
//     expect(messageWriter.setHumanMessage).toHaveBeenCalled();
//     expect(messageWriter.setPromptMessage).toHaveBeenCalled();
//   });

//   it('should start a computer game by resetting the board', function(){
//     game = new Game(dirtyBoard);
//     game.computerStart();
//     expect(dirtyBoard).not.toHaveClass('fa-times');
//     expect(dirtyBoard).not.toHaveClass('fa-circleo');
//     expect(dirtyBoard).not.toHaveClass('human');
//     expect(dirtyBoard).not.toHaveClass('computer');
//     expect(dirtyBoard).toHaveProp('title', '');
//     expect(messageWriter.setComputerMessage).toHaveBeenCalled();
//     expect(messageWriter.setHumanMessage).toHaveBeenCalled();
//   });
// });

describe('Board', function() {
  beforeEach(function() {
    dirtyBoard = $('<i id="top-left" title="x" class="fa fa-times human"></i><i id="top-right" title="o" class="fa fa-circle-o computer"></i>');
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
    blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>');
    board = new Board(blankBoard);
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
    blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>');
    clickedSpace = $('<i id="top-left"></i>');
    board = new Board(blankBoard);
    board.enable();
    board.registerHumanClick(clickedSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.human.fa-times[title=x]');
  });

  it('can be disabled', function() {
    blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>');
    clickedSpace = $('<i id="top-left"></i>');
    board = new Board(blankBoard);
    board.disable();
    board.registerHumanClick(clickedSpace);
    expect(blankBoard).not.toBeMatchedBy('#top-left.fa.human.fa-times[title=x]');
  });

  it('can hover when enabled', function() {
    blankBoard = $('<i id="top-left" class="fa"></i><i id="top-right" class="fa"></i>');
    hoverSpace = $('<i id="top-left"></i>');
    board = new Board(blankBoard);
    board.enable();
    board.registerHumanHover(hoverSpace);
    expect(blankBoard).toBeMatchedBy('#top-left.fa.hover.fa-times');
  });

  it('will not override a selected space', function(){
    blankBoard = $('<i id="top-left" class="fa fa-circle-o computer" title="o"></i><i id="top-right" class="fa"></i>');
    hoverSpace = $('<i id="top-left"></i>');
    board = new Board(blankBoard);
    board.enable();
    board.registerHumanHover(hoverSpace);
    expect(blankBoard).not.toBeMatchedBy('#top-left.fa.hover.fa-times');
  });


});
