#!/bin/bash

#sacct --format=jobid,user,NCPUS,Submit,Start,End,State,Elapsed,ElapsedRaw,account
sacct --format=jobid,JobName,Partition,NCPUS,Submit,Start,End,State,Elapsed
