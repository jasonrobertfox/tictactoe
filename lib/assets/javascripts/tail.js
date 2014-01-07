$(document).foundation();

var activeGame = false;
var humanPieceClass = '';
var computerPieceClass = '';
var humanPiece = '';
var computerPiece ='';
var boardEnabled = false;

function helloWorld() {
    return "Hello world!";
}

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

        if (space['winning_space'] == true) {
            $('#'+ space['id']).addClass('winning');
        }
    }
}



function computerTurn(playerPiece, opponentPiece){
    //this will simulate a random choice by the computer to test the back and forth
    var data = {}
    data['player_piece'] = playerPiece
    data['opponent_piece'] = opponentPiece
    data['board'] = readBoard();
    $.ajax({
        type: 'POST',
        url: '/api/v2/play',
        dataType: 'json',
        data: JSON.stringify(data),
        processData: false,
        beforeSend: function(){
            boardEnabled = false;
            promptThinking();
        },
        success: function(data, status, jqxhr){
            boardArray = data['data']['board']
            writeBoard(boardArray)
            if (data['data']['status'] == 'draw') {
                promptMessage('It\'s a draw.');
            }else if (data['data']['status'] == 'win') {
                if(data['data']['winner'] == humanPiece){
                    promptMessage('Nice job, winner.');
                }else{
                    promptMessage('I win.');
                }
            } else {
                promptMessage('Go.');
                boardEnabled = true;
            }
        }
      });
}

function start(firstPlayer){
    startGame();
    if (firstPlayer == 'human'){
        promptMessage('Go.');
        humanPieceClass = 'fa-times';
        computerPieceClass =  'fa-circle-o';
        humanPiece = 'x';
        computerPiece = 'o';
        boardEnabled = true;
    }else{
        humanPieceClass = 'fa-circle-o';
        computerPieceClass = 'fa-times';
        humanPiece = 'o';
        computerPiece = 'x';
        boardEnabled = false;
        computerTurn(computerPiece, humanPiece);
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
            computerTurn(computerPiece, humanPiece);
        }
    })
})
