import os
import sys
import vim
from importlib import import_module
from collections import namedtuple
import inspect


def vim_get_file():
    import vim
    modulename = vim.eval('expand("<cfile>")')
    curdir = vim.eval('expand("%:p:h")')
    sys.path.insert(0, curdir)
    try:
        fname = _find_filename(modulename)
        if fname:
            vim.command('return "{}"'.format(fname))
    except ImportError as import_err:
        sys.stderr.write(
            'E345: Can not goto "{}": {}\n'.format(modulename, import_err)
        )
        vim.command('return "{}"'.format(modulename))
    except AttributeError as attr_err:
        sys.stderr.write(
            'E447: Can not goto "{}": {}\n'.format(modulename, attr_err)
        )
        vim.command('return "{}"'.format(modulename))
    except TypeError as type_err:
        sys.stderr.write(
            'E345: Can not goto "{}": built-in module. {}\n'.format(modulename, type_err)
        )
        vim.command('return "{}"'.format(modulename))
    finally:
        sys.path.remove(curdir)


def _try_import_module(importpath):
    """
    :param str importpath: name to lookup
    :returns: module, substring of importpath that imported
    :rtype: 2-tuple
    """
    while importpath:
        try:
            return import_module(importpath), importpath
        except ImportError:
            importpath, _, __ = importpath.rpartition('.')
            if not importpath:
                raise


def _find_filename(importpath):
    module, modulepath = _try_import_module(importpath)
    if len(modulepath) < len(importpath):
        subpath = importpath[len(modulepath)+1:]
        for subobj in subpath.split('.'):
            obj = getattr(module, subobj)
        return inspect.getsourcefile(obj)
    return inspect.getsourcefile(module)
