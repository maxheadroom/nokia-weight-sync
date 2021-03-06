# nokia-weight-sync
Get weight from Nokia Health and update to Garmin Connect or Smashrun.

![nokia-weight-sync-logo](logo.png)

## Installation

1. Download / clone the repository.

2. Satisfy the following requirements:

    - Python 3.X
    - Python libraries: arrow, requests, requests-oauthlib

3. [Register](https://account.withings.com/partner/add_oauth2) an application with Nokia Health and obtain a consumer key and secret.
    1. logo: the requirements are quite strict, [feel free to use this one](https://github.com/magnific0/nokia-weight-sync/blob/master/logo256w.png)
    1. callback: you can pick anything, but if you want to do the automated authorization (you will be prompted for this), you need to pick the hostname/ip and port carefully. For example http://localhost:8087.
        - localhost: if you run nokia-weight-sync and do the authorization in the browser on the same device. This needs to be replaced by local or public ip/hostname if you run it on a server.
        - 8087: a port that is likely not used by other services. For a remote setup make sure the port is not firewalled.
        - http: https is available, but requires additional setup of certificates. For localhost http is fine.

## Usage

1. On first run you need to set-up your Nokia Health consumer key and secret:

        ./nokia-weight-sync.py -k CONSUMER_KEY -s CONSUMER_SECRET setup nokia

2. Follow the instructions on the screen and verify the application.

3. Register one or more destination services:

    - **Garmin Connect:** register your Garmin Connect credentials and sync your last measurement (provide GC password when asked):

            ./nokia-weight-sync.py -k user@example.com setup garmin

    - **Smashrun (implicit flow, recommended):** for user level authentication simply copy the access token (no registration, no refresh after expiry):

            ./nokia-weight-sync.py setup smashrun

    - **Smashrun (code flow):** register Smashrun API application keys and follow the authorization process to obtain your users refresh_token ([registration required](https://api.smashrun.com/register), refresh after expiry):

            ./nokia-weight-sync.py -k CLIENT_ID -s CLIENT_SECRET setup smashrun_code

4. Verify that the relevant sections for the services are added to ```config.ini```.

5. Synchronize (new) measurements:

        ./nokia-weight-sync.py sync garmin
        ./nokia-weight-sync.py sync smashrun

**Important** Nokia Health API, Smashrun API, and Garmin Connect credentials are stored in ```config.ini```. If this file is compromised your Garmin Connect account, personal health data from Nokia Health, and activity data from Smashrun are at risk.



## Docker Container Usage
The Dockfile contains instructions to build a Docker container with this code which you can run on any host without worrying about the Python an Pip dependencies.

### building the Container

Run the docker build command, assuming you're in the root of your working copy of this repo.


```
docker build -t <desiredcontainername> .
```


### 1st Setup  to generate the config.ini

Start the container with an interactive shell

```
docker run --rm -ti --user `id -u`:`id -g` -p9090:9090 -v $PWD:/opt --entrypoint /bin/bash desiredcontainername 
```

Follow the setup instructions from above. This will generate the config.ini in the /build directory of the container.
Copy the config.ini to the mounted /opt directory:

```
I have no name!@81cb3fe1890e:/build$cp /build/config.ini /opt/
```

### using the Container

once the setup is done and a config.ini exists the Container can be called to sync the data between Withings and the target service. The default is to sync with Garmin.

```
docker run -ti --user `id -u`:`id -g` -v $PWD/config.ini:/build/config.ini desiredcontainername

Last measurement was already synced
Config file saved to config.ini
```

Please not that the config.ini is written to during the sync. So it must be writeable to the user inside the container.

## Advanced

See ```./nokia-weight-sync.py --help``` for more information.

## Notice

nokia-weight-sync includes components the following open-source projects:

* ```fit.py``` from [ikasamah/withings-garmin](https://github.com/ikasamah/withings-garmin), MIT License (c) 2013 Masayuki Hamasaki, adapted for Python 3.
* ```garmin.py``` from [jaroslawhartman/withings-garmin-v2](https://github.com/jaroslawhartman/withings-garmin-v2), MIT License (c) 2013 Masayuki Hamasaki, adapted for Python 3.
* ```nokia.py``` from [python-nokia](https://github.com/orcasgit/python-nokia), MIT License (c) 2012 Maxime Bouroumeau-Fuseau, 2017 ORCAS, unmodified.
* ```sessioncache.py``` from [cpfair/tapiriik](https://github.com/cpfair/tapiriik/blob/187d1b97ce73cc35b5e2194eb4631ceff20499e3/tapiriik/services/sessioncache.py), Apache License 2.0, unmodified.
* ```smashrun.py``` from [campbellr/smashrun-client](https://github.com/campbellr/smashrun-client), Apache License 2.0, several fixes.

## Support

Please [open an issue](https://github.com/magnific0/nokia-weight-sync/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/magnific0/nokia-weight-sync/compare/).
