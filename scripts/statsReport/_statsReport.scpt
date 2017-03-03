JsOsaDAS1.001.00bplist00ÑVscript_.7/**
* _statsReport script
*
* Reporting helper script output count of @tags and/or sum of @tags(attribute) in appended project(s)
* Start creating and defining your reporting outputs after line 260
*/

function TaskPaperContextScript(editor, options) {
  var outline = editor.outline;
  // group all the changes together into a single change and make it a single "undo" action
  outline.groupUndoAndChanges(function () {

    /**
    * FUNCTION labelPadding();
    * Add padding between the label and output for the amount of 'padding' passed in
    *
    * PARAMETERS:
    * 'label' as String (label string)
    * 'padding' as Integer
    */
    var defaultPadding = 39;
    function labelPadding(label, padding) {
      var pad = ' ',
          delimiter = '|';
          altPadding = padding;

      // Handle case where label length exceed the requested/default padding value
      while (altPadding - label.length < 5) {
        altPadding = altPadding + 15;
      }

      // Add padding spaces after the label
      for (var i = (altPadding - label.length) - 1; i >= 0; i--) {
        pad += ' ';
      }

      // Return full label + padding + output delimiter
      // Add @stats tag (prevent counting them as stats and for styling purposes)
      return '@stats ' + label + pad + delimiter + '  ';
    }

    /**
    * FUNCTION sumTagAsPercentage();
    * Sum all number values for a given @tag and in a given search 'path'. 
    * It then append results as percentage to a given 'project'.
    *
    * PARAMETERS:
    * 'tag' as String (without leading @)
    * 'tagPath' as String (in an TaskPaper eval/search format => '@type = project and (@status = active)//@type = note')
    * 'outputProject' as TaskPaper Project Item
    * 'label' as String (pass '' to use defaul label)
    */
    function sumTagAsPercentage(tag, tagPath, outputProject, label) {

      // All the @tag items in outline search path
      var tagArray = outline.evaluateItemPath(tagPath);

      // Hold the sum of all the tags in path
      var sumTag = 0;

      // Hold defaul output label
      var defaultLabel = '> Sum of ';

      // Hold output item
      var tagStat;

      // Hold output item
      var tagName = tag.substring(1);

      // Labels & Padding
      var defaultLabel = labelPadding('> Sum of ' + tag + ' as percentage', defaultPadding),
          paramLabel = labelPadding(label, defaultPadding);

      // Sum all values of the tag in path
      tagArray.forEach(function(item) {
        var num = item.getAttribute('data-' + tagName, Number);
        // Exclude stats items from counter
        var itm = item.hasAttribute('data-stats');
        // chek if 'num' is not a number or inexistant
        if (!itm && !isNaN(num) && num != null) {
          sumTag = sumTag + num;  
        }
      });

      // Create item as @type = note + Label
      // if default label
      if (label == '')
      {
        tagStat = outline.createItem(defaultLabel + (Math.round(sumTag * 100)) + '%');
      } 
      // if parameter label
      else 
      {
        tagStat = outline.createItem(paramLabel + (Math.round(sumTag * 100)) + '%');
      }

      // Append sum to outputProject as percentage
      outputProject.appendChildren(tagStat);
    }

    /**
    * FUNCTION sumTagAsNumber();
    * Sum all number values for a given @tag and in a given search 'path'. 
    * It then append results as number to a given 'project'.
    *
    * PARAMETERS:
    * 'tag' as String (without leading @)
    * 'tagPath' as String (in an TaskPaper eval/search format => '@type = project and (@status = active)//@type = note')
    * 'outputProject' as TaskPaper Project Item
    * 'label' as String (pass '' to use defaul label)
    */
    function sumTagAsNumber(tag, tagPath, outputProject, label) {
      var tagArray = outline.evaluateItemPath(tagPath),
          sumTag = 0,
          tagName = tag.substring(1),
          tagStat;

      // Labels & Padding
      var defaultLabel = labelPadding('> Sum of ' + tag + ' as number', defaultPadding),
          paramLabel = labelPadding(label, defaultPadding);
      
      tagArray.forEach(function(item) {
        var num = item.getAttribute('data-' + tagName, Number),
            itm = item.hasAttribute('data-stats');
        if (!itm && !isNaN(num) && num != null) {
          sumTag = sumTag + num;  
        }
      });

      if (label == '') {
        tagStat = outline.createItem(defaultLabel + sumTag);
      } else  {
        tagStat = outline.createItem(paramLabel + sumTag);
      }

      // Append sum to outputProject as number
      outputProject.appendChildren(tagStat);
    }

    /**
    * FUNCTION tagCounter();
    * Count all @tags in a given search 'path' without a specific attribute.
    * It then append results as number to a given 'project'.
    *
    * PARAMETERS:
    * 'tag' as String (without leading @)
    * 'tagPath' as String (in an TaskPaper eval/search format => '@type = project and (@status = active)//@type = note')
    * 'outputProject' as TaskPaper Project Item
    * 'label' as String (pass '' to use defaul label)
    */
    function tagCounter(tag, tagPath, outputProject, label) {
      var tagArray = outline.evaluateItemPath(tagPath),
          countTag = 0,
          tagStat;

      // Labels & Padding
      var defaultLabel = labelPadding('> Count of ' + tag, defaultPadding),
          paramLabel = labelPadding(label, defaultPadding);

      tagArray.forEach(function(item) {
        var itm = item.hasAttribute('data-stats');
        if (!itm) {
          countTag++; 
        }
      });

      if (label == '') {
        tagStat = outline.createItem(defaultLabel + countTag);
      } else {
        tagStat = outline.createItem(paramLabel + countTag);
      }

      // Append count to outputProject as number
      outputProject.appendChildren(tagStat);
    }

    /**
    * FUNCTION tagAttributeCounter();
    * Count all @tags in a given search 'path' with a specific attribute. ex. @tag(attribute) 
    * It then append results as number to a given 'project'.
    *
    * PARAMETERS:
    * 'tag' as String (without leading @)
    * 'tagAttribute' as String (ex. 'active' to count @tag(active))
    * 'tagPath' as String (in an TaskPaper eval/search format => '@type = project and (@status = active)//@type = note')
    * 'outputProject' as TaskPaper Project Item
    * 'label' as String (pass '' to use defaul label)
    * 
    * TODO: Allow multiple tag attributes as Array parameter
    */
    function tagAttributeCounter(tag, tagAttribute, tagPath, outputProject, label) {
      var tagArray = outline.evaluateItemPath(tagPath),
          countTag = 0,
          tagName = tag.substring(1),
          tagStat;

      // Labels & Padding
      var attributeOutput = tagAttribute == '' ? '()' : '(' + tagAttribute + ')',
          defaultLabel = labelPadding('> Count of ' + tag + attributeOutput, defaultPadding),
          paramLabel = labelPadding(label, defaultPadding);

      tagArray.forEach(function(item) {

        // If item has a @tag attribute
        var itmAttribute = item.getAttribute('data-' + tagName);

        // // DEBUG
        // var itmAttTest = outline.createItem('>> Attribute of ' + tag + ' = [' + tagAttribute + '] match? [' + itmAttribute + ']'); // create item as @type = note
        // itmAttTest.setAttribute('data-stats', '');
        // outputProject.appendChildren(itmAttTest);

        var itm = item.hasAttribute('data-stats');
        if (!itm && itmAttribute == tagAttribute) {
          countTag++; 
        }
      });

      if (label == '') {
        tagStat = outline.createItem(defaultLabel + countTag);
      } else {
        tagStat = outline.createItem(paramLabel + countTag);
      }

      // Append count to outputProject as number
      outputProject.appendChildren(tagStat);
    }

    /**
    * FUNCTION createOutputProject();
    * Create or Reset a Taskpaper project at the end of the Taskpaper outline
    *
    * PARAMETERS:
    * 'pjcName' as String (existing or new project name)
    */
    function createOutputProject(pjcName) {
      // Reset/Create 'output:' project
      var outputProjectName = pjcName + ':',
          outputPath = '@type = project and ' + outputProjectName,
          outputProjectArray = outline.evaluateItemPath(outputPath),
          outputProjectItem = outline.createItem(outputProjectName); // create item as @type = project

      // Remove the 'output:' project from the outline if it exist
      if (outputProjectArray.length != 0) {
        outputProjectArray[0].removeFromParent();
      } 

      // Add @section tag (optional)
      outputProjectItem.setAttribute('data-section', '');

      // Append a new `STATS:` project to outline root
      outline.root.appendChildren(outputProjectItem);
      outputProjectArray = outline.evaluateItemPath(outputPath);
      return outputProjectArray[0];
    }




    /************************************************************************************
    START CREATING AND DEFINING YOUR REPORTING OUTPUTS HERE
    ************************************************************************************/

    // Create as many "stats" project sections as you wish
    var statsProject1 = createOutputProject('DEMO - Sum Example Stats');
    var statsProject2 = createOutputProject('DEMO - Counter Example Stats');

        // Example that output the sum of all @capacity tags with number attribute
        // and output as percentage ex. @tag(0.1) => 10%
        sumTagAsPercentage('@capacity', '@type = note and @capacity', statsProject1, '');

        // Example that output the sum of all @capacity tags with number attribute
        // and output as number ex. @tag(1) => 1
        sumTagAsNumber('@capacity', '@type = note and @capacity', statsProject1, '');

        // Simple Counter Example without attribute (count all @tag regardless of attribute)
        tagCounter('@capacity', '@type = note and @capacity', statsProject2, '');

        // Advanced Counter Example without attribute (count all @tag without attribute)
        tagAttributeCounter('@capacity', '', '@type = note and @capacity', statsProject2, '');

        // Advanced Counter Example with attribute (count all @tag with specific attribute)
        tagAttributeCounter('@capacity', '0.1', '@type = note and @capacity', statsProject2, '');
        
        // Default Label Example
        tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject2, '');
        // Parameter Label Example
        tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject2, '> Active Projects');
        // Extra Long Label Parameter Example
        tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject2, '> Active Projects for the current month');




    // My own reporting stuff I will actually use
    var statsProject = createOutputProject('STATS REPORT');

        // - Sum Total Capacty
        sumTagAsPercentage('@capacity', '@type = note and @capacity', statsProject, '> Capacity Allocation');

        // - Count Active Projects
        tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject, '> Active Projects');

        // - Count Projects on Hold
        tagAttributeCounter('@status', 'hold', '@type = project and @status', statsProject, '> Projects on Hold');

        // - Count Completed Project Accomplishments
        tagCounter('@accomplishment', '@type = project and (@status = cancelled or @status = delivered or @status = completed)//@accomplishment', statsProject, '> Accomplishments');




  }); // end outline.groupUndoAndChanges
} // end TaskPaperContextScript

var string = Application("TaskPaper").documents[0].evaluate({
  script: TaskPaperContextScript.toString()
});                              .M jscr  úÞÞ­