# xccovAnalyzer

xccovAnalyzer is a macOS command line tool Application, writen in Swift, for Xcode projects which allows generating tailored code coverage and publishing the code coverage report to a github's pull request.

It has three commands `analyze`, `diff` and `publish`.

What xccovAnalyzer can help you do:
* Give you full control over the files and methods inside those files you want to include/exclude in your test reports
* Generate multiple different test coverages reports with different file combinations
* Publish/Update the code coverage of your modified files of your pull request

 ## Table of contents
 <!--- TOC-START -->
- [Analyze Command](#analyze-command)
- [Diff Command](#diff-command)
- [Publish Command](#publish-command)
- [Preview of Pull Request Code Coverage](#preview-of-pull-request-code-coverage)
 <!--- TOC-END -->

# Analyze Command
Lets use this project as an example to showcase how to use the tool

1. Clone the repository
2. Build the project (cmd + b)
3. Locate xccovAnalyzer executable under products folder and show it in finder
4. Copy the xccovAnalyzer file
5. Create a bin folder, at the same level of README.md file, and inside it create another folder called xccov (For better organization)
6. Paste the xccovAnalyzer file inside the xccov folder
7. Create a file named `xccovConfig.yml` inside the xccov folder

**xccovConfig.yml**
``` yml
projectRelativePath: "../../xccovAnalyzer/xccovAnalyzer.xcodeproj"
```

8. Run the tests of the project (cmd + u)
9. Execute xccovAnalyzer analyze<br>
```$ ./bin/xccov/xccovAnalyzer analyze```<br>
This will generate a `test_report.json` (A Json representation of the test report from the .xcresult file)

### Optional projectRelativePath
You can run the `analyze` command passing the .xcresult path as an argument. If you do this the projectRelativePath property from the yml file is not necessary anymore.<br>
``` sh
$ ./bin/xccov/xccovAnalyzer analyze /Users/emiliano.alvarez/Library/Developer/Xcode/DerivedData/xccovAnalyzer-hetustjvfflikaettpnxiosnzbjk/Logs/Test/Test-xccovAnalyzer-2020.09.10_17-35-50-+0200.xcresult
```

### The values inside the xccovConfig.yml file
``` yml
projectRelativePath: The relative path for the xcode project (Optional value)
filterRules: The filter rules to apply to the xcresult file (Optional value)
  - targetName: The exact name that appears in the code coverage report. Examples: xccovAnalyzer, app.framework, app.xctest. (Mandatory value)
    displayName: The name you would like to give to your test report in replacement of the targetName. If this value is not supplied it will use the target name (Optional value)
    includedPaths: The only folders you would like to include (Optional value)
    excludedPaths: The folders that you want to exclude (Optional value)
    includedFilesNames: The only files that you would like to include (Optional value)
    excludedFilesNames: The files that you would like to exclude (Optional value)
    excludedFunctionsNames: The methods within a file that you would like to exclude (Optional value)
```

### Including/Excluding Files
You want to include the files that contains Reader.swift, Writer.swift and Publisher.swift and want to exclude files that contains CoveragePublisher.swift.

**xccovConfig.yml**
``` yml
projectRelativePath: "../../xccovAnalyzer/xccovAnalyzer.xcodeproj"
filterRules:
  - targetName: "xccovAnalyzer"
    displayName: "Unit Tests"
    includedFilesNames:
        - "Reader.swift"
        - "Writer.swift"
        - "Publisher.swift"
    excludedFilesNames:
        - "CoveragePublisher.swift"
```
The `test_report.json` should now contain only 3 files in the test report and use only those to generate a test report:<br>
"TestFileJsonReader.swift", "MessageWriter.swift" and "GithubReviewPublisher.swift"

### Including/Excluding Paths and Files
You want to include only files from the TestAnalyzer and TestDiff folder and you want to exclude the Data folder inside TestAnalyzer and the TestAnalyzer.swift file.

**xccovConfig.yml**
``` yml
projectRelativePath: "../../xccovAnalyzer/xccovAnalyzer.xcodeproj"
filterRules:
  - targetName: "xccovAnalyzer"
    displayName: "Unit Tests"
    includedPaths:
       - "src/TestAnalyzer"
       - "src/TestDiff"
    excludedPaths:
       - "src/TestAnalyzer/Data"
    excludedFilesNames:
        - "TestAnalyzer.swift"
```

### Excluding Methods within a file
You want to remove a particular method within a file, for example TestReportComparator.swift has 98.0% of code coverage and you don't want to include the method that is not tested.

``` yml
projectRelativePath: "../../xccovAnalyzer/xccovAnalyzer.xcodeproj"
filterRules:
  - targetName: "xccovAnalyzer"
    displayName: "Unit Tests"
    excludedFunctionsNames:
      - "implicit closure #1 () throws -> Swift.Double in static xccovAnalyzer.TestReportComparator.compareTestReports(_: xccovAnalyzer.TestReport, historyTestReport: Swift.Optional<xccovAnalyzer.TestReport>) -> xccovAnalyzer.CoverageReport"
```

### Multiple tests reports
You can create n test reports with different file combinations.

``` yml
projectRelativePath: "../../xccovAnalyzer/xccovAnalyzer.xcodeproj"
filterRules:
  - targetName: "xccovAnalyzer"
    displayName: "Unit Tests 1"
    includedFilesNames:
      - "Reader.swift"
      - "Writer.swift"
      - "Presenter.swift"
  - targetName: "xccovAnalyzer"
    displayName: "Unit Tests 2"
    includedFilesNames:
      - "Publisher.swift"
      - "Formatter.swift"
      - "Publisher.swift"
  - targetName: "xccovAnalyzer"
    displayName: "Integration Tests"
    includedFilesNames:
      - "ViewController.swift"
      - "View.swift"
```

# Diff Command
First you need to run the `analyze` command, because it requires to read the `test_report.json` file. This command will read and compare the `test_report.json` file with another file called `history_test_report.json` (This is a historical file of the code coverage) and generate another file named `diff_report.json`. This file contains information from all the test targets and their current and previous coverage and the delta between these two.
When there's no `history_test_report.json` the previous coverage will be zero and thus the delta will be equal to the current coverage.

For testing purposes you can copy the `test_report.json` and name it `history_test_report.json` and run the diff command<br>
``` sh
$ ./bin/xccov/xccovAnalyzer diff
```

# Publish Command
First you need to run the diff command, because it requires to read the `diff_report.json` file. This command publishes a comment in a github's pull request and  requires 5 extra parameters:
1. The repository owner
2. The repository name
3. The pull request number where you want to comment
4. A github user
5. A github personal access token

Using this repository as an example:
``` sh
$ ./bin/xccov/xccovAnalyzer publish emilianoalvarez91 xccovAnalyzer 1 {Your github user account} {Your github personal Access token}
```

### Downloading/Uploading the history_report_json and working with the CI to automate the process
As example I would be using Bitrise

Let's consider you have 2 workflows in bitrise:
1. To check Pull requests
2. To create test version of your app once a PR is merged

**In the Pull request workflow**
1. Add a Unit Test step
2. Add a download step to download the `history_report.json` file from a storage server<br>
For the download destination path use:<br>
bin/xccov/history_test_report.json
3. Add a script step and run:
``` sh
#!/usr/bin/env bash
./bin/xccov/xccovAnalyzer analyze $BITRISE_XCRESULT_PATH
./bin/xccov/xccovAnalyzer diff
./bin/xccov/xccovAnalyzer publish $REPO_OWNER $REPO_NAME $BITRISE_PULL_REQUEST $GITHUB_PUSH_TAG_USERNAME $GITHUB_PUSH_TAG_TOKEN
```

**In the Test version workflow**
1. Add a Unit Test step
2. Add a script step and run:
``` sh
#!/usr/bin/env bash
./bin/xccov/xccovAnalyzer analyze $BITRISE_XCRESULT_PATH
mv bin/xccov/test_report.json bin/xccov/history_test_report.json
```
3. Add a file upload step and send:<br>
bin/xccov/history_test_report.json

# Preview of Pull Request Code Coverage
### Targets coverage
|Target|Current %|Previous %|Coverage Δ|
|---|---:|---:|---:|
|Unit Tests|100.00%|0.00%|100.00% :metal:|

### Unit Tests files coverage
|File|Current %| Previous %| Coverage Δ |
|---|---:|---:|---:|
|TestReportFilter.swift|100.00%|0.00%|100.00% :metal:|
|TestReportComparator.swift|100.00%|0.00%|100.00% :metal:|

Powered by [xccovAnalyzer](https://github.com/emilianoalvarez91/xccovAnalyzer)
