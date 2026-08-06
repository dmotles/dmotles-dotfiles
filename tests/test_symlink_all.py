import importlib.util
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock


REPO_ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("symlink_all", REPO_ROOT / "symlink_all.py")
symlink_all = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(symlink_all)


class SymlinkAllTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        root = Path(self.temporary.name)
        self.home = root / "home"
        self.source = root / "source"
        self.home.mkdir()
        self.source.mkdir()
        (self.source / ".config").mkdir()
        (self.source / ".config" / "example").write_text("managed\n")
        self.home_patch = mock.patch.dict(os.environ, {"HOME": str(self.home)})
        self.source_patch = mock.patch.object(symlink_all, "SOURCE_DIR", self.source)
        self.home_patch.start()
        self.source_patch.start()

    def tearDown(self):
        self.source_patch.stop()
        self.home_patch.stop()
        self.temporary.cleanup()

    def test_repeated_linking_is_idempotent(self):
        symlink_all.link_files(noninteractive=True)
        target = self.home / ".config" / "example"
        self.assertTrue(target.is_symlink())
        self.assertEqual(target.resolve(), (self.source / ".config" / "example").resolve())

        symlink_all.link_files(noninteractive=True)
        self.assertEqual(target.resolve(), (self.source / ".config" / "example").resolve())
        self.assertFalse((self.home / ".dotfiles-backup").exists())

    def test_conflict_is_backed_up(self):
        target = self.home / ".config" / "example"
        target.parent.mkdir(parents=True)
        target.write_text("personal\n")

        symlink_all.link_files(noninteractive=True)

        backups = list((self.home / ".dotfiles-backup").rglob("example"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(), "personal\n")
        self.assertTrue(target.is_symlink())

    def test_interactive_keep_preserves_conflict(self):
        target = self.home / ".config" / "example"
        target.parent.mkdir(parents=True)
        target.write_text("personal\n")

        with mock.patch("builtins.input", return_value="k"):
            symlink_all.link_files(noninteractive=False)

        self.assertFalse(target.is_symlink())
        self.assertEqual(target.read_text(), "personal\n")


if __name__ == "__main__":
    unittest.main()
