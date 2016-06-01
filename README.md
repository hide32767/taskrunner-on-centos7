# Task Runner of AWS Data Pipeline on CentOS7

## require

- To be several packages installed.
 - `Ansible`
 - `Serverspec`
 - `ansible_spec`
- To set login configuration to `~/.ssh/config` for servers.

## first

You should rewrite several parameters in `group_vars/all` , to your parameters.

## test

```
$ rake -T    # show available targets
$ rake serverspec:datapipeline_task_runner
```

## provision

```
$ ansible-playbook -i hosts site.yml
```

## remarks

`taskrunner.service` is started by a command, like this;

```
java -jar TaskRunner.jar --config config.json
```

This `java` process received `SIGTERM` , but it is 'NOT' terminated.
Because, I wrote `ExecStop=/bin/kill -s KILL ${MAINPID}` in the unitfile, `taskrunner.service`.
