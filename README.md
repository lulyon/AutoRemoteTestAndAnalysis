AutoRemoteTestAndAnalysis
=========================

为避免测试工具对测试集群造成干扰，测评工具把测试分析程序部署在本地的主机上，远程部署并集群上的程序，将测试结果传回本地进行分析。


一、安装
-------------------------

本地的机器支持任意Linux发行版，典型的如ubuntu和centos。
需要R语言及其中文环境的支持，所以需要安装R和Cairo库。因为需要SSH操作远程主机，所以需要配置SSH登录。


### 1. 安装R:
> Ubuntu：# apt-get install r-base

> CentOS: # yum install R

### 2. 安装Cairo
> Ubuntu：# apt-get install libcairo2-dev

> CentOS: # yum install cairo-devel

在命令行下输入R，进入R环境，输入
> >install.packages(‘Cairo’)

安装Cairo库。

3. 配置本地主机对集群主节点SSH无密码登录
首先在本地主机上生成公钥和私钥对
> $ ssh-keygen -t rsa

然后，用目标用户名和密码，将本地公钥拷贝到集群主节点的授权文件中。
> $ cat  ~/.ssh/id_rsa.pub | ssh hpgc@10.6.0.54 "cat - >> ~/.ssh/authorized_keys"

这样就可以实现本地主机无密码登录了。


二、配置文件
-------------------------
算法自动测试之前需要配置几个文件。

### 1. RemoteTest.config 
> \#! /bin/bash

> \# 远程主机用户名
> user=username

> \# 远程主机地址
> host=hostname

> \# 测试脚本远程目录
> remote_dir=/home/hpgc/dir


### 2. commandlines.txt
命令行参数文件，每行对应一个命令行，提供五个或五个以上的测试用例。
样例（读写文件）：
> mpiexec -n {kernel} {executable_path}/overlay -y intersect -t 0.0 -o {dataoutput_path}/1_{kernel}.shp -i {datainput_path}/ict_counties.shp -v {datainput_path}/area1.shp

其中，核数用{kernel}代替，执行文件路径用{executable_path}代替，输入目录用{datainput_path}代替，输出目录用{dataoutput_path}代替。输出结果文件名用_{kernel}扩展文件名，以避免不同核数的测试结果相互覆盖。

样例（读写数据库）：
> mpiexec -n {kernel} {executable_path}/overlay -y intersect -t 0.0 -O {dataoutput_path} -L 1_{kernel}  -I  {datainput_path} -A ict_counties -B area1

其中，核数用{kernel}代替，执行文件路径用{executable_path}代替，数据库输入目录用{datainput_path}代替，输出目录用{dataoutput_path}代替。输出表用_{kernel}扩展表名，以避免不同核数的测试结果相互覆盖。


### 3. config.ini 
> \#! /bin/bash

> \# MPI启用的最大进程数
> kernel_max=32

> \# 算法名称
> algorithm_name=overlay

> \# 测试用例数
> case_num=5

> \# 可执行文件的目录
> executable_path=/home/nfs/executable

> \# 输入数据的目录
> datainput_path=/home/nfs/data

> \# 输出数据的目录
> dataoutput_path=/home/nfs/outputdata

> \# 日志文件的目录
> log_path=/home/hpgc/dir/logdata

> \# 命令行文件的路径
> command_file=/home/hpgc/dir/commandlines.txt


### 4. arcgistimes.txt
每个用例在arcgis上的运行时间，每行一个。

### 5. weights.txt
每个用例对应的权重，每行一个，总和为1。



三、启动评测
-------------------------------
进入性能评测工具目录hpgcT，运行bash RunAllTests.sh开始评测。
> [luliang@Node4 hpgcT]$ bash RunAllTests.sh

在目录logdata下会自动生成一个测评报告report.html，使用浏览器或office打开报告进行查看。

在目录archive_logdata 里可查看结果示例。
