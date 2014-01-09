describe('Player', function() {

  it('Should be constructed', function() {
    firstPlayer = new Player('x', 'fa-times');
    expect(firstPlayer.piece).toBe('x');
    expect(firstPlayer.iconClass).toBe('fa-times');
  });

});
