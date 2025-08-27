# WattMaster

![WattMaster Header](assets/imgs/readme_header.png)

WattMaster is a tweak for the Wattpad iOS app that enhances the user experience by providing quality-of-life improvements and unlocking hidden developer features.

## Features

- **Ad-Free Experience**: Disable all ads, including interstitials, story details ads, library ads, and more.
- **Premium Mocking**: Mock Wattpad Premium to access premium features.
- **Developer Tools**:
    - Enable debugging overlays for ads and story information.
    - Option to use the staging server for testing.
    - Mock interstitial responses and sponsored content.
- **Easy Configuration**: A dedicated settings panel accessible via a 2-finger long press gesture.

## Compatibility

- **Wattpad Version**: Tested and working with v10.92.0.
- **Jailbreaks**: Supports rootless and roothide jailbreaks.

## Installation

### From Release

If you don't want to build the package yourself, you can download the latest `.deb` file from the [Releases](https://github.com/kunihir0/WattMaster/releases) page.

### Manual Build

To build the packages manually, you will need to have [Theos](https://theos.dev/) installed.

The build process depends on your jailbreak type (rootless or roothide).

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/kunihir0/WattMaster.git
    cd WattMaster
    ```

2.  **Build for rootless jailbreak:**
    ```bash
    make package THEOS_PACKAGE_SCHEME=rootless
    ```

3.  **Build for roothide jailbreak:**
    ```bash
    make package THEOS_PACKAGE_SCHEME=roothide
    ```

The compiled `.deb` package will be located in the `packages` directory.