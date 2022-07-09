# lilafestivalapp

Generic festival app with specific festivals as flavors:

* [Party.San Open Air](https://www.party-san.de)
* [Spirit Festival](https://www.spirit-festival.com)

## Setup

### Environment

Place `.env` file in the root directory.
<!-- TODO(SF) BUILD release mention signing keys -->

### Generate app icons for all flavors

```bash
flutter pub run flutter_launcher_icons:main
```

## Run development version

Run in the app for a specific festival in development mode as follows:

```bash
./scripts/run_dev.sh --flavor=[spirit|party_san] [--year=<YEAR>] [--build=<BUILD>] [--release]
# or
./scripts/run_dev.sh -f=[spirit|party_san] [-y=<YEAR>] [-b=<BUILD>] [-r]
# e.g.
./scripts/run_dev.sh -f=spirit -y=2019 --release
```

* `--flavor/-f` is required to specify the festival
* `--year/-y` is needed to prepare the asset folder and download the correct data for the given year. This is required on the first build and between flavor switches.
* `--build/-b` defaults to `dev` if omitted
* `--release` runs the app in release mode

## Build production version

Build the production apk for a specific festival as follows:

```bash
./scripts/build_prod.sh [spirit|party_san] [<YEAR>]
# e.g.
./scripts/build_prod.sh spirit 2019
./scripts/build_prod.sh party_san
```

* The second parameter is optional and used to prepare the asset folder and download the correct data for the given year. This is required on the first build and between flavor switches.

## Prepare assets only

Prepare the assets for a specific festival as follows:

```bash
./scripts/prepare_assets.sh [spirit|party_san] <YEAR>
# e.g.
./scripts/prepare_assets.sh party_san 2019
```

* The second parameter is required and used to prepare the asset folder and download the correct data for the given year.

There is also a helper script to switch to the newest version of a festivals:

```bash
./scripts/switch.sh [spirit|party_san]
# e.g.
./scripts/switch.sh party_san
```

* This script should be updated as soon as a new year is available for a festival.
