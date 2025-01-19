import unittest
import serverly/statusLib

test "Status codes and messages":
    assert status.OK == 200
    assert statusMessage.get(200) == "OK"