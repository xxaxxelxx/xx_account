# Liquidsoap for use with Docker


[xxaxxelxx/xx_account](https://index.docker.io/u/xxaxxelxx/xx_account/)

## Synopsis
This repo is the base for an [automated docker build](https://hub.docker.com/r/xxaxxelxx/xx_account/) and is part of a dockerized streaming framwork consisting of following elements:
* [xxaxxelxx/xx_account](https://github.com/xxaxxelxx/xx_account)
* [xxaxxelxx/xx_bridgehead](https://github.com/xxaxxelxx/xx_bridgehead)
* [xxaxxelxx/xx_coverter](https://github.com/xxaxxelxx/xx_converter)
* [xxaxxelxx/xx_customerweb](https://github.com/xxaxxelxx/xx_customerweb)
* [xxaxxelxx/xx_geograph](https://github.com/xxaxxelxx/xx_geograph)
* [xxaxxelxx/xx_icecast](https://github.com/xxaxxelxx/xx_icecast)
* [xxaxxelxx/xx_liquidsoap](https://github.com/xxaxxelxx/xx_liquidsoap)
* [xxaxxelxx/xx_loadbalancer](https://github.com/xxaxxelxx/xx_loadbalancer)
* [xxaxxelxx/xx_logsplitter](https://github.com/xxaxxelxx/xx_logsplitter)
* [xxaxxelxx/xx_pulse](https://github.com/xxaxxelxx/xx_pulse)
* [xxaxxelxx/xx_reflector](https://github.com/xxaxxelxx/xx_reflector)
* [xxaxxelxx/xx_rrdcollect](https://github.com/xxaxxelxx/xx_rrdcollect)
* [xxaxxelxx/xx_rrdgraph](https://github.com/xxaxxelxx/xx_rrdgraph)
* [xxaxxelxx/xx_sshdepot](https://github.com/xxaxxelxx/xx_sshdepot)
* [xxaxxelxx/xx_sshsatellite](https://github.com/xxaxxelxx/xx_sshsatellite)

The running docker container provides a service for very special streaming purposes usable for a distributed architecture.
It presumably will not fit for you, but it is possible to tune it. If you need some additional information, please do not hesitate to ask.

This [xxaxxelxx/xx_account](https://hub.docker.com/r/xxaxxelxx/xx_account/) repo is an essential part of a complex compound used for streaming.
It's main purpose is customer accounting based on streamed bytes, scaled prices are possible. It works either in retroactive (lower prices on higher data amounts affect all the used data volume) or not.

## Usage

### Example
```bash
$ docker run -d --name account_CUSTOMER_ID --volumes-from sshdepot --restart=always xxaxxelxx/xx_account CUSTOMER_ID 0#0.07+10000#0.064+25000#0.056+50000#0.045+100000#0.036+250000#0.028+500000#0.022 retroactive
```
***

## License

[MIT](https://github.com/xxaxxelxx/xx_Liquidsoap/blob/master/LICENSE.md)
