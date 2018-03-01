# Distroless + Monotonic Repro

🕔 Repro for a monotonic "no suitable implementation for this system" issue when using distroless

## Running

First run `docker build -t repro .` in the root of this repository.

Then run `docker run --rm repro` to see the following error:

```
Traceback (most recent call last):
  File "<string>", line 1, in <module>
  File "/usr/lib/python2.7/monotonic.py", line 169, in <module>
    raise RuntimeError('no suitable implementation for this system: ' + repr(e))
RuntimeError: no suitable implementation for this system: OSError(2, 'No such file or directory')
```

## Observations

While debugging, I removed the outer `try`/`except` layer, and saw a (slightly better) exception:

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/lib/python2.7/monotonic.py", line 137, in <module>
    clock_gettime = ctypes.CDLL(ctypes.util.find_library('rt'),
  File "/usr/lib/python2.7/ctypes/util.py", line 285, in find_library
    return _findSoname_ldconfig(name) or _get_soname(_findLib_gcc(name))
  File "/usr/lib/python2.7/ctypes/util.py", line 103, in _findLib_gcc
    stdout=subprocess.PIPE)
  File "/usr/lib/python2.7/subprocess.py", line 390, in __init__
    errread, errwrite)
  File "/usr/lib/python2.7/subprocess.py", line 1024, in _execute_child
    raise child_exception
OSError: [Errno 2] No such file or directory
```

So (assuming I'm reading this correctly) it appears that it's attempting to locate `librt` and failing. This is not very surprising, given the minimal nature of the `distroless` images.
