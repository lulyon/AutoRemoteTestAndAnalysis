#! /bin/bash

declare user
declare host
declare remote_dir

# user=caolei
# host=node5
# remote_dir=/home/caolei/luliang/overlay
source 'RemoteTest.config'

echo "Begin remote test."
echo "mkdir $remote_dir in remote host $host"
ssh `echo $user`@`echo $host` "mkdir -p `echo $remote_dir`"
echo "copy commandlines.txt to $remote_dir on remote host $host"
scp commandlines.txt `echo $user`@`echo $host`:`echo $remote_dir`

echo "copy config.ini to $remote_dir on remote host $host"
scp config.ini `echo $user`@`echo $host`:`echo $remote_dir`

echo "copy RunAlgorithmCase.sh to $remote_dir on remote host $host"
scp RunAlgorithmCase.sh `echo $user`@`echo $host`:`echo $remote_dir`

echo "Run Algorithm Test on remote host $host"
ssh `echo $user`@`echo $host`  "cd `echo $remote_dir`; source "~/.bashrc"; source "~/.bash_profile"; bash RunAlgorithmCase.sh; rm commandlines.txt config.ini RunAlgorithmCase.sh"

echo "copy remote log $host:$remote_dir/logdata.tar to local host"
scp `echo $user`@`echo $host`:`echo $remote_dir`/logdata.tar .

echo "Remote test done"

