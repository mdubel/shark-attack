<<<<<<< HEAD
# Appsilon Project Patterns

Single feature / solution is called a *pattern*. Each pattern is a separate branch,
that can be added to your project using
```
workflow add --pattern={pattern}
```

You can start developing new pattern by forking `new-pattern` branch. Please create the README
and explain how to use your pattern, e.g. which parts of the code should be configured manually.
Mark those parts clearly in the code with `_todo_` comment.

#### How to use *patterns*

1. Create new project repository.
1. Make sure you have installed [workflow](https://github.com/Appsilon/workflow). Run `workflow --list` to see available tasks.
1. Initialize workflow with `workflow init` in your project repository. It will add *project.patterns* repo as git remote.
1. Run `workflow ls` to see available patterns.
1. Add pattern with `workflow add --pattern={pattern-branch-name}`. In fact you will git fetch a pattern branch to your repo.
   You can treat adding a pattern branch like a work from external developer, who wants to contribute to your project.
1. Update newly added files manually according to the pattern README, commit your changes and resolve merge conflicts.
1. Push pattern to the origin, open pull request and ask for code review.
1. Decide how you want to merge pull request. For commercial projects it is recommended to squash pattern branch history.

Note: "production ready" patterns have prefix `pattern/` and it is enough to use it's name without prefix:

```
workflow add --pattern=rstudio
```

