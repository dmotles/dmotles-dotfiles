#!/usr/bin/env python3
"""Link the repository's src tree into the current user's home directory."""

import argparse
import fcntl
import logging
import os
import shutil
import tempfile
from datetime import datetime, timezone
from pathlib import Path


LOG = logging.getLogger(__name__)
ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT / "src"


def parse_args():
    parser = argparse.ArgumentParser(description="Symlink dotfiles into HOME")
    parser.add_argument(
        "--non-interactive",
        "-y",
        action="store_true",
        help="Back up conflicts without prompting",
    )
    return parser.parse_args()


def is_noninteractive(args):
    return args.non_interactive or any(
        (
            os.environ.get("CODER") == "true",
            os.environ.get("CODESPACES") == "true",
            os.environ.get("DOTFILES_NONINTERACTIVE") == "1",
        )
    )


def unique_backup_path(path, home):
    relative = path.relative_to(home)
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    candidate = home / ".dotfiles-backup" / timestamp / relative
    counter = 1
    while candidate.exists() or candidate.is_symlink():
        candidate = home / ".dotfiles-backup" / f"{timestamp}-{counter}" / relative
        counter += 1
    return candidate


def backup(path, home):
    destination = unique_backup_path(path, home)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(path), str(destination))
    LOG.info("Backed up %s to %s", path, destination)


def resolve_conflict(path, home, noninteractive):
    if noninteractive:
        if path.is_symlink() and not path.exists():
            LOG.info("Removing broken symlink %s", path)
            path.unlink()
        else:
            backup(path, home)
        return True

    while True:
        choice = input(f"[K]eep, [B]ack up, or [D]elete {path}? ").lower()[:1]
        if choice == "k":
            return False
        if choice == "b":
            backup(path, home)
            return True
        if choice == "d":
            if path.is_dir() and not path.is_symlink():
                shutil.rmtree(path)
            else:
                path.unlink()
            return True


def link(source, target, home, noninteractive):
    if target.is_symlink():
        if target.resolve(strict=False) == source.resolve():
            LOG.info("%s already points to %s", target, source)
            return
        if not resolve_conflict(target, home, noninteractive):
            return
    elif target.exists():
        if not resolve_conflict(target, home, noninteractive):
            return

    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.with_name(f".{target.name}.dotfiles-{os.getpid()}")
    temporary.unlink(missing_ok=True)
    temporary.symlink_to(source)
    os.replace(temporary, target)
    LOG.info("Linked %s -> %s", target, source)


def link_files(noninteractive=False):
    if not SOURCE_DIR.is_dir():
        raise RuntimeError(f"Missing dotfiles source directory: {SOURCE_DIR}")

    home = Path.home().resolve()
    sources = sorted(path for path in SOURCE_DIR.rglob("*") if path.is_file())
    if not sources:
        raise RuntimeError(f"No dotfiles found beneath {SOURCE_DIR}")

    lock_path = Path(tempfile.gettempdir()) / f"dmotles-dotfiles-link-{os.getuid()}.lock"
    with lock_path.open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        for source in sources:
            target = home / source.relative_to(SOURCE_DIR)
            link(source, target, home, noninteractive)


def main():
    logging.basicConfig(level=logging.INFO)
    args = parse_args()
    link_files(is_noninteractive(args))


if __name__ == "__main__":
    main()
