# Tracing with DTrace/dtruss

The `dtruss` command line tool can be used to examine what a running process is doing. Other than, e.g., `strace` on Linux, `dtruss` can be used to watch already-running processes. This makes it more suitable to watch processes that have been launched by, e.g., the `launch` command.

```
sudo pkg install dtrace-toolkit
sudo kldload dtraceall
launch FeatherPad
# In another terminal: ps ax | grep featherpad
# Then use the PID of the featherpad process for the next command:
sudo dtruss -p 1886 -f
```


``` .. note::
    If you get `probe description syscall:::entry does not match any probes`, then possibly you loaded `kldload dtrace` rather than `kldload dtraceall`.
```

The [FreeBSD DTrace Tutorial](https://wiki.freebsd.org/DTrace/Tutorial) has many one-liner examples for tasks like observing
* File Opens
* Syscall Counts By Process
* Distribution of read() Bytes
* Timing read() Syscall
* Measuring CPU Time in read()
* Count Process-Level Events
* Profile On-CPU Kernel Stacks
* Scheduler Tracing
* TCP Inbound Connections
* Raw Kernel Tracing

There is also a full list of [DTrace One-Liners](https://wiki.freebsd.org/DTrace/One-Liners) to pick up more DTrace functionality.

``` .. note::
    In the future a graphical utility might be written to automate common tracing tasks.
```
