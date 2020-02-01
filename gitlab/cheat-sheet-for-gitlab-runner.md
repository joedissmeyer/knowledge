# Cheat Sheet for Gitlab Runner configuration

## Article description

This article describes the process on how to install and configure the Gitlab Runner on a RHEL or Windows server.

## Audience

Admins

## Process Flow - Linux Installation and Configuration

> Note: Make special note of having to deal with directory permissions. When running shell mode, you will have to grant read/write permissions to the proper directory.


1. Download and install the Gitlab runner on the server.

```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
yum -y install gitlab-runner
```

2. Next step is to register the runner for your project.

You will need to find the CI/CD settings for your project before continuing. To find them, log into Gitlab web UI and view your project.

Click Settings > CI/CD > Expand Runners Settings. You need the URL and the registration token displayed onscreen.

3. Execute the Gitlab runner registration process. Follow the onscreen prompts.

```
gitlab-runner register
```

An examples of the registration are below.

```
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
https://gitlab.use.ucdp.net/
Please enter the gitlab-ci token for this runner:
REPLACE_WITH_PROJECT_TOKEN
Please enter the gitlab-ci description for this runner:
[myhost]:
Please enter the gitlab-ci tags for this runner (comma separated):
tag1, tag2, tag3, etc
Whether to run untagged builds [true/false]:
[false]: false
Whether to lock the Runner to current project [true/false]:
[true]: false

Registering runner... succeeded                     runner=uKEcwvXs
Please enter the executor: docker, parallels, virtualbox, docker+machine, docker-ssh+machine, kubernetes, docker-ssh, shell, ssh:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

At this point the gitlab runner is now installed and configured for your project!

Final steps is to create a new ```.gitlab-ci.yml``` file in the root directory of your project and configure it. Configuring this file is beyond the scope of this article.
Use official documentation for guidance. https://docs.gitlab.com/ee/ci/yaml/

### Pro-tips - Gitlab-Runner on CentOS/RHEL:

The Gitlab runner service still needs permissions in order to do anything on a server.
To grant permissions to a folder, grant the rights using ```chmod``` prior to running the gitlab_runner job:
```
chmod -R 777 /etc/logstash/
```

To add the gitlab-runner local account to an existing security group (such as 'logstash' or 'elasticsearch') use 'usermod':
```
sudo usermod -aG logstash gitlab-runner
```

In order to allow gitlab-runner user to restart a service you must add two lines to the VISUDO file:

```
Defaults:gitlab-runner !requiretty
%logstash ALL=NOPASSWD: /bin/systemctl restart logstash
```

> Edit the sudo file by executing ```dzdo visudo```. This will open the sudoers file in nano instead of vim.

## Process Flow - Windows Installation and Configuration

*WIP*
1. Download and install Git for Windows - https://git-scm.com/download/win
2. Create a folder for the Gitlab runner - `mkdir d:\gitlab-runner\`
3. Download the latest gitlab-runner binary to the new folder created in step 2.
4. Next step is to register the runner for your project.

You will need to find the CI/CD settings for your project before continuing. To find them, log into Gitlab web UI and view your project.

Click Settings > CI/CD > Expand Runners Settings. You need the URL and the registration token displayed onscreen.


## Resources
Install Gitlab Runner on Windows - https://docs.gitlab.com/runner/install/windows.html