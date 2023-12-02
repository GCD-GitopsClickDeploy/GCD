# GCD -  Gitops Click Deploy
GCD is a project created by two students who wanted to facilitate GitOps-based distribution through EKS.

# GCD Docs
All detailed explanations for using GCD are written in the link below.

Simply put, you can use the service by installing aws cli, answerable, terraform, argocd cli, creating GCD yaml, and generating various tokens.

https://gitops-click-deploy-gcd.gitbook.io/main/

# GCD Command

All comments must be made on the root where the gcd file is located.

```
gcd init
``` 
- EKS, enable EFS provisioning.

```
gcd start
```
- playbooks의 gcd.Run gcd init, gcd tekton, and gcd argocd through the yaml file.
```
gcd add
```
- playbooks의 gcd.Through the yaml file, define the CRD for Tekton and Argocd and create Pipeline.

```
gcd tekton
```
- Information such as Tekton, Tekton-polling-operator, and Task, Pipeline, and Serect required for image build and repository push is gcd.Install via helm based on yaml.

```
gcd argocd
``` 
- gcd the CRD required for argocd and deployment.Install based on yaml.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

