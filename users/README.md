## Description

This Ansible role has three primary functions: -

- Change sudoers to ensure the group sudo does not require a password. Sudo is the default group for all permitted users.
- Add permitted users to a remote node and populate their `~/.ssh/authorized_keys` file with the public keys taken for the users/files Directory.
- Check the list of user accounts on the remote node against the permitted list and white listed accounts. Delete any account that is not found within those listed.

## How to use

Clone this role within your roles folder, and add the following to your playbook: -
```
roles:
    - users
```

## Variables

| Variable | Type | Defined | Description |
|---|---|---|---|
| ssh_users | Array | vars/main.yml  | This array stores the username, public key path, and groups the user belongs to |
| white_listed_users | Array | vars/main.yml  | This array stores the username and white listed users to be ignored if discovered on the remote node. |

An example of a user: -
```
ssh_users:
  - name: dummeyuser1
    key: "{{ lookup('file', 'files/dummyuser1.pub') }}"
    groups: sudo
```
An example of a white listed user: -
```
white_listed_users:
  - name: vagrant
```

## Deleting invalid Users

When this role has completed creating all the users defined within the array `ssh_users`,  Two text files are then created on the remote node. These are: -

* `/root/permitted_users.txt`  This file contains a list of all permitted and whitelisted users, and is created using the `ssh_users` and `white_listed_users` arrays.
* `/root/discovered_users.txt` This file contains a list of all accounts discovered on the remote node, excluding the following: -
  * Any account which does not have shell login, i.e. system and application accounts.

The bash script `files/delete_users.sh` is then uploaded and run. This script subtracts the list of permitted users from the list of discovered users, and then delete's the accounts of the remaining users.

## Directory Structure
```
role_name/
        tasks/
            main.yml
        handlers/
            main.yml
        templates/
            { No Files }
        files/
            delete_users.sh # Script to delete unwanted users
            sudoers # sudoers file to be copied onto the remote node
            {username}.pub # Users public keys
        vars/
            main.yml # Permitted & whitelisted users are defined here
        defaults/
            main.yml
        meta/
            main.yml
```
