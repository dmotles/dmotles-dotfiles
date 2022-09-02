#!/usr/bin/env python
"""
Installs dotfiles located in src/
"""
from __future__ import print_function, absolute_import
import os
import logging
import tempfile
import errno

LOG = logging.getLogger(__name__)

def link_files():
    homedir = os.path.expanduser('~')
    for root, _, files in os.walk('src'):
        pkg_subdir = os.path.relpath(root, 'src')
        home_subdir = os.path.join(homedir, pkg_subdir)
        if not os.path.isdir(home_subdir):
            LOG.error('No such dir: %s', home_subdir)
            if input('Create {} [y/n]?'
                         ''.format(home_subdir)).lower().startswith('y'):
                os.makedirs(home_subdir)
        if os.path.isdir(home_subdir):
            for file_ in files:
                file_tgt_path = os.path.normpath(
                    os.path.join(home_subdir, file_))
                file_src_path = os.path.normpath(os.path.join(root, file_))
                LOG.info('Linking %s -> %s', file_src_path, file_tgt_path)
                link(file_src_path, file_tgt_path)


def is_same_file(orig_file, symlink):
    fullpath = os.path.abspath(orig_file)
    symlink_abs = os.path.abspath(symlink)
    symlink_actual = os.path.realpath(symlink_abs)
    if os.path.samefile(fullpath, symlink_actual):
        LOG.info('%s is already pointing at %s', symlink, fullpath)
        return True
    LOG.warn('%s exists and is pointing at %s.', symlink, symlink_actual)
    return False


def link(src, tgt):
    src_real = os.path.abspath(src)
    if os.path.islink(tgt):
        try:
            if is_same_file(src, tgt):
                return
            else:
                LOG.warn('Attempting to backup..')
                move_to_backup(tgt)
        except OSError as oserr:
            if oserr.errno == errno.ENOENT:
                LOG.warn('It appears %s did not point at anything legit', tgt)
                os.unlink(tgt)
            else:
                raise oserr
    elif os.path.isfile(tgt) or os.path.isdir(tgt):
        LOG.warn('%s already exists... attempting to move out of the way...',
                 tgt)
        move_to_backup(tgt)
    os.symlink(src_real, tgt)


def move_to_backup(_path):
    opt = 'XXXXX'
    while opt.lower()[0] not in 'krd':
        print('[K]eep, [R]ename, or [D]elete {}?'.format(_path))
        opt = input()
        if not opt:
            opt = 'XXXX'

    opt = opt.lower()[0]
    if opt == 'k':
        return False
    if opt == 'r':
        yes = 'no'
        new_path = _path
        while not yes.lower().startswith('y'):
            print('Renane/move to what path?')
            new_path = input()
            new_path = os.path.normalize(os.path.expanduser(new_path))
            print('Move {} to {} [y/n]?'.format(_path, new_path))
            yes = input()
        os.rename(_path, new_path)
    if opt == 'd':
        os.unlink(_path)
    return True

def main():
    logging.basicConfig(level=logging.DEBUG)
    link_files()

if __name__ == '__main__':
    main()
