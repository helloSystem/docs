# MIDI

Over a decade ago, someone [wrote](https://forums.freebsd.org/threads/alsa-midi-is-the-key-to-serious-musicproduction.22722/#post-158077) on the FreeBSD forum:

> The main problem with anything midi and jack (in fact anything more complex than using simple audio in or audio out) under FreeBSD, is that I haven't found out how to configure things. A complete writeup (for a non-musician) about how to configure a system which use jack would be nice.

This page describes how to use USB based hardware MIDI controllers (e.g., keyboards), with helloSystem and FreeBSD.

``` .. note::
    It is a work in progress. Please consider contributing additions and corrections.
```

## Using /dev/umidi*

Whenever a USB based hardware MIDI controller is plugged into the computer, a `/dev/umidi*` device node is created automatically.

### Testing

To test whether input from the MIDI controller arrives, run in a Terminal window:

```
midicat -d -q rmidi/0.0 -o /dev/null
```

As you play some notes on the MIDI controller, you should see MIDI messages appear on the screen. After verifying that this works, exit `midicat`.

Some applications can use `/dev/umidi*` device nodes directly. Some expect the device node to be at `/dev/midi` though, so you need to create a symlink there manually.

### Example application

For example, the `fluidsynth` command line tool, can use hardware MIDI controllers in this way directly:

```
sudo pkg install -y fluidsynth musescore
sudo ln -sf /dev/umidi*.0 /dev/midi
fluidsynth -m oss -a oss SoundFont.sf2
```

Unfortunately, not all applications on FreeBSD can use `/dev/umidi*` device nodes directly in this way. Hence there are other methods to access MIDI controllers. which one you need to use depends on what methods the application in question supports.

``` .. note::
    Applications cannot access /dev/umidi* directly while alsa-seq-server is running.
```

## Using OSS Raw-MIDI (Open Sound System)

Supposedly applications can use "OSS Raw-MIDI (Open Sound System)" to talk to MIDI controllers.

### Testing

Please let us know if you know how this works.

### Example application

The LMMS FreeBSD package offers "OSS Raw-MIDI (Open Sound System)" in the dropdown menu for the MIDI interface; however, it is not clear whether and how this works on FreeBSD. Please let us know if you know how this works.

## Using alsa-seq-server

Some applications can use `alsa-seq-server` to access MIDI controllers. For some applications, this support needs to be specifically enabled as a configuration option at compile time. 

In order for applications that use `alsa-seq-server` to talk to your MIDI controller, run

```
sudo pkg install alsa-seq-server alsa-utils
sudo alsa-seq-server -d /dev/umidi*
```

and then run the application.

``` .. note::
    alsa-seq-server was recently updated so that one can run it as a service which will automatically make all MIDI devices available without having to run one instance per MIDI device. The change should appear in FreeBSD packages (and thus in helloSystem) starting in Q2/2022.
```

### Testing

To test whether input from the MIDI controller arrives, run in a separate Terminal:

```
aseqdump -p 0
Waiting for data. Press Ctrl+C to end.
Source  Event                  Ch  Data
```

As you play some notes on the MIDI controller, you should see MIDI messages appear on the screen. After verifying that this works, exit `aseqdump`.

### Example application

An example application that can use `alsa-seq-server` to talk to MIDI controllers "out of the box" (without the need to recompile the application) is yet to be found in the FreeBSD Packages collection. Please let us know if you know one.

Recompiling LMMS from FreeBSD Ports with the following change regarding `WANT_ALSA`  in the `Makefile` allows one to use `alsa-seq-server` to talk to MIDI controllers:

```
CMAKE_OFF=      WANT_CALF WANT_CAPS WANT_CMT WANT_SWH WANT_STK \
                WANT_TAP WANT_VST
CMAKE_ON=       WANT_QT5 WANT_ALSA
```

Run `make clean ; make config ; make` to define which of the supported sound systems and MIDI interfaces will be available. LMMS can support the following MIDI interfaces on FreeBSD if it is configured accordingly at compile time: ALSA, OSS, Sndio, JACK. The ALSA one is known to work.

To use it, select "ALSA-Sequencer (Advanced Linux Sound Architecture)" from the MIDI interface dropdown menu in the MIDI pane of the LMMS settings, restart ALSA, click on the gear icon e.g., in the TripleOscillator track, and select MIDI -> Input -> 0:0 (name of your USB device).

If you see

```
ALSA lib seq_hw.c:466:(snd_seq_hw_open) open /dev/snd/seq failed: No such file or directory
cannot open sequencer: No such file or directory
```

when you start LMMS, then most likely `sudo alsa-seq-server -d /dev/umidi*` is not running (see above).

Note that depending on the application, using `alsa-seq-server` for the MIDI interface does not automatically mean that you have to use ALSA as the sound system (e.g., for the output of the generated sound). For example, if LMMS has been configured at compile time to support SDL (Simple DirectMedia Layer), you could use SDL rather than ALSA for the sound output.
