#!/usr/bin/env python3

try:

  from invoke import task, Program, Collection
  from importlib.machinery import SourceFileLoader
  import os

  repo = "git@github.com:Appsilon/project.patterns.git"

  @task
  def init(c):
    """Initialize workflow in a recently cloned project repo. It will add patterns remote."""
    c.run(f"git remote add patterns {repo}", echo = True)

  @task
  def add(c, pattern = None, explicit_branch = False):
    """Add pattern to your project."""
    if pattern:
      branch = pattern if explicit_branch else f"pattern/{pattern}"
      matching = c.run(f"git ls-remote -h {repo} | grep '{branch}$' | wc -l", hide='out')
      if int(matching.stdout) == 0:
        print("Pattern does not exist. Please check if provided pattern name is correct.")
        exit(1)
      print("Make sure you have no unstaged changes. I am starting new feature branch and pulling the pattern")
      c.run(f"git checkout -b {branch}", echo = True)
      c.run(f"git pull patterns {branch} --allow-unrelated-histories", echo = True)
    else:
      print("No pattern selected")

  @task
  def ls(c):
    """List all available patterns"""
    print("Available patterns:")
    patterns = c.run(f"git ls-remote -h {repo}", hide='out')
    patterns = patterns.stdout.split("refs/heads/")
    for pattern in patterns:
      pattern = pattern.split("\n")
      if "experimental/" in pattern[0] or "pattern/" in pattern[0]:
        print(pattern[0])


  # Workflow scans all directories to find tasks.py
  # Read about adding tasks with namespaces and collections here:
  # http://docs.pyinvoke.org/en/stable/concepts/namespaces.html
  namespace = Collection(init, add, ls)
  all_task_files = [f"{directory[0]}/tasks.py" for directory in os.walk(".") if 'tasks.py' in directory[2]]
  all_task_modules = [
    SourceFileLoader( # Load tasks.py as module by providing its path
      task_file_path.replace('.py','').replace('.','').replace('/','_'), # Construct module name from file path
      task_file_path).load_module() for task_file_path in all_task_files]
  for task_module in all_task_modules:
    namespace.add_collection(task_module.ns)

  program = Program(
    version = "2.0",
    namespace = namespace,
    binary = "workflow"
  )
  program.run()

except ModuleNotFoundError:

  import os

  print("You are probably running workflow for the first time")
  print("Press [enter] to install pyinvoke or Ctrl+C to abort\n")
  input()

  os.system("sudo pip3 install invoke==1.4.1")
