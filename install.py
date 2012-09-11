#!/usr/bin/env python
import os
import fnmatch
import shutil

home = os.path.expanduser('~')
vburrito_dir = os.path.join(home, '.venvburrito')
vburrito = os.path.join(vburrito_dir, 'bin', 'virtualenv-burrito')
venv_global = os.path.join(home, '.virtualenvs/global')
venv_syntax_checkers = os.path.join(home, '.virtualenvs/syntax-checkers')
dotfiles_dir = os.path.join(home, '.dotfiles')
exclude = ['*.sw*', '*.un~', '.git', '.gitignore', '.gitmodules', '[!.]*']

def run(cmd):
    """simple wrapper around os.system to log the command to sys.stdout"""
    print 'running: ' + cmd
    os.system(cmd)

# install virtualenv-burrito
cmd = vburrito + ' upgrade'
if not os.path.exists(os.path.join(vburrito_dir)):
    os.makedirs(os.path.join(vburrito_dir, 'lib', 'python'))
    os.makedirs(os.path.join(vburrito_dir, 'bin'))
    cmd += ' firstrun'
shutil.copyfile('virtualenv-burrito/virtualenv-burrito.py', vburrito)
os.chmod(vburrito, 0755)
run(cmd)

# install the global venv
if not os.path.exists(venv_global):
    run('/bin/bash -c "source %s && mkvirtualenv global"' % \
            os.path.join(vburrito_dir, 'startup.sh'))
run(os.path.join(venv_global, 'bin', 'pip') + ' install -r requirements.txt')

# install the syntax-checkers venv
if not os.path.exists(venv_syntax_checkers):
    run('/bin/bash -c "source %s && mkvirtualenv syntax-checkers"' % \
            os.path.join(vburrito_dir, 'startup.sh'))
run(os.path.join(venv_syntax_checkers, 'bin', 'pip') + ' install -r syntax-checkers.txt')

# symlink all my dotfiles to my home directory
for f in os.listdir('.'):
    if not any(fnmatch.fnmatch(f, p) for p in exclude):
        path = os.path.join(home, f)
        if os.path.isfile(path) or os.path.islink(path):
            os.unlink(path)
        elif os.path.isdir(path):
            shutil.rmtree(path)
        print 'create link for %s' % (path)
        os.symlink(os.path.abspath(f), path)

# also symlink the dotfiles directory to '~/.dotfiles' if not already exist
if not os.path.exists(dotfiles_dir):
    print 'create link for %s' % (dotfiles_dir)
    os.symlink(os.path.abspath('.'), dotfiles_dir)
