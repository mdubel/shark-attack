from invoke import task, Collection

ns = Collection('shiny')

@task
def init(c):
    """Install dependencies for this pattern"""
    c.run("echo 'hello world'")
ns.add_task(init)
