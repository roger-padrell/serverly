import os, serverly/utils/path, unittest

test "Use path with './'":
    assert readFile(path("./config.nims")) == "switch(\"path\", \"$projectDir/../src\")"