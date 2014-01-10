describe('Reporter', function() {

  beforeEach(function() {
    ce = $('<p id="computer">You Start</p>');
    he = $('<p id="human">You Start</p>');
    pe = $('<p id="prompt">You Start</p>');
    reporter = new Reporter(ce, he, pe);
  });

  it('Should be constructed', function() {
    expect(reporter).toBeDefined();
  });

  it('Can set the start messages.', function() {
    reporter.start();
    expect(ce).toContainText('You start over.');
    expect(he).toContainText('I\'ll start over.');
  });

  it('Can set go', function() {
    reporter.updateStatus('active');
    expect(pe).toContainText('Go.');
  });

  it('Can set draw', function() {
    reporter.updateStatus('draw');
    expect(pe).toContainText('It\'s a draw.');
  });

  it('Can set win', function() {
    reporter.updateStatus('win');
    expect(pe).toContainText('I win.');
  });

  it('Can think', function() {
    reporter.think();
    expect(pe).toContainHtml('<i class="fa fa-cog fa-spin fa-2x"></i>');
  });

});
