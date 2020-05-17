from invoke import task, Collection

ns = Collection('new_pattern') # __todo__ rename your pattern

@task
def init(c):
    """Install dependencies for this pattern"""
    c.run("echo 'hello world'")
ns.add_task(init)
