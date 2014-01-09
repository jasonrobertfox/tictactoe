$(document).foundation();

var humanPieceClass = '';
var computerPieceClass = '';
var humanPiece = '';
var computerPiece = '';
var boardEnabled = false;


var MessageWriter = function(computerElement, humanElement, promptElement) {
    this.computerElement = $(computerElement);
    this.humanElement = $(humanElement);
    this.promptElement = $(promptElement);
};


MessageWriter.prototype.setComputerMessage = function(message) {
    this.computerElement.html(message);
};

MessageWriter.prototype.setHumanMessage = function(message) {
    this.humanElement.html(message);
};

MessageWriter.prototype.setPromptMessage = function(message) {
    this.promptElement.html(message);
};

MessageWriter.prototype.think = function() {
    this.setPromptMessage('<i class="fa fa-cog fa-spin fa-2x"></i>');
};


var Game = function(boardSpaces, messageWriter) {
    boardSpaces = $(boardSpaces);

    reset = function() {
        boardSpaces.prop('title', '').attr('class', 'fa');
        this.messageWriter.setComputerMessage('You start over.');
        this.messageWriter.setHumanMessage('I\'ll start over.');
    };
};

Game.prototype.humanStart = function() {
    reset();
    messageWriter.setPromptMessage('Go.');
};

Game.prototype.computerStart = function() {
    reset();
};


var Board = function(boardSpaceSelector) {
    boardSpaces = $(boardSpaceSelector);
    enabled = false;
};

Board.prototype.clear = function() {
    boardSpaces.prop('title', '').attr('class', 'fa');
};

Board.prototype.read = function() {
    var board_data = [];
    boardSpaces.each(function() {
        var space_data = {};
        space_data.id = this.id;
        space_data.value = $(this).prop('title');
        board_data.push(space_data);
    });
    return board_data;
};

Board.prototype.write = function(data) {
    data.board.forEach(function(space) {
        dom_space = $($.grep(boardSpaces, function(e) {
            return e.id === space.id;
        })[0]);
        dom_space.prop('title', space.value);
        if (space.winning_space === true) {
            dom_space.addClass('winning');
        }
        if (space.value == data.player_piece) {
            dom_space.addClass('human');
        }
        if (space.value == data.opponent_piece) {
            dom_space.addClass('computer');
        }
        if (space.value == 'x') {
            dom_space.addClass('fa-times');
        }
        if (space.value == 'o') {
            dom_space.addClass('fa-circle-o');
        }
    });
};

Board.prototype.registerHumanClick = function(clickedElement) {
    if(enabled === true){
      dom_space = $($.grep(boardSpaces, function(e) {
            return e.id === clickedElement[0].id;
        })[0]);
        dom_space.prop('title', 'x');
        dom_space.addClass('human');
        dom_space.addClass('fa-times');
    }
};

Board.prototype.registerHumanHover = function(hoveredElement) {
    console.log(hoveredElement)
        dom_space = $($.grep(boardSpaces, function(e) {
            return e.id === hoveredElement[0].id;
        })[0]);
    if(enabled === true && dom_space.prop('title') == ''){
        dom_space.toggleClass('hover');
        dom_space.toggleClass('fa-times');
    }
};

Board.prototype.disable = function(){
    enabled = false;
};

Board.prototype.enable = function(){
    enabled = true;
};

mw = new MessageWriter('#start-computer p', '#start-human p', '#prompt');

board = new Board('.space i');

function computerMessage(message) {
    mw.setComputerMessage(message);
}

function humanMessage(message) {
    mw.setHumanMessage(message);
}

function promptMessage(message) {
    mw.setPromptMessage(message);

}

function promptThinking() {
    mw.think();

}

function startGame() {
    board.clear();
    computerMessage('You start over.');
    humanMessage('I\'ll start over.');
}





function computerTurn(playerPiece, opponentPiece) {
    //this will simulate a random choice by the computer to test the back and forth
    var data = {}
    data['player_piece'] = playerPiece
    data['opponent_piece'] = opponentPiece

    data['board'] = board.read();
    $.ajax({
        type: 'POST',
        url: '/api/v2/play',
        dataType: 'json',
        data: JSON.stringify(data),
        processData: false,
        beforeSend: function() {
            board.disable();
            promptThinking();
        },
        success: function(data, status, jqxhr) {
            board.write(data.data);
            if (data.data.staus == 'draw') {
                promptMessage('It\'s a draw.');
            } else if (data.data.status == 'win') {
                if (data.data.winner == humanPiece) {
                    promptMessage('Nice job, winner.');
                } else {
                    promptMessage('I win.');
                }
            } else {
                promptMessage('Go.');
                board.enable();
            }
        }
    });
}

function start(firstPlayer) {
    startGame();
    if (firstPlayer == 'human') {
        promptMessage('Go.');
        humanPieceClass = 'fa-times';
        computerPieceClass = 'fa-circle-o';
        humanPiece = 'x';
        computerPiece = 'o';
        boardEnabled = true;
    } else {
        humanPieceClass = 'fa-circle-o';
        computerPieceClass = 'fa-times';
        humanPiece = 'o';
        computerPiece = 'x';
        boardEnabled = false;
        computerTurn(computerPiece, humanPiece);
    }
}

$(document).ready(function() {
    $('#start-human').click(function() {
        start('human');
        board.enable();
    });

    $('#start-computer').click(function() {
        start('computer');
    });

    $('.space').hover(function() {
        board.registerHumanHover($(this).children('i'));
    });

    $('.space').click(function(){
        board.registerHumanClick($(this).children('i'));
        computerTurn(computerPiece, humanPiece);
    });
});
