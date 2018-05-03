from __future__ import with_statement
from fabric.api import *
from fabric.colors import red, green
from fabric.contrib.console import confirm

host192 = 'root@192.168.0.103:22'

env.passwords = {
    host192: "iloveyou"
}

env.roledefs = {
    'tomcat_user': [host192],
}

@task
@serial
@runs_once
@roles('tomcat_user')
@with_settings(warn_only=True)
def build_tomcat_cluster(count=3):

    run('mkdir -p /srv/tomcat-cluster')

    with cd('/srv/tomcat-cluster'):
        run('cp -a ~/Documents/git-repository/temp-script/tomcat/build_instance.sh .')
        result = run('./build_instance.sh %d' % count)
    if result.failed:
        print red('bulid tomcat cluster error')
        abort('sorry, check /srv/tomcat-cluster please')

    i = 1
    while i <= count:
        with cd('/srv/tomcat-cluster/tomcat-%d' % i):
            result = run('cp -a ~/Documents/git-repository/temp-script/tomcat/manage_instance.sh .')
            i= i + 1
        if result.failed and not confirm('bulid tomcat %d error, Continue anyway?' % i):
            abort('sorry, check /srv/tomcat-cluster/tomcat-%d please~' % i)

    print green('bulid tomcat cluster success')

@task
@serial
@runs_once
@roles('tomcat_user')
def deploy_tomcat_webapps():
    with cd('/srv'):
        run('ln -s /opt/apache-tomcat/webapps tomcat-webapps')
        print green('deploy tomcat webapps success')

@task
@serial
@roles('tomcat_user')
@with_settings(warn_only=True)
def start_tomcat_cluster(count=3):
    i = 1
    while i <= count:
        result = run('/srv/tomcat-cluster/tomcat-%d/manage_instance.sh start' % i, pty=False)
        i = i + 1
        if result.failed and not confirm('start tomcat %d error, Continue anyway?' % i):
            abort('sorry, run "ps aux | grep java" please')

@task
@serial
@roles('tomcat_user')
@with_settings(warn_only=True)
def stop_tomcat_cluster(count=3):
    i = 1
    while i <= count:
        result = run('/srv/tomcat-cluster/tomcat-%d/manage_instance.sh stop' % i, pty=False)
        i = i + 1
        if result.failed and not confirm('stop tomcat %d error, Continue anyway?' % i):
            abort('sorry, run "ss -alutpn | column -t | grep java" please')