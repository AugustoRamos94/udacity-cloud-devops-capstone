eksctl create cluster --name kubeClusters --version 1.14 --region us-west-2 --nodegroup-name node-groups --node-type t2.small --nodes 2 --nodes-min 1 --nodes-max 4 --managed

aws eks --region us-west-2 update-kubeconfig --name kubeClusters
