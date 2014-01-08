describe("MessageWriter", function(){

  beforeEach(function() {
    ce = $('<p id="computer">You Start</p>')
    he = $('<p id="human">You Start</p>')
    pe = $('<p id="prompt">You Start</p>')
    mw = new MessageWriter(ce, he, pe);
  });


    it("Should be constructed", function(){
        expect(mw).toBeDefined();
    });

    it("Can update the message for the computer", function(){
        mw.setComputerMessage('Computer Message');
        expect(ce).toContainText('Computer Message');
    });

    it("Can update the message for the human", function(){
      mw.setHumanMessage('Human Message');
      expect(he).toContainText('Human Message');
    });

    it("Can set the prompt message", function(){
      mw.setPromptMessage('Prompt Message');
      expect(pe).toContainText('Prompt Message');
    })

    it("Can update the prompt to thinking", function(){
      mw.think()
      expect(pe).toContainHtml('<i class="fa fa-cog fa-spin fa-2x"></i>')
    })

})
