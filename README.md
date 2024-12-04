# kai-project-template

This is a template for a new project in the kai ecosystem. It includes a basic project structure.

## Usage

To use this template, click the "Use this template" button on the GitHub page. This will create a new repository with the same structure as this one.

## Structure

TBD

## Documentation index

TBD

## Setting up Local Infrastructure

This section describe the step by step process to setup the local infrastructure for testing the project.

---

### Prerequisites

Before starting, make sure to meet the following requirements:

1. **Install local KAI**:
   - Verify that all necessary components [KAI Requirements](https://github.com/konstellation-io/kai?tab=readme-ov-file#requirements) are installed. There is no specific version until now.
   - Download the latest version of KAI from the [github](https://github.com/konstellation-io/kai) repository.
   - Deploy KAI locally using `kaictl.sh` script, avoid errors for a previous version installed using flag `drakarys`.
        ```bash  
        ./kaictl.sh dev --drakarys  
        ``` 
   - Modify the `/etc/hosts` file to include the following line, ensuring that `auth.kai.local` points to your `minikube` IP address:  
        ```bash  
        <MINIKUBE_IP> auth.kai.local  
        ```

2. **Create a User in Keycloak**:
   - Access the Keycloak admin console (`auth.kai.loal`) using the administrator credentials.
   - Create a new user and assign them to the `admin` group.
   - Remove refresh token from the user created.

3. **Install Kai-Kli**:
   - If `Go` is not installed, install it. There is no specific version until now.
   - At this moment there is no binary release, so you need to generate the `kai-kli` binary locally by download [github](https://github.com/konstellation-io/kai-kli) repository and running the following command in the repository root:
        ```bash  
        make generate  
        ```
   - Using the CLI generated in the previous step for create configuration for the KAI server created in the first step:
        ```bash  
        kli server add local kai.local --insecure   # Add the local server without security
        kli server login                            # Login to the server with the user created in Keycloak
        ```
   - In case of error, check `/etc/hosts` file and verify if this ips are correct:
        ```bash
        <MINIKUBE-IP> api.kai.local
        <MINIKUBE-IP> monitoring.kai.local
        <MINIKUBE-IP> auth.kai.local
        <MINIKUBE-IP> storage.kai.local
        <MINIKUBE-IP> storage-console.kai.local
        <MINIKUBE-IP> prometheus.kai.local
        <MINIKUBE-IP> registry.kai.local
        <MINIKUBE-IP> vault.kai.local
        ```