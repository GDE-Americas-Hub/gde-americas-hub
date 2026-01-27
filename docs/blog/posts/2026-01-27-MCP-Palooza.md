---
title: Welcome to MCP-P-A-looza
published: true
series: MCP-Palooza
date: 2026-01-20
tags: softwaredevelopment,googlecloud,aiagentdevelopment,mcps
canonical_url: https://medium.com/@xbill999/welcome-to-mcp-p-a-looza-70810aa3d8f3
---

An overview of current Model Context Protocol (MCP) implementations across the programming landscape.

![](https://cdn-images-1.medium.com/max/1024/1*lyUJ4m5cDE4urkiHldd47A.jpeg)

#### Why not just use Python?

Python has traditionally been the main coding language for ML and AI tools. One of the strengths of the MCP protocol is that the actual implementation details are independent of the development language. The reality is that not every project is coded in Python- and MCP allows you to use the latest AI approaches with other coding languages.

#### But I thought all I needed was FastMCP!

**FastMCP (Model Context Protocol)** is a Python framework for building production-ready servers. It provides a great framework for developing Python MCP applications. However- FastMCP is Python specific. You can’t use FastMCP directly with other languages like Rust, Java, C, etc.

#### What are all these SDKs and where do they come from?

There are basically two types of SDKs- official and unofficial.

The Official MCP SDKs are here:

[SDKs - Model Context Protocol](https://modelcontextprotocol.io/docs/sdk)

Some unofficial SDKs include:

C++:

[GitHub - hkr04/cpp-mcp: Lightweight C++ MCP (Model Context Protocol) SDK](https://github.com/hkr04/cpp-mcp)

C:

[GitHub - micl2e2/mcpc: Cross-platform C SDK for Model Context Protocol (MCP), in modern🚀 C23.](https://github.com/micl2e2/mcpc)

Haskell:

[mcp](https://hackage.haskell.org/package/mcp)

#### So what does an MCP SDK really Do?

The key thing that a MCP SDK provides is an organized approach that is idiomatic to the language. Each language has conventions for coding, testing, and tool sets. The MCP protocol itself has several key components, and conventions. Most language specific SDKs implement at least the key features of the protocol consistently with the language idioms. These protocol features include the Client/Server architecture, tooling, and server transports.

The full specification can be found here:

[Specification - Model Context Protocol](https://modelcontextprotocol.io/specification/2025-06-18)

The key feature that a language specific SDK provides is a bridging between the idiomatic language features and the common MCP conventions.

#### Sample of Current Language SDKs

Some of the “mainstream” languages include:

- TypeScript / JavaScript
- Python
- Java
- C#
- Go
- Kotlin
- Swift
- Ruby
- Rust
- PHP

#### Gemini CLI

Gemini CLI is the Swiss army knife that links all this together. If not pre-installed you can download the Gemini CLI to interact with the source files and provide real-time assistance:

```
npm install -g @google/gemini-cli
```

#### Testing the Gemini CLI Environment

Once you have all the tools and the correct Node.js version in place- you can test the startup of Gemini CLI. You will need to authenticate with a Key or your Google Account:

```
gemini
```

![](https://cdn-images-1.medium.com/max/1024/1*ckuSTRHU6MGQMbg9Po64JA.png)

#### Node Version Management

Gemini CLI needs a consistent, up to date version of Node. The **nvm** command can be used to get a standard Node environment:

[GitHub - nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions](https://github.com/nvm-sh/nvm)

#### What does Gemini CLI have to do with MCP?

Gemini CLI provides a full MCP client for testing server implementations.

Beyond that — Gemini CLI provides powerful code generation functionality and customization via the **GEMINI.md** file that allows for targeted language specific MCP server code generation.

A sample **GEMINI.md** file looks similar to:

```
# Gemini Code Assistant Context

This document provides context for the Gemini Code Assistant to understand the project and assist in development.

## Project Overview

This is a **Haskell-based Model Context Protocol (MCP) server** using the `mcp-server` library. It is designed to expose tools (like `greet`) over HTTP for integration with MCP clients.

## Key Technologies

* **Language:** Haskell (GHC 9.10.1+)
* **Build System:** `cabal`
* **Libraries:**
    * `mcp-server`: For implementing the MCP protocol.
    * `aeson`: For JSON serialization.
    * `text`: For efficient text handling.

```

#### Non comprehensive list of Current MCP Articles

Recent articles about MCP development with different SDKs include:

C#  
 \* “Local MCP Development with .NET, C# and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-net-c-and-gemini-cli-444983a54b6d](https://medium.com/google-cloud/local-mcp-development-with-net-c-and-gemini-cli-444983a54b6d)  
 \* “MCP Development with .NET, C#, Cloud Run, and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-net-c-cloud-run-and-gemini-cli-e04f128c9462](https://medium.com/google-cloud/mcp-development-with-net-c-cloud-run-and-gemini-cli-e04f128c9462)  
 \* “MCP Development with Firestore, .NET, C# and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-firestore-net-c-and-gemini-cli-8f435012e125](https://medium.com/google-cloud/mcp-development-with-firestore-net-c-and-gemini-cli-8f435012e125)

Rust  
 \* “MCP Development with Cloud Run and the Google Cloud Rust SDK”:  
 [https://medium.com/google-cloud/mcp-development-with-cloud-run-and-the-google-cloud-rust-sdk-5749f997096d](https://medium.com/google-cloud/mcp-development-with-cloud-run-and-the-google-cloud-rust-sdk-5749f997096d)  
 \* “MCP Development with the Google Cloud Rust SDK and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-the-google-cloud-rust-sdk-and-gemini-cli-8010b991316b](https://medium.com/google-cloud/mcp-development-with-the-google-cloud-rust-sdk-and-gemini-cli-8010b991316b)

Java  
 \* “Local MCP Development with Java and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-java-and-gemini-cli-3d752f901d83](https://medium.com/google-cloud/local-mcp-development-with-java-and-gemini-cli-3d752f901d83)

Kotlin  
 \* “Local MCP Development with Kotlin and Gemini CLI”:  
 [https://proandroiddev.com/local-mcp-development-with-kotlin-and-gemini-cli-819a8618ebc2](https://proandroiddev.com/local-mcp-development-with-kotlin-and-gemini-cli-819a8618ebc2)

PHP  
 \* “MCP Development with PHP, Cloud Run, and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-php-cloud-run-and-gemini-cli-39a06180376d](https://medium.com/google-cloud/mcp-development-with-php-cloud-run-and-gemini-cli-39a06180376d)  
 \* “Local MCP Development with PHP and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-php-and-gemini-cli-5c3175402422](https://medium.com/google-cloud/local-mcp-development-with-php-and-gemini-cli-5c3175402422)

Swift  
 \* “Local MCP Development with Swift, Firestore, and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-swift-firestore-and-gemini-cli-08343715c0e7](https://medium.com/google-cloud/local-mcp-development-with-swift-firestore-and-gemini-cli-08343715c0e7)  
 \* “MCP Development with Swift, Firestore, Cloud Run, and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-swift-firestore-cloud-run-and-gemini-cli-9d62d2948b8b](https://medium.com/google-cloud/mcp-development-with-swift-firestore-cloud-run-and-gemini-cli-9d62d2948b8b)

Python  
 \* “MCP Development with FireStore, Cloud Run, and Gemini CLI”:  
 [https://python.plainenglish.io/mcp-development-with-firestore-cloud-run-and-gemini-cli-101736152b12](https://python.plainenglish.io/mcp-development-with-firestore-cloud-run-and-gemini-cli-101736152b12)

Ruby  
 \* “MCP Development with Ruby and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-ruby-and-gemini-cli-76707324395e](https://medium.com/google-cloud/mcp-development-with-ruby-and-gemini-cli-76707324395e)  
 \* “Local MCP Development with Ruby and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-ruby-and-gemini-cli-5114757519a8](https://medium.com/google-cloud/local-mcp-development-with-ruby-and-gemini-cli-5114757519a8)

C  
 \* “Local MCP Development with C and Gemini CLI”:  
 [https://medium.com/google-cloud/local-mcp-development-with-c-and-gemini-cli-896827059c40](https://medium.com/google-cloud/local-mcp-development-with-c-and-gemini-cli-896827059c40)  
 \* “MCP Development with C, Cloud Run, and Gemini CLI”:  
 [https://medium.com/google-cloud/mcp-development-with-c-cloud-run-and-gemini-cli-be6073105740](https://medium.com/google-cloud/mcp-development-with-c-cloud-run-and-gemini-cli-be6073105740)

### Google Tech Conventions

Beyond Gemini CLI — Google Cloud provides the background tooling and infrastructure to run the MCP projects. Here is a brief summary:

#### Cloud Projects

Centralized organization of key project data such as APIS, SDK Keys, and the base Vertex AI model functionality

#### Cloud Run

Server less deployment of containers with scale to 0.

#### Cloud Build

Standardized, repeatable build tools for consistent DevOps.

#### gcloud Utility

The gcloud utility provides a predictable well defined tool for interacting with cloud resources.

#### Cloud Authentication

Application Default Credentials (ADC) allow secure development and deployment across environments.

#### Cloud Logging

Standardized JSON logging to stderr provides visibility with Google Cloud native logging.

### Where do I start?

The strategy for starting MCP development is a incremental step by step approach. As an example — here is a walkthrough for building a C language MCP server.

First, the basic development environment is setup with the required system variables, and a working Gemini CLI configuration.

Then, a minimal Hello World Style C MCP Server is built with stdio transport. This server is validated with Gemini CLI in the local environment.

This setup validates the connection from Gemini CLI to the local process via MCP. The MCP client (Gemini CLI) and the MCP server both run in the same local environment.

The sample code is then refactored to use the MCP HTTP transport in the local environment.

Next — the MCP server with HTTP transport is containerized and deployed to Google Cloud Run.

This deployment is verified with the local Gemini CLI.

#### Setup the Basic Environment

At this point you should have a working language environment and a working Gemini CLI installation. The next step is to clone the GitHub samples repository with support scripts:

```
cd ~
git clone https://github.com/xbill9/gemini-cli-codeassist
```

Then run **init.sh** from the cloned directory.

The script will attempt to determine your shell environment and set the correct variables:

```
cd gemini-cli-codeassist
source init.sh
```

If your session times out or you need to re-authenticate- you can run the **set\_env.sh** script to reset your environment variables:

```
cd gemini-cli-codeassist
source set_env.sh
```

Variables like PROJECT\_ID need to be setup for use in the various build scripts- so the set\_env script can be used to reset the environment if you time-out.

#### Hello World with HTTP Transport

One of the key features that the standard MCP libraries provide is abstracting various transport methods.

The high level MCP tool implementation is the same no matter what low level transport channel/method that the MCP Client uses to connect to a MCP Server.

The simplest transport that the SDK supports is the stdio (stdio/stdout) transport — which connects a locally running process. Both the MCP client and MCP Server must be running in the same environment.

The HTTP transport allows the client and server to be on the same machine or distributed over the Internet.

#### Package Information

The language specific code will use standard libraries for MCP functions and logging.

For example — the C implementation will look like this:

```
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/utsname.h>
#include <time.h>
#include "mcpc/mcpc.h"
```

#### Installing and Running the Code

Makefiles have been pre-built on a language by language basis.

```
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$ make
cc -std=c17 -Wall -Wextra -Imcpc -DMCPC_C23PTCH_KW1 -DMCPC_C23PTCH_CKD1 -DMCPC_C23PTCH_UCHAR1 -DMCPC_C23GIVUP_FIXENUM -O2 -c main.c
make -C mcpc 
make[1]: Entering directory '/home/xbill/gemini-cli-codeassist/mcp-https-c/mcpc'
make[2]: Entering directory '/home/xbill/gemini-cli-codeassist/mcp-https-c/mcpc/src'
cc -Dis_unix -std=c17 -DMCPC_C23PTCH_KW1 -DMCPC_C23PTCH_CKD1 -DMCPC_C23PTCH_UCHAR1 -DMCPC_C23GIVUP_FIXENUM -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-parameter -Wno-unused-label -Wno-error=unused-variable -Wno-error=unused-but-set-variable -O2 -Os -I.. -fPIC alloc.c log.c errcode.c anydata.c tool.c rsc.c prmpt.c server.c retbuf.c ucbr.c complt.c serlz.c mjson.c -c 
ar rcs libmcpc.a alloc.o log.o errcode.o anydata.o tool.o rsc.o prmpt.o server.o retbuf.o ucbr.o complt.o serlz.o mjson.o 
cc -s -o libmcpc.so alloc.o log.o errcode.o anydata.o tool.o rsc.o prmpt.o server.o retbuf.o ucbr.o complt.o serlz.o mjson.o -shared ../src/libmcpc.a 
make[2]: Leaving directory '/home/xbill/gemini-cli-codeassist/mcp-https-c/mcpc/src'
make[1]: Leaving directory '/home/xbill/gemini-cli-codeassist/mcp-https-c/mcpc'
cc -o server main.o mcpc/src/libmcpc.a -lpthread
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$
```

If the language provides review tools — targets to lint the code are provided:

```
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$ make lint
cc -std=c17 -Wall -Wextra -Imcpc -DMCPC_C23PTCH_KW1 -DMCPC_C23PTCH_CKD1 -DMCPC_C23PTCH_UCHAR1 -DMCPC_C23GIVUP_FIXENUM -Wpedantic -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes -fsyntax-only main.c
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$
```

Test cases and Makefile targets are provided where available:

```
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$ make test
python3 test_server.py
Testing server tools (TCP)...
✓ initialize
✓ notifications/initialized
✓ tools/list
✓ tools/call (greet)
✓ tools/call (get_system_info)
✓ tools/call (get_server_info)
✓ tools/call (get_current_time)
✓ tools/call (mcpc-info)
All tests passed!
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$
```

#### Gemini CLI settings.json

The default Gemini CLI settings.json customized for each language has an entry for the source:

```
{
    "mcpServers": {
    "hello-https-c": {
      "httpUrl": "http://127.0.0.1:8080"
    }
  }
}
```

#### Deploying to Cloud Run

After the HTTP version of the MCP server has been tested locally — sample scripts — including cloudbuild.yaml and a Dockerfile are provided to allow language specific deployment.

There are two major types of deployment- an interpreted deployment like Python or a compiled binary deployment like Rust, C++, or C.

The build process is similar to:

```
cd ~/gemini-cli-codeassist/mcp-https-c
```

Deploy the project to Google Cloud Run with the pre-built **cloudbuild.yaml** and **Dockerfile:**

```
cd ~/gemini-cli-codeassist/mcp-https-c
xbill@penguin:~/gemini-cli-codeassist/mcp-https-c$ make deploy
```

The Cloud Build will start:

```
✦ I will execute make deploy to build the application image and deploy it to Google Cloud Run.
╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ⊷ Shell make deploy [current working directory /home/xbill/gemini-cli-codeassist/mcp-https-c] (Submitting build to Google Cl… │
│ │
│ Created [https://cloudbuild.googleapis.com/v1/projects/comglitn/locations/global/builds/25cf0d42-76fb-46bd-86cb-a05 │
│ 1d405d28b]. │
│ Logs are available at [ https://console.cloud.google.com/cloud-build/builds/25cf0d42-76fb-46bd-86cb-a051d405d28b?pr │
│ oject=1056842563084 ]. │
│ Waiting for build to complete. Polling interval: 1 second(s). │
│ ----------------------------------------------- REMOTE BUILD OUTPUT ----------------------------------------------- │
│ starting build "25cf0d42-76fb-46bd-86cb-a051d405d28b" │
│ │
│ FETCHSOURCE │
│ Fetching storage object: gs://comglitn_cloudbuild/source/1768433159.604977-e04880e209954e96ae80e073ab789d9b.tgz#176 │
│ 8433160802906 │
│ │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

**It can take 15–30 minutes to complete the build.**

The cloud build needs to pull in all the required C libraries in the build environment and generate the entire package from scratch.

When the build is complete- an endpoint will be returned:

```
│ Starting Step #1 │
│ Step #1: Already have image (with digest): gcr.io/cloud-builders/gcloud │
│ Step #1: Deploying container to Cloud Run service [mcp-https-c] in project [comglitn] region [us-central1] │
│ Step #1: Deploying... │
│ Step #1: Setting IAM Policy............done │
│ Step #1: Creating Revision...........................................................done │
│ Step #1: Routing traffic.....done │
│ Step #1: Done. │
│ Step #1: Service [mcp-https-c] revision [mcp-https-c-00002-qhs] has been deployed and is serving 100 percent of traffic. │
│ Step #1: Service URL: https://mcp-https-c-1056842563084.us-central1.run.app │
│ Finished Step #1 │
│ PUSH │
```

The service endpoint in this example is :

```
https://mcp-https-c-1056842563084.us-central1.run.app
```

The actual endpoint will vary based on your project settings.

#### Review Service in Cloud Run

Navigate to the Google Cloud console and search for Cloud Run -

![](https://cdn-images-1.medium.com/max/1024/1*wSvDZFBhgsZiQYwO9bz7Zg.png)

and then you can detailed information on the Cloud Run Service:

![](https://cdn-images-1.medium.com/max/1024/1*2gOiPzQoODqi4sP1i-A0Zg.png)

#### Cloud Logging

The remote server writes logs to **stderr** in standard JSON format. These logs are available from the deployed Cloud Run Service:

![](https://cdn-images-1.medium.com/max/1024/1*hAFzj1iPZaCVH_5-0jYi3w.png)

#### Validate HTTP connection

Once you have the Endpoint — you can attempt a connection- navigate to in your browser:

```
https://mcp-https-c-1056842563084.us-central1.run.app
```

You will need to adjust the exact URL to match the URL returned from Cloud Build.

### GitHub Repo Summary

The language implementations are in one large mono-repo:

[GitHub - xbill9/gemini-cli-codeassist: Rust Coding with Gemini CLI](https://github.com/xbill9/gemini-cli-codeassist)

Here are the details:

#### Cymbal Superstore & MCP Monorepo

This monorepo is an evolution of the Cymbal Superstore sample application, showcasing a modern microservices architecture integrated with the Model Context Protocol (MCP) and Google Cloud Platform (GCP). It provides a comprehensive set of examples across multiple programming languages for building intelligent, tool-using agents.

#### Core Concepts

#### Cymbal Superstore

Originally a sample e-commerce application, this project now serves as the foundation for demonstrating:

- Inventory Management: Managing products via Google Cloud Firestore.
- Cloud-Native Deployment: Using Docker, Cloud Build, and Cloud Run.
- AI Integration: Exposing business logic as MCP tools for LLMs (like Gemini and Claude).

#### Model Context Protocol (MCP)

The repo contains dozens of MCP server implementations, allowing AI models to interact with the Cymbal Superstore inventory or perform utility tasks.

### Project Categories

#### 1. MCP Servers (Inventory & Utilities)

These servers expose tools to MCP clients via Stdio or HTTPS (SSE).

- Firestore Inventory Servers (firestore-\*):
- Manage the Cymbal Superstore inventory.
- Languages: C#, Flutter, Go, Java, Kotlin, PHP, Python, Ruby, Rust, TypeScript.
- Transports: stdio (local), https (Cloud Run).
- Basic MCP Servers (mcp-\*):
- Simple “Hello World” examples exposing a greet tool.
- Languages: All major languages including Swift and Dart/Flutter.

#### AI Assistant Integration

Most subdirectories include a GEMINI.md file. These files provide specialized context for AI assistants (like Gemini) to understand the specific project's architecture, technologies, and development workflow. If you are using this repo with an AI assistant, it is highly recommended to reference these files.

#### Directory Naming Convention

- firestore-[transport]-[lang]: Inventory tool using Firestore.
- mcp-[transport]-[lang]: Basic tool implementation.
- gcp-[name]-rust: Specific GCP feature demonstration in Rust.

### Final Words

This is an evolving landscape- MCP specifications are evolving and each language implementation continues to be updated. Gemini- CLI itself continuously updates as new pull requests are approved.

But the bottom line is — whether you are a MCP Stan or still somewhat skeptical of the technology — the cat is out of the bag and it is not getting back in anytime soon!

