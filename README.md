# dac-master

Set default DAC, set master volume presets when headphone jack in or out.

> The script will automatic install `sox`,`udev` for you, if not don't have any.

### Prerequisites

You need these packages to be installed.

- udev
- sox

### Usage

**dac-master [--install|--sleep]**

```bash
$ dac-master --install
```

```text
  --install           Create a new master volume preset and set default DAC.
  --sleep             Put the preset on halt.
```

### Concept

I am an audiophiler and I bring my own portable rig to workplace everyday, each time I plug in the USB to use the external high-end Sabre 24bit DAC, most of the time, Ubuntu doesn't choose the right DAC as default.

I would also like to have master volume leveling down to 20-30% when the headphone jacked in, and the master volume return to last setting when the headphone jacked out or disconnected external DAC.
