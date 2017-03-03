# Configuration Files, StyleSheets and Scripts for TaskPaper3

- *Tomorrow Night Eighties* inspired themes
- *Omnifocus* inspired default searches and tags/contexts
- *Cool Scripts* to help getting organized faster

![Preview of a taskpaper with the Dark StyleSheet applied](https://raw.githubusercontent.com/drootz/TaskPaperTheme-TomorrowEighties/master/preview/dark.png)
![Preview of a taskpaper with the Light StyleSheet applied](https://raw.githubusercontent.com/drootz/TaskPaperTheme-TomorrowEighties/master/preview/light.png)

These StyleSheets and Configuration Files for [TaskPaper](http://www.taskpaper.com) are great if:

- You are a "Tomorrow Night Eighties" theme enthusiast
- You like Omnifocus style default searches
- You like having similar color scheme between your Day/Night time themes
- You need inspirations to build you own theme & config files of yours

## Install the StyleSheets

1. [Download the zip][download] and open the zip file
2. `Window` menu > `StyleSheet` > `Open StyleSheet directory` *<-- from within TaskPaper*
3. Copy both `.less` files from the zip `StyleSheet` directory to the TaskPaper `StyleSheet` directory
4. `Window` menu > `StyleSheet` > `.less` *<-- also from within TaskPaper*

## Install the Configuration Files

1. [Download the zip][download] and open the zip file
2. `Window` menu > `StyleSheet` > `Open StyleSheet directory` *<-- from within TaskPaper*
3. Go back a level in the `StyleSheet` directory and open the `Configurations` directory
    - You should now be located in `/Application Support/Taskpaper/Configurations`
3. Copy and overwrite both `searches.taskpaper` and `tags.taskpaper` files from the zip `Configurations` directory to the TaskPaper `Configurations` directory

> I recommend backing up the files in `/Application Support/Taskpaper/Configurations` before proceeding in case you need to revert to the default settings at a later date.

## Get the Scripts

1. [Download the zip][download] and open the zip directory
2. The scripts and Keyboard Maestro macros are accessible in the `scripts` directory from the zip
3. General script usage instructions are available on [TP3 user's guide](https://guide.taskpaper.com) or [TaskPaper support forum](http://support.hogbaysoftware.com/t/taskpaper-extensions-wiki/1628).

### Scripts Description

#### 1. dueRefresh

Script that add/amend/remove tags to `@dueTomorrow`, `@dueToday` and `@pastDue` items when the `@due` tag match the format `@due(yyyy-mm-dd)`. It does more:

  - It remove any `@defer` tags if the tag date expired (ex. `@defer(2011-03-02)` where the date is <= today)
  - It does not add @pastDue tags on items tagged with `@done`, `@status(completed)`, `@status(delivered)` or `@status(cancelled)`

##### Output Example:

![Preview of a taskpaper with the Light StyleSheet applied](https://raw.githubusercontent.com/drootz/TaskPaperTheme-TomorrowEighties/master/scripts/dueRefresh/dueRefreshScriptExample.png)

#### 2. sortDone

Script that group and sort `@done(date)` items at the bottom of the project list in ascending order by date. Items with a `@status` tag are then pushed at the bottom and sorted by ascending `@done(date)` as well.

##### Output Example:

![Preview of a taskpaper with the Light StyleSheet applied](https://raw.githubusercontent.com/drootz/TaskPaperTheme-TomorrowEighties/master/scripts/sortDone/sortDoneScriptExample.png)

#### 3. statsReport

Reporting helper script that output count of @tags or @tags(attribute), and/or sum of @tags(attribute) in appended project(s). (*Start creating and defining your reporting outputs after line 260 of the script file*) Functions descriptions and additional usage examples are embedded in the script file.

Ensure to use one of themes in this Repo or ensure to append the following scope example at the  your theme.less files. The use of a monospace font enhance the visual consumption of the output data as shown in the following example image.

```css
item[data-stats] {
    font-size: @user-font-size;
    font-family: hack; // Hack or any other monospace font
    color: @text-color;
    font-style: normal;
    > run[content] {
        text-strikethrough: none;
        color: @text-color;
    }
    > run[tag] {
        text-strikethrough: none;
        color: fade(@text-color, 65%);
    }
    > run[tagvalue] {
      color: @text-color;
    }
}
```

##### Output Example:

```javascript
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

    // Default Label Example
    tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject2, '');
    // Parameter Label Example
    tagAttributeCounter('@status', 'active', '@type = project and @status', statsProject2, '> Active Projects');
```

![Preview of a taskpaper with the Light StyleSheet applied](https://raw.githubusercontent.com/drootz/TaskPaperTheme-TomorrowEighties/master/scripts/statsReport/statsReportExample.png)

[download]: https://github.com/drootz/TaskPaperTheme-TomorrowEighties/archive/master.zip



## 💙 TaskPaper

Thanks [Jesse Grosjean](http://www.hogbaysoftware.com/about) for TaskPaper 3.
