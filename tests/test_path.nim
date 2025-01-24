import os, serverly/utils/path, unittest

test "Use path with './'":
    assert readFile(parsePath("./config.nims")) == "switch(\"path\", \"$projectDir/../src\")"