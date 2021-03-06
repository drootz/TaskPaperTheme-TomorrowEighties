JsOsaDAS1.001.00bplist00�Vscript_function TaskPaperContextScript(editor, options) {
    var today = DateTime.format('today');
    var outline = editor.outline;
    var selx = editor.selection || undefined;
    
    outline.groupUndoAndChanges(function () {

      outline.evaluateItemPath('//@defer = [d] today')
      .forEach(function (each) {
        each.removeAttribute('data-defer');
      });
      
      outline.evaluateItemPath('//@defer < [d] today')
      .forEach(function (each) {
        each.removeAttribute('data-defer');
      });
      
      outline.evaluateItemPath('//@dueToday')
      .forEach(function (each) {
        each.removeAttribute('data-dueToday');
      });

      outline.evaluateItemPath('//@dueTomorrow')
      .forEach(function (each) {
        each.removeAttribute('data-dueTomorrow');
      });

      outline.evaluateItemPath('//@pastDue')
      .forEach(function (each) {
        each.removeAttribute('data-pastDue');
      });

      outline.evaluateItemPath('//not @done and @due = [d] today')
      .forEach(function (each) {
        each.setAttribute('data-dueToday', '');
      });

      outline.evaluateItemPath('//not @done and @due = [d] tomorrow')
      .forEach(function (each) {
        each.setAttribute('data-dueTomorrow', '');
      });

      outline.evaluateItemPath('//not @done and @due < [d] today')
      .forEach(function (each) {
        each.setAttribute('data-pastDue', '');
      });
	  
      outline.evaluateItemPath('//(@status = delivered or @status = cancelled or @status = completed) and @due < [d] today')
      .forEach(function (each) {
        each.removeAttribute('data-pastDue', '');
      });

    });
	
    editor.moveSelectionToRange(selx.location);
     
}

Application("TaskPaper")
.documents[0].evaluate({
    script: TaskPaperContextScript.toString()
})                              % jscr  ��ޭ