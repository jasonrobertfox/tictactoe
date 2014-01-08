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



// function writeBoard(spaces) {
//     for (index = 0; index < spaces.length; ++index) {
//         var space = spaces[index];
//         $('#' + space['id']).children('i').prop('title', space['value']);
//         if (space['value'] == 'x') {
//             $('#' + space['id']).children('i').addClass('fa-times');
//             $('#' + space['id']).children('i').removeClass('fa-circle-o');
//         } else if (space['value'] == 'o') {
//             $('#' + space['id']).children('i').addClass('fa-circle-o');
//             $('#' + space['id']).children('i').removeClass('fa-times');
//         }
//         if (space['value'] == humanPiece) {
//             $('#' + space['id']).children('i').addClass('human');
//             $('#' + space['id']).children('i').removeClass('computer');
//         } else if (space['value'] == computerPiece) {
//             $('#' + space['id']).children('i').addClass('computer');
//             $('#' + space['id']).children('i').removeClass('human');
//         }

//         if (space['winning_space'] == true) {
//             $('#' + space['id']).children('i').addClass('winning');
//         }
//     }
// }



mw = new MessageWriter('#start-computer p', '#start-human p', '#prompt');

board = new Board('.space i');

function computerMessage(message) {
    mw.setComputerMessage(message);
    // $('#start-computer p').html(message)
}

function humanMessage(message) {
    mw.setHumanMessage(message);
    // $('#start-human p').html(message)
}

function promptMessage(message) {
    mw.setPromptMessage(message);
    // if($('#prompt').hasClass('hide')){
    //     $('#prompt').removeClass('hide');
    //     $('#thinking').addClass('hide');
    // }
    // $('#prompt').html(message)
}

function promptThinking() {
    mw.think();
    // if($('#thinking').hasClass('hide')){
    //     $('#thinking').removeClass('hide');
    //     $('#prompt').addClass('hide');
    // }
}

function startGame() {
    board.clear();
    computerMessage('You start over.');
    humanMessage('I\'ll start over.');
}

function isBlank(space) {
    if ($(space).children('i').prop('title') == 'x' || $(space).children('i').prop('title') == 'o') {
        return false;
    } else {
        return true;
    }
}

// function readBoard() {
//     var board = [];
//     $('.space').map(function() {
//         var id = this.id;
//         var value = $(this).children('i').prop('title');
//         var space = {};
//         space['id'] = id;
//         space['value'] = value;
//         board.push(space);
//     });
//     return board;
// }


// function writeBoard(spaces) {
//     for (index = 0; index < spaces.length; ++index) {
//         var space = spaces[index];
//         $('#' + space['id']).children('i').prop('title', space['value']);
//         if (space['value'] == 'x') {
//             $('#' + space['id']).children('i').addClass('fa-times');
//             $('#' + space['id']).children('i').removeClass('fa-circle-o');
//         } else if (space['value'] == 'o') {
//             $('#' + space['id']).children('i').addClass('fa-circle-o');
//             $('#' + space['id']).children('i').removeClass('fa-times');
//         }
//         if (space['value'] == humanPiece) {
//             $('#' + space['id']).children('i').addClass('human');
//             $('#' + space['id']).children('i').removeClass('computer');
//         } else if (space['value'] == computerPiece) {
//             $('#' + space['id']).children('i').addClass('computer');
//             $('#' + space['id']).children('i').removeClass('human');
//         }

//         if (space['winning_space'] == true) {
//             $('#' + space['id']).children('i').addClass('winning');
//         }
//     }
// }



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
            boardEnabled = false;
            promptThinking();
        },
        success: function(data, status, jqxhr) {
            boardArray = data['data']['board']
            console.log(data.data);
            board.write(data.data);
            // writeBoard(boardArray)
            if (data['data']['status'] == 'draw') {
                promptMessage('It\'s a draw.');
            } else if (data['data']['status'] == 'win') {
                if (data['data']['winner'] == humanPiece) {
                    promptMessage('Nice job, winner.');
                } else {
                    promptMessage('I win.');
                }
            } else {
                promptMessage('Go.');
                boardEnabled = true;
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
        start('human')
    })

    $('#start-computer').click(function() {
        start('computer')
    })

    $('.space').hover(function() {
        if (isBlank(this) && boardEnabled) {
            $(this).children('i').addClass(humanPieceClass).addClass('hover')
        }
    }, function() {
        if (isBlank(this) && boardEnabled) {
            $(this).children('i').removeClass(humanPieceClass).removeClass('hover')
        }
    })

    $('.space').click(function() {
        if (isBlank(this) && boardEnabled) {
            $(this).children('i').addClass(humanPieceClass).prop('title', humanPiece).addClass('human')
            computerTurn(computerPiece, humanPiece);
        }
    })
})
