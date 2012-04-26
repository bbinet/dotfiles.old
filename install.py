#!/usr/bin/env python
import os
import fnmatch
import shutil

def run(cmd):
    """simple wrapper around os.system to log the command to sys.stdout"""
    print 'running: ' + cmd
    os.system(cmd)

exclude = ['*.sw*', '*.un~', '.git', '.gitignore', '.gitmodules', '[!.]*']
home = os.path.expanduser('~')

for f in os.listdir('.'):
    if not any(fnmatch.fnmatch(f, p) for p in exclude):
        path = os.path.join(home, f)
        if os.path.isfile(path) or os.path.islink(path):
            os.unlink(path)
        elif os.path.isdir(path):
            shutil.rmtree(path)
        print 'create link for %s' % (path)
        os.symlink(os.path.abspath(f), path)

vburrito = os.path.join(home, 'virtualenv-burrito')
shutil.copyfile('virtualenv-burrito/virtualenv-burrito.py', vburrito)
os.chmod(vburrito, 0755)

cmd = vburrito + ' upgrade'
vburrito_dir = os.path.join(home, '.venvburrito')
if not os.path.exists(os.path.join(vburrito_dir)):
    os.makedirs(os.path.join(vburrito_dir, 'lib', 'python'))
    os.makedirs(os.path.join(vburrito_dir, 'bin'))
    cmd += ' firstrun'
run(cmd)

venv_global = os.path.join(home, '.virtualenvs/global')
if not os.path.exists(venv_global):
    run('source %s && mkvirtualenv global' % \
            os.path.join(vburrito_dir, 'startup.sh'))

run(os.path.join(venv_global, 'bin', 'pip') + ' install -r requirements.txt')
