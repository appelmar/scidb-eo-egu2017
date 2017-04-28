#!/bin/bash
# 1. start SciDB and other required services
echo -e "Starting system services (including SciDB, shim, and Rserve)..."
/opt/container_startup.sh >/dev/null

if [ -f /opt/in/studycase/run.R ]
  then
    # 2. run the actual analysis
    echo -e "Running R script /opt/in/run.R in container..."
    cd /opt/in/studycase &&  Rscript run.R
	echo -e "Finished R script."
fi
echo -e "The container will stop NOW."

