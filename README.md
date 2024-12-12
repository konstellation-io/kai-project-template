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
   - Deploy KAI locally using `kaictl.sh` script, avoid errors for a previous version installed using flag `dracarys`.
        ```bash
        ./kaictl.sh dev --dracarys
        ```

2. **Create a User in Keycloak**:
   - Access the Keycloak admin console (`auth.kai.local`) using the administrator credentials.
   - Create a new user in the Konstellation realm and assign them to the `admin` group.
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
4. **When start product**
   - When you create a product and want to start it, you need to include information about email, name and surname in the Keycloak (`auth.kai.local`) user (`kai-project-template`) auto-generated. If not, minio will not initialize corretly.
