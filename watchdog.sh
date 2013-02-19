#!/bin/bash
###########################################################################################################
# Description : This script acts as a watchdog to run time sensitive scripts.
#               The first SIGUSR1 from the monitored process will start the timer.
#               if a subsequent SIGUSR1 is not recieved within the timeout period, the watchdog and
#               monitored process will be killed mercilessly. . .
# author  : Vysakh P Pillai
# contact : vysakhpillai@gmail.com
###########################################################################################################

#Alarm subroutinr
function alarm()
{
    sleep $TIMEOUT;
    kill -SIGALRM $PARENTPID;

}

#Alarm Trap
function trapALRM()
{
    echo "alarm recieved. Suicide vest. . . .";
    kill 0;
}

#SIGUSR1 trap
function trapSIGUSR1()
{
   trap trapALRM ALRM
   if [ $ALARMPID != 0 ]
   then
        kill -9 $ALARMPID;
   else
        echo "got initial trigger";
   fi

   alarm &
   ALARMPID=$!;

   echo "Alarm reset";
}

#Cleanup trap
function cleanup()
{
    #kill everything in the same process group;
    kill 0;
}

#-------------------------------------------------------------------------------------------------------------------------#
#initial values
PARENTPID=$$;
TIMEOUT=$2;
ALARMPID=0;
CHILDPID=0;
retval=255;

#cleanup on exit;

if [ $# != 2 ];
then
    echo "usage: $(basename $0) <kid_to_watch> <max_time-out>"
else
   $1 &
   CHILDPID=$!;
   trap trapSIGUSR1 USR1    # install all traps after the child is spawned so taht they wont be inherrited.
   trap cleanup EXIT

#when a trap is recieved, wait exits with a return value greater than 128. so we will understand
#that we are out of wait since a trap was executed. Thus, wait till a proper exit from client.
   until [ $retval -lt "128" ]
   do
       wait $CHILDPID;
       retval=$?;
   done
   exit 0;
fi
