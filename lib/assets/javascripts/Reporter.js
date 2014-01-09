var Reporter = function(computerElement, humanElement, promptElement) {
  this.computerElement = $(computerElement);
  this.humanElement = $(humanElement);
  this.promptElement = $(promptElement);
};

Reporter.prototype.start = function(message) {
  this.humanElement.html('I\'ll start over.');
  this.computerElement.html('You start over.');
};

Reporter.prototype.updateStatus = function(status) {
  if (status == 'draw') {
    this.promptElement.html('It\'s a draw.');
  } else if (status == 'win') {
    this.promptElement.html('I win.');
  } else {
    this.promptElement.html('Go.');
  }
};

Reporter.prototype.think = function() {
  this.promptElement.html('<i class="fa fa-cog fa-spin fa-2x"></i>');
};
