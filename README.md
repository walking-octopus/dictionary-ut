<img height="128" src="./assets/logo.svg" align="left"/>

# Dictionary

A beautiful Ubuntu Touch app to quickly lookup a word on Wikitionary.
_________________________________

<img src="https://open-store.io/screenshots/dict.walking-octopus-screenshot-bb9e937d-940e-4cf1-8545-feb6c34495fd.jpeg" alt="Screenshot" width="200" />

## Features:
 - Minimalist, slick design: A modern convergent design, focused on readability and simplicity.
 - Forever free: The entire app is free and open-source, forever.
 - Native UI: This isn't a crappy web app! It means you get a fast, reliable, and consistent experience.
 - Powered by Wiktionary: Always up-to-date, crowdsourced, privacy-respecting, and comprehensive.

> Note: Due to Wikitionary's `define` API being currently only implemented in the English version, all the definitions are in English. However, every Wiktionary aims to define every word of every language, so you will get multilingual definitions, just in English. 
## Building

### Dependencies
- Docker
- Android tools (for adb)
- Python3 / pip3
- Clickable (get it from [here](https://clickable-ut.dev/en/latest/index.html))

Use Clickable to build and build it as Click package ready to be installed on Ubuntu Touch

### Build instructions
Make sure you clone the project with
`git clone https://github.com/walking-octopus/dictionary-ut.git`.

To test the build on your workstation:
```
$  clickable desktop
```

To run on a device over SSH:
```
$  clickable --ssh [device IP address]
```

For more information on the several options see the Clickable [documentation](https://clickable-ut.dev/en/latest/index.html)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

### Translations
Please help our translation efforts by following [these instructions](https://github.com/walking-octopus/dictionary-ut/tree/main/po/README.md).

## License
 - The project is licensed under the [GPL-3.0](https://opensource.org/licenses/GPL-3.0).
 - The definitions provided by Wikitionary are govered Creative Commons Attribution-ShareAlike or GNU Free Documentation License, more information [here](https://en.wikipedia.org/wiki/Wikipedia:Reusing_Wikipedia_content).
