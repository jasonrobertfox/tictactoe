$(document).foundation();

var activeGame = false;
var humanPieceClass = '';
var computerPieceClass = '';
var humanPiece = '';
var computerPiece ='';
var boardEnabled = false;

function computerMessage(message){
    $('#start-computer p').html(message)
}

function humanMessage(message){
    $('#start-human p').html(message)
}

function promptMessage(message){
    if($('#prompt').hasClass('hide')){
        $('#prompt').removeClass('hide');
        $('#thinking').addClass('hide');
    }
    $('#prompt').html(message)
}

function promptThinking(){
    if($('#thinking').hasClass('hide')){
        $('#thinking').removeClass('hide');
        $('#prompt').addClass('hide');
    }
}

function startGame(){
    $('.space').removeClass('winning');
    $('.space').children('i').prop('title', '').removeClass(humanPieceClass).removeClass(computerPieceClass).removeClass('selected').removeClass('winning');
    activeGame = true;
    computerMessage('You start over.')
    humanMessage('I\'ll start over.')
}

function isBlank(space){
    if($(space).children('i').prop('title') == 'x' || $(space).children('i').prop('title') == 'o'){
        return false;
    }else{
        return true;
    }
}

function start(firstPlayer){
    startGame();
    if (firstPlayer == 'human'){
        promptMessage('Go.');
        humanPieceClass = 'fa-times'
        computerPieceClass =  'fa-circle-o'
        humanPiece = 'x'
        computerPiece = 'o'
        boardEnabled = true;
    }else{
        humanPieceClass = 'fa-circle-o'
        computerPieceClass = 'fa-times'
        humanPiece = 'o'
        computerPiece = 'x'
        boardEnabled = false;
        computerTurn(computerPiece);
    }
}

function readBoard(){
    var board = []
    $('.space').map(function(){
        var id = this.id;
        var value = $(this).children('i').prop('title');
        var space = {}
        space['id'] = id
        space['value'] = value
        board.push(space)
    })
    return board;
}

function checkForWin(boardArray, piece){
    //load the board in to a matrix for comparison
    var board = [[],[],[]]
    var row = 0;
    var column = 0;
    for (index = 0; index < boardArray.length; ++index){
        board[row][column] = boardArray[index]
        if(column == 2){
            column = 0;
            ++row;
        }else{
            ++column;
        }
    }

    //loop through the rows to check for a win, return the "winning spaces"
    for(row = 0; row < 3; ++row){
        var thisRow = board[row]
        if (thisRow[0]['value'] == piece && thisRow[1]['value'] == piece && thisRow[2]['value'] == piece){
            return thisRow;
        }
    }

    //loop through the columns to check for a win, return the "winning spaces"
    for(column = 0; column <3; ++column){
        if(board[0][column]['value'] == piece && board[1][column]['value'] == piece && board[2][column]['value'] == piece){
            return [board[0][column], board[1][column], board[2][column]]
        }
    }

    //check the diagonals
        if(board[0][0]['value'] == piece && board[1][1]['value'] == piece && board[2][2]['value'] == piece){
            return [board[0][0], board[1][1], board[2][2]];
        }else if(board[0][2]['value'] == piece && board[1][1]['value'] == piece && board[2][0]['value'] == piece){
            return [board[0][2], board[1][1], board[2][0]];
        }

    //check for a draw
    for (index = 0; index < boardArray.length; ++index){
        if(boardArray[index]['value'] == ''){
            return false
        }
    }
    return 'draw'
}

function checkGameFinished(piece){
    boardArray = readBoard();
    state = checkForWin(boardArray, piece)
        if(state){
            boardEnabled = false;
            if(state == 'draw'){
                promptMessage('It\'s a draw.');
                return true;
            }else{
                if(piece == humanPiece){
                    promptMessage('Nice job, winner.');
                }else{
                    promptMessage('I win.');
                }
                highlightWinningSpaces(state)
                return true;
            }
        }
        return false;
}

function writeBoard(spaces){
    for (index = 0; index < spaces.length; ++index){
        var space = spaces[index]
        $('#'+space['id']).children('i').prop('title', space['value'])
        if (space['value'] == 'x'){
            $('#'+space['id']).children('i').addClass('fa-times')
            $('#'+space['id']).children('i').removeClass('fa-circle-o')
        }else if(space['value'] == 'o'){
            $('#'+space['id']).children('i').addClass('fa-circle-o')
            $('#'+space['id']).children('i').removeClass('fa-times')
        }
        if (space['value'] == humanPiece) {
            $('#'+space['id']).children('i').addClass('selected')
        } else {
            $('#'+space['id']).children('i').removeClass('selected')
        }
    }
    return checkGameFinished(computerPiece)
}

function highlightWinningSpaces(spaces){
    for (index = 0; index < spaces.length; ++index){
        $('#'+ spaces[index]['id']).addClass('winning');
    }
}

function computerTurn(piece){
    //this will simulate a random choice by the computer to test the back and forth
    var data = {}
    data['piece'] = piece
    data['board'] = readBoard();

    console.log(data)
    console.log(JSON.stringify(data))

    $.ajax({
        type: 'POST',
        url: '/api/v1/play',
        dataType: 'json',
        data: JSON.stringify(data),
        processData: false,
        beforeSend: function(){
            boardEnabled = false;
            promptThinking();
        },
        success: function(data, status, jqxhr){
            boardArray = data['data']['board']
            if(! writeBoard(boardArray)){
                 // if the game has not just been won or drawn, pass back to player
                promptMessage('Go.');
                boardEnabled = true;
            }
        }
      });
}

$(document).ready(function(){
    $('#start-human').click(function(){
        start('human')
    })

    $('#start-computer').click(function(){
        start('computer')
    })

    $('.space').hover(function(){
        if(isBlank(this) && boardEnabled){
            $(this).children('i').addClass(humanPieceClass)
        }
    },function(){
        if(isBlank(this) && boardEnabled){
            $(this).children('i').removeClass(humanPieceClass)
        }
    })

    $('.space').click(function(){
        if(isBlank(this) && boardEnabled){
            $(this).children('i').addClass(humanPieceClass).prop('title', humanPiece).addClass('selected')
            if( ! checkGameFinished(humanPiece)){
                computerTurn(computerPiece);
            }
        }
    })
})
