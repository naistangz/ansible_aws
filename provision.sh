#!/bin/bash

# Setting up controller virtual machine (AWS)
# A controller manages or directs the flow of data

  # Apt - Advanced packaged tool, command line tool to interact with packaging system such as installing, removing and updating packages
  sudo apt-get update

  # This software provides an abstraction of the used apt repositories and allows you to easily manage your distribution and independent software vendor software sources
  sudo apt-get install software-properties-common -y

  # apt-add-repository is a Python script that allows you to add an APT repository
  sudo apt-add-repository --yes --update ppa:ansible/ansible

  # Installing packages within the ansible repository
  # Tree is a recursive directory listing command and lists an indented listing of files
  sudo apt-get install tree -y

  # Installing Ansible
  sudo apt-get install ansible -y
