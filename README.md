# Windows Server 2016 Insider with Docker

This is a special version of my [windows-docker-machine](https://github.com/StefanScherer/windows-docker-machine) repo for the Windows Server Insider Preview. Get in touch with Windows Containers and the much smaller nanoserver-insider Docker image on your Mac, Linux or Windows machine.

![Docker Machine with Insider](images/insider_docker_machine.png)

It is tested on a Mac with the following steps.

1. Register at Windows Insider program https://insider.windows.com

2. Download the Windows Server ISO from https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewserver?wa=wsignin1.0

3. Build the Vagrant basebox with Packer

```bash
git clone https://github.com/StefanScherer/packer-windows
cd packer-windows
packer build --only=vmware-iso --var iso_url=~/Downloads/Windows_InsiderPreview_Server_2_16237.iso windows_2016_insider.json
vagrant box add windows_2016_insider windows_2016_insider_vmware.box
```

This Vagrant basebox has Docker 17.06.0 CE installed and the following base images are already pulled from Docker Hub:

  * microsoft/windowsservercore-insider
  * microsoft/nanoserver-insider
  * microsoft/nanoserver-insider-powershell

There is also some languages and runtimes available as insider images:

   * microsoft/nanoserver-insider-dotnet
   * stefanscherer/node-windows:6.11.1-insider
   * stefanscherer/node-windows:8.1.4-insider
   * stefanscherer/golang-windows:1.8.3-insider

4. Boot the VM

```
git clone https://github.com/StefanScherer/insider-docker-machine
cd insider-docker-machine
vagrant up
```

It will create TLS certs and create a Docker Machine entry "insider" so you can
switch very easily between Docker 4 Mac/Win and this Insider VM.

5. Switch to the Insider Docker machine

```
eval $(docker-machine env insider)
docker version
docker images
```

6. Switch back to Docker for Mac/Windows

```
eval $(docker-machine env -unset)
```
