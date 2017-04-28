# scidb-eo:egu2017 
A Docker image [SciDB] to run reproducible land use change detection with SciDB(http://www.paradigm4.com/) and [R](https://www.r-project.org/)

---

This Docker image demonstrates how to run Earth observation (EO) analytics with [SciDB](http://www.paradigm4.com/) (15.7), its extensions [scidb4geo](https://github.com/appelmar/scidb4geo) and  [scidb4gdal](https://github.com/appelmar/scidb4gdal), and [GDAL](http://gdal.org/) (2.1.0). It includes:

* scripts, code, and a `Dockerfile` to create a Docker image with all required software

* R scripts and small datasets to run a study cases on land use change monitoring with Landsat NDVI time series.

To run the study cases, you have to build the Docker image first and run a container with attached data and script afterwards. The sections below provide copyable commands to get started.  


## Prerequisites
- [Docker Engine](https://www.docker.com/products/docker-engine) (>1.10.0) 
- Around 10 GBs free disk space 
- Internet connection to download software and dependencies


## Getting started

_**Note**: Depending on your Docker configuration, the following commands must be executed with sudo rights._

### 1. Build the Docker image (1-2 hours)

The provided Docker image is based on a minimally sized Ubuntu OS. Among others, it includes the compilation and installation of [SciDB](http://www.paradigm4.com/), [GDAL](http://gdal.org/), SciDB extensions ([scidb4geo](https://github.com/appelmar/scidb4geo),  [scidb4gdal](https://github.com/appelmar/scidb4gdal)) and the installation of all dependencies. The image will take around 15 GBs of disk space. It can be created by executing:

```
git clone https://github.com/appelmar/scidb-eo-egudemo.git && cd scidb-eo-egudemo
docker build --tag="scidb-eo:egu2017demo" . # don't miss the dot
``` 

_Note that by default, this includes a rather careful SciDB configuration with relatively little demand for main memory. You may modify `conf/scidb_docker.ini` if you have a powerful machine._


### 2. Start a container to run the study case (30-60 minutes)

To reproduce the analysis, you need to run a Docker container and mount data and R code to the container's files system at `/opt/in/`. The file `/opt/in/studycase/run.R` is automatically called if you start the container with the provided `run.sh` script. The commands below can be used to run the provided study case.

```
docker run --name="scidbeo-egu2017demo" --rm -h "scidbeo-egu2017demo" -v $PWD:/opt/in scidb-eo:egu2017demo
```



### 3. Check the results

Once the analysis has been finished, you should see a generated result report / figure as new file `changes.png`.


### 4. Clean up
To clean up your system, you can remove containers and the image with

1. `docker rm scidbeo-egu2017demo` (only needed if container didn't run with `--rm`), and 
2. `docker rmi scidb-eo:egu2017demo` .

	
## Study case details

This study case works on a small region covering 10x10 km in the southwest of Ethiopia. For this region, post-processed NDVI imagery captured by Landsat 7 between 2003-07-21 and 2014-12-27 has been downloaded from [espa.cr.usgs.gov](http://espa.cr.usgs.gov/). The resulting imagery (see `studycases/LANDSAT-BFAST/data`) has been cropped by GDAL.   

The analysis with R (see `studycases/LANDSAT-BFAST/run.R`) includes the following steps:

1. Load the data as a three-dimensional array to SciDB
2. Omit invalid NDVI values (< -1 or > 1) and reshape the array such that chunks contain complete time series
3. Run change monitoring from the [bfast R package](http://bfast.r-forge.r-project.org)[1] where the monitoring period starts with 2010.
4. Download the results and generate a simple change figure.



## License
This Docker image contains source code of SciDB in install/scidb-15.7.0.9267.tgz. SciDB is copyright (C) 2008-2016 SciDB, Inc. and licensed under the AFFERO GNU General Public License as published by the Free Software Foundation. You should have received a copy of the AFFERO GNU General Public License. If not, see <http://www.gnu.org/licenses/agpl-3.0.html>

License of this Docker image can be found in the `LICENSE`file.



## Notes
This Docker image is for demonstration purposes only. Building the image includes both compiling software from sources and installing binaries. Some installations require downloading files which are not provided within this image (e.g. GDAL source code). If these links are not available or URLs become invalid, the build procedure might fail. Furthermore, since these downloads mostly install most recent versions of the libraries, potential incompatibilities or API changes in future versions may make this image build fail. Please feel free to report any issues to the author. 


## Known issues

1. When Docker runs in a virtual machine, the connection from R to shim sometimes fails with errors in `curl_fetch_memory`. As a workaround, running SciDB commands will be retried up to 8 times with `Sys.sleep` between individual attempts. If the connection still fails, the container will stop and shut down. 


----

## Author

Marius Appel  <marius.appel@uni-muenster.de>
