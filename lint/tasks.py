from invoke import task, Collection

ns = Collection('lint')

@task
def r_local_dependencies(c):
    """Install packages required for running R linter locally"""
    c.run("Rscript -e \"install.packages(c('optparse', 'lintr'))\"")
ns.add_task(r_local_dependencies)

@task
def r_docker(c):
    """Check R code with Linter (inside Docker container)"""
    c.run("docker-compose exec -T rstudio bash -c 'cd /mnt; Rscript lint/lint.R'", echo=True)
ns.add_task(r_docker)

@task
def r_local(c):
    """Check R code with Linter (locally)"""
    c.run("Rscript lint/lint.R", echo=True)
ns.add_task(r_local)
