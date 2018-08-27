# dac-master

Set default DAC, set master volume presets when headphone jack in or out.

> The script will automatic install `sox`,`udev` for you, if not don't have any.

### Prerequisites

You need these packages to be installed.

- udev
- sox

### Install

To install the `dac-master`, run this command:

```bash
$ sudo ./setup.sh --install
```

To remove the `dac-master`, run this command without the **sudo**:

```bash
$ ./setup.sh --remove
```

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

---

MIT License

Copyright (c) 2018 Loouis Low

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
