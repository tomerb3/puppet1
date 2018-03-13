#THis need to be located in the puppet repo /opt/stash-data/data/repositories/<repo ID>/hooks/post-receive.d
#/opt/stash-hooks/puppet-post-receive.sh -d  '<puppet server IP/FQDN' -f '<PATH/TO/ENV' -r '<stash repo URL>' -i '<SSH id_rsa file to use>' -u 'root'
/git/puppet.git/hooks/commit_hooks/puppet-post-receive.sh -d  'localhost' -f '/etc/puppetlabs/code/environments/' -r 'git@alis-dsg-pupms:/git/puppet.git' -i '/root/.ssh/id_rsa' -u 'root'
