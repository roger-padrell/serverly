import os, strutils, unittest

var n: int = 0;

# Define the task that runs in a separate thread
proc add100() {.thread.} =
  while true:
    n = n + 100;
    sleep(100) # Sleep for 0.1 seconds (in milliseconds)
    echo "+ " & $n

test "Multithread Numbers":
  # Start the thread
  var testThread: Thread[void]
  createThread(testThread, add100)
  
  for i in 1..5:
    n = n - 2000
    sleep(2000) # Sleep for 2 seconds
    echo "- " & $n
  
  # Clean up
  assert n == 0;
  joinThread(testThread)
