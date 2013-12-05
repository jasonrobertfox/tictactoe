$(document).foundation();

var activeGame = false;
var humanPieceClass = '';
var humanPiece = '';
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
    $('.space').children('i').removeClass('x').removeClass('o').removeClass(humanPieceClass).removeClass('selected')
    startGame();
}

function startGame(){
    activeGame = true;
    computerMessage('You start over.')
    humanMessage('I\'ll start over.')
}

function isBlank(space){
    if($(space).children('i').hasClass('x') || $(space).children('i').hasClass('o')){
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
        boardEnabled = true;
    }else{
        promptThinking()
        humanPieceClass = 'fa-circle-o'
        humanPiece = 'o'
        boardEnabled = false;
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
            $(this).children('i').addClass(humanPieceClass).addClass(humanPiece).addClass('selected')
        }
    })
})
