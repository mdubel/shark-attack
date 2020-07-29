from invoke import task, Collection
import collections
import yaml
import sys

config_path = "environment/workflow.yml"

def read_config():
    with open(config_path, 'r') as stream:
        # All config values should be strings
        return {k: str(v) for k, v in yaml.safe_load(stream).items()}

config = read_config()

def update_tag(new_tag):
    with open(config_path, 'w') as stream:
        config['rstudio_tag'] = new_tag
        yaml.dump(config, stream, default_flow_style=False)

def new_image(c, tag = None, method = 'build'):
    if tag:
        if method == 'build':
            c.run(f"docker build . -f environment/Dockerfile -t {config['rstudio_image']}:{tag}", echo = True)
        elif method == 'snapshot':
            c.run(f"docker commit {config['rstudio_container_name']} {config['rstudio_image']}:{tag}", echo = True)

        print("Updating the tag in workflow.yml file.")
        print("Remember to commit changes to the repository after pushing the image to the registry.\n")
        update_tag(tag)
    else:
        print(f"Missing tag argument. Example: ./workflow {method} --tag=1.0")



# TASK DEFINITIONS
ns = Collection('rstudio')
ns.configure(read_config())

@task(help={'tag': 'Tag for new image'})
def build(c, tag=None):
    """Build project image based on environment/Dockerfile"""
    new_image(c, tag, method = 'build')
ns.add_task(build)

@task(help={'tag': 'Tag for new image'})
def snapshot(c, tag=None):
    """Save project image based on the current state of a container"""
    new_image(c, tag, method = 'snapshot')
ns.add_task(snapshot)

@task
def start(c):
    """Run full development environment"""
    c.run("docker-compose up -d", env=config, echo = True)
    c.run(f"{'open' if sys.platform == 'darwin' else 'xdg-open'} http://localhost:8787")
ns.add_task(start)

@task
def push(c):
    """Push created images to docker registry"""
    c.run(f"docker push {config['rstudio_image']}:{config['rstudio_tag']}", echo = True)
ns.add_task(push)

@task
def ps(c):
    """List running docker-compose services"""
    c.run("docker-compose ps", env=config, echo = True)
ns.add_task(ps)

@task
def down(c):
    """Bring down the development environment"""
    c.run("docker-compose down", env=config, echo = True)
ns.add_task(down)

@task
def bash(c):
    """Execute shell in the rstudio container"""
    c.run(f"docker-compose exec rstudio bash", env=config, pty=True, echo = True)
ns.add_task(bash)

@task
def r(c):
    """Execute R shell in the rstudio container"""
    c.run(f"docker-compose exec rstudio radian", env=config, pty=True, echo = True)
ns.add_task(r)

@task
def prune(c):
    """This will remove unused containers, networks, dangling images and cache
       - all stopped containers
       - all networks not used by at least one container
       - all dangling images
       - all dangling build cache"""
    c.run("docker system prune", echo = True)
ns.add_task(prune)

@task
def lint(c):
    """Lint R sources"""
    c.run("docker-compose exec -T rstudio Rscript '/mnt/lint/lint.R'", echo=True)
ns.add_task(lint)

@task
def test(c):
    """Run unit tests"""
    # TODO: Run all the files in `tests/` instead of hardcoding a single unit test script.
    c.run("docker-compose exec -T rstudio Rscript '/mnt/tests/testthat.R'", echo=True)
ns.add_task(test)
