* Updated 1 Feb 2023

This file describes folder organization.
For project current description you should check the project_report file (in Gdrive, not publicly available)

All these files support the project G-drive folder.
There are files of the current project and other that may be important afterwards or for other aproaches.

You will find:
- data: where we downloaded the data we are working with 
- analysis: where we analyse de data, enhance it, plot it, where we make fast analysis or simulations/experiments
- not_used: things that are not yet used, or things that were not organized and are no longer used
- publishing (Gdrive): where we save seminars, posters, papers
- bibliography (Gdrive): the references needed to unsterstand the project
- documentation (Gdrive): legal documentation or proving documentation for founding agencies

Inside each folder you sould look for:
- readme.md: file that will describe the folder
- history.sh: file that indeicated the commands runned so far (if any)

In the root folder of the project you will find the script project_vars.sh that defines some variables to work more confortably, run 
`source project_vars.sh`
to load them.

A warning: the name of the folders have changed lately, all the scripts may have wrong paths. Check before using them


# Project Best Practices
This repository contains the best practices to follow while working on our project.

1. Commits
Commits should be frequent, happening at each fullfilled mini-task, and should contain a clear message about the changes made. If needed, include clarifications in the body of the message:

`git comit -m "Title" -m "Clarifications..."`

2. Pushes
Push your code to the repository at least the end on the working day to ensure back up and accessibility to other team members.

3. Branch naming
Each new feature/bug/release will have its own branch. Branch names should  follow this convention: 
* analysis-<analysisname> for analysis
* add-<featurename> for features
* fix-<bugname> for bugs
* release-<version> for releases of software, deploys or archives to present to journals
* hotfix-<release or deploy version> for hotfixes tied a release branch

4. Branch coding
Branches should be as encapsulated as they can:
* New folders are better than new files
* New files are better than file modifications
* When modifying a file, include/replace only one block of code
* Including/modifying two blocks is the limit
If you need to modify more, inform the team to plan how this should be done.

5. Pull Requests
Run tests (if any) before making a pull request to the main branch.

6. Issue Tracking
Use the issue tracking system to report bugs. Feature suggestions will be written in another place. 

7. Data size
No heavy data should be included in the repository.

Conclusion
By following these best practices, we can ensure that our project is well-organized, secure, and easy to maintain. Thanks and happy coding!
