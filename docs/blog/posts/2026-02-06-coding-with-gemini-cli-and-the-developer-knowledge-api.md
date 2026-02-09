---
draft: false
date: 2026-02-06
authors:
  - xbill9
categories:
  - Google Cloud
  - AI & ML
---

# Coding with Gemini CLI and the Developer Knowledge API

Enabling The Developer API support with MCP to streamline Google Cloud Development          ...

<!-- more -->

#### Enabling The Developer API support with MCP to streamline Google Cloud Development

![](https://cdn-images-1.medium.com/max/1024/1*PYp64_ptd9vlMvGGD8N_Bg.jpeg)

#### What is this Tutorial Trying to Do?

The goal of the tutorial is to use Gemini CLI as a MCP client for secure access to the MCP enabled Developer Knowledge API to enhance the quality of the context window in Gemini CLI.

#### What is the Developer Knowledge API?

The **Developer Knowledge API** is a service provided by Google that offers programmatic, machine-readable access to Google’s public developer documentation. Announced in February 2026, it is specifically designed to provide current and authoritative documentation to AI-powered development tools and workflows, ensuring they have access to the latest information.

Announcement details are available here:

[Introducing the Developer Knowledge API and MCP Server](https://developers.googleblog.com/introducing-the-developer-knowledge-api-and-mcp-server/)

#### So how does this Secret Sauce work? Hold the Pickles? Hold the Lettuce?

The Developer Knowledge MCP server is an online real-time tool that can work directly with Gemini CLI. Conceptually- the MCP server provides access to a single source of truth for Google Products and Documentation.

The full product page is available here:

[Developer Knowledge API | Google for Developers](https://developers.google.com/knowledge/api)

#### So what else can it do? Does it slice? Does it dice?

There are few initial setup steps to enable the MCP server. A good starting point is here:

[Connect to the Developer Knowledge MCP server | Google for Developers](https://developers.google.com/knowledge/mcp#gcloud-cli)

#### Initial Environment Setup

The environment is meant to be run from a Bash like shell. You can run this from a Linux VM, ChromeOS Linux VM, Firebase Studio environment, or any environment that provides a basic shell.

#### Google Cloud CLI

The Google Cloud CLI provides direct access to Cloud Tools from your local environment. The basic setup instructions are here:

[Quickstart: Install the Google Cloud CLI | Google Cloud SDK | Google Cloud Documentation](https://docs.cloud.google.com/sdk/docs/install-sdk)

#### Gemini CLI

If not pre-installed you can install the Gemini CLI to interact with the source files and provide real-time assistance:

```
sudo npm install -g @google/gemini-cli
```

Note- if you are an a non standard environment — you will need to make sure to have at least Node version 20 available in order to run Gemini CLI.

#### Testing the CLI Environment from the VM

Once you have all the tools and the correct Node.js version in place- you can test the startup of Gemini CLI. You will need to authenticate with a Key or your Google Account:

```
gemini
```

![](https://cdn-images-1.medium.com/max/1024/1*ckuSTRHU6MGQMbg9Po64JA.png)

#### Clone the Repo and Get the Sample Scripts

Now that the Gemini CLI has been validated from the base shell — you can clone the GitHub Repo with support scripts:

```
cd ~
git clone https://github.com/xbill9/knowledge-api
```

Then run **init.sh** from the cloned directory. The script will attempt to determine your shell environment and set the correct variables:

```
cd knowledge-api
source init.sh
```

If your session times out or you need to re-authenticate- you can run the **set\_env.sh** script to reset your environment variables:

```
cd knowledge-api
source set_env.sh
```

Variables like PROJECT\_ID need to be setup for use in the various scripts- so the set\_env script can be used to reset the environment if you time-out.

#### What Did I just Do!?

The basic environment setup is done in the init.sh script. This script enables the APIS, generates an API key and sets environment variables.

You can use Gemini CLI to validate:

```
✦ init.sh is the primary setup script for configuring your Google Cloud environment to use the Google Developer Knowledge MCP server. It
  performs the following actions:

   1. Project Configuration: Prompts you for your Google Cloud Project ID and saves it to ~/project_id.txt for persistence.
   2. Environment Initialization: Sources set_env.sh to export necessary variables like PROJECT_ID and REGION.
   3. API Enablement: Enables required Google Cloud services:
       * aiplatform.googleapis.com (Vertex AI)
       * developerknowledge.googleapis.com (Developer Knowledge API)
       * apikeys.googleapis.com (API Key management)
       * compute.googleapis.com
   4. MCP Activation: Specifically enables the Developer Knowledge MCP server via gcloud beta services mcp.
   5. API Key Management:
       * Creates a new API key named "DK API Key" if one doesn't exist.
       * Security: Restricts the key so it can only call the Developer Knowledge API.
       * Exports the key as $DK_API_KEY.
   6. Local Tool Integration:
       * Updates .gemini/settings.json (using jq) so the Gemini CLI can automatically use the MCP server.
       * Provides a one-liner command for users who also want to add the server to Claude Code.
   7. Auth Verification: Checks for Application Default Credentials (ADC) and prompts for login if you are running locally (outside of Cloud
      Shell/GCP VMs).

  Usage: You should run it using source ./init.sh to ensure the exported variables (like DK_API_KEY) stay active in your current terminal
  session.
```

After initial setup- the **set\_env.sh** refreshes the variables:

```
> what does set_env.sh do?
✦ set_env.sh correctly sets standard Google Cloud environment variables and project-specific keys required for this repository. Here is a
  breakdown of how it handles them:

   * Project Identification: It reads the Project ID from ~/project_id.txt, sets the active gcloud project, and exports PROJECT_ID,
     GOOGLE_CLOUD_PROJECT, and PROJECT_NUMBER.
   * Location: It defaults to us-central1 (or your $REGION override) and exports both GOOGLE_CLOUD_LOCATION and REGION.
   * Authentication: It verifies gcloud authentication and exports an ID_TOKEN for identity-based requests.
   * Developer Knowledge API: It dynamically retrieves the API key string for the key named "DK API Key" (created by init.sh) and exports it
     as DK_API_KEY.
   * Infrastructure Context: It attempts to identify the SERVICE_ACCOUNT_NAME and the current SHORT_SHA from git.

  Note: Since it uses gcloud commands to populate these variables, you must be authenticated (gcloud auth login) for it to succeed.
  Additionally, ensure you source the script (source ./set_env.sh) so the variables persist in your current shell session.
```

#### How does Gemini CLI use this?

The Developer Knowledge API is built in to the local **settings.json** :

```
{
  "mcpServers": {
    "google-dev-knowledge": {
      "httpUrl": "https://developerknowledge.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "$DK_API_KEY"
      }
    }
  }
}
```

This setup can also be done as a Gemini CLI extension.

#### That was a lot of Setup! What next?

After your base environment has been configured- fire up Gemini CLI to verify access to the Knowledge API MCP server:

![](https://cdn-images-1.medium.com/max/1024/1*j3NaaGYVjB6m5WQOZb1IGA.png)

The API server exposes standard MCP tools:

```
> /mcp list
Configured MCP servers:

🟢 google-dev-knowledge - Ready (3 tools)
  Tools:
  - batch_get_documents
  - get_document
  - search_documents

```

#### Put this thing to Work!

Once the MCP server is available — it can be used directly with the current context in Gemini CLI:

```
 > what are the gcloud commands to create a google cloud bucket?
╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Action Required 1 of 1 │
│ │
│ ? search_documents (google-dev-knowledge MCP Server) {"query":"gcloud storage buckets create"} │
│ │
│ MCP Server: google-dev-knowledge │
│ Tool: search_documents │
│ Allow execution of MCP tool "search_documents" from server "google-dev-knowledge"? │
│ │
│ 1. Allow once │
│ 2. Allow tool for this session │
│ 3. Allow all server tools for this session │
│ ● 4. Allow tool for all future sessions │
│ 5. No, suggest changes (esc) │
│ │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

✦ To create a Google Cloud Storage bucket using the gcloud CLI, use the gcloud storage buckets create command:

  Basic Command
   1 gcloud storage buckets create gs://BUCKET_NAME

  Common Options
  You can include additional flags to specify the location, storage class, and access control:

   1 gcloud storage buckets create gs://BUCKET_NAME \
   2 --location=US-EAST1 \
   3 --storage-class=STANDARD \
   4 --uniform-bucket-level-access

  Key Flags
   * `--location`: Sets the geographic location (e.g., US, EU, asia-northeast1).
   * `--storage-class`: Defines the default storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE).
   * `--uniform-bucket-level-access`: Ensures access is managed via IAM policies at the bucket level (highly recommended).
   * `--project`: Specifies the project ID if it differs from your default configuration.

  Note: Bucket names must be globally unique across all of Google Cloud.
```

the Knowledge API MCP server can even get a bit Meta!

```
> what is the Google Developer Knowledge API?
✦ I'll look through the project documentation to find a definition of the Google Developer Knowledge API.

╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ ReadFile GEMINI.md │
│ │
│ │
│ ✓ ReadFile README.md │
│ │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ The Google Developer Knowledge API (accessible via the MCP server https://developerknowledge.googleapis.com/mcp) provides direct access to
  Google's official developer documentation—including Android, Google Cloud, Firebase, and more—within your LLM environment.

  In this project, it is primarily used through the Model Context Protocol (MCP), allowing the Gemini CLI to:
   * Search documentation: Find relevant guides, API references, and best practices.
   * Retrieve content: Pull specific document details to provide accurate, up-to-date information about Google technologies.

  This repository automates the GCP setup (API enablement and key creation) needed to use these tools.
```

#### Summary

The Developer Knowledge API server was configured in a local environment. A sample setup script —  **init.sh** was provided to provide the local development environment with the necessary system variables and APIS to interact with the remote server securely via MCP. This connection was tested and validated with the local copy of Gemini CLI. Several Google Cloud specific questions were presented and Gemini CLI used the MCP server to enhance the information in the current context.

---

*Originally published at [dev.to](https://xbill999.medium.com/coding-with-gemini-cli-and-the-developer-knowledge-api-006503eceb8e)*
