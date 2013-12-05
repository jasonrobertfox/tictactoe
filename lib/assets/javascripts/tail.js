$(document).foundation();

var activeGame = false;
var humanPieceClass = '';
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

function resetGame(){
    $('.space').removeClass('winning');
    $('.space').children('i').prop('title', '').removeClass(humanPieceClass).removeClass('selected').removeClass('winning');
    startGame();
}

function startGame(){
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
    if(activeGame){
        resetGame();
    }else{
        startGame();
    }
    if (firstPlayer == 'human'){
        promptMessage('Go.');
        humanPieceClass = 'fa-times'
        humanPiece = 'x'
        computerPiece = 'o'
        boardEnabled = true;
    }else{
        promptThinking()
        humanPieceClass = 'fa-circle-o'
        humanPiece = 'o'
        computerPiece = 'x'
        boardEnabled = false;
    }
}

function readBoard(){
    var boardArray =  $('.space').map(function(){
        var id = this.id;
        var value = $(this).children('i').prop('title');
        var space = {}
        space['id'] = id
        space['value'] = value
        return space
    })
    return boardArray;
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
            }else{
                if(piece == humanPiece){
                    promptMessage('Nice job, winner.');
                }else{
                    promptMessage('I win.');
                }
                highlightWinningSpaces(state)
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
    checkGameFinished(computerPiece)
}

function highlightWinningSpaces(spaces){
    for (index = 0; index < spaces.length; ++index){
        $('#'+ spaces[index]['id']).addClass('winning');
    }
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
                // pass board off to the computer player
            }
        }
    })
})
